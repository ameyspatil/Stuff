	require LWP::UserAgent;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More "no_plan";
use Test::Exception;
use JSON::XS;

my $u1= $ARGV[0];
my $u2= $ARGV[1];
my ($username , $password , $env , $browser);

if ($u1 =~ m/dev/)
{
	$env="http://localhost:3000/";
}
elsif ($u1 =~ m/stg/)
{
	$env="http://jibepost.testbacon.com/";
	$username="resumes\@jibe.com";
	$password="jibejibe1124";
}
elsif ($u1 =~ m/prd/)
{
	$env="http://jibepost.jibe.com/";
	$username="amey\@jibe.com";
	$password="jibejibe1124";
}



if ($u2 =~ m/safari/)
{
	$browser="*safari";
}
elsif ($u2 =~ m/firefox/)
{
	$browser="*firefox";
}
elsif ($u2 =~ m/iexplore/)
{
	$browser="*iexplore";
}
elsif ($u2 =~ m/chrome/)
{
	$browser="*chrome";
}

my($title,$full_description,$compensation,$city,$state);
get_job_desc();

my $sel = Test::WWW::Selenium->new( host => "localhost", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "$env" );

#Login to Jibe Post
$sel->open_ok("/login","Jibe Post $u1 login page opens up");
$sel->type_ok("id=user_session_email", "$username","user enters Username");
$sel->type_ok("id=user_session_password", "$password","user enters password");
$sel->click_ok("css=input.btn.primary","User clicks on Sign in");
$sel->wait_for_text_present_ok("Sorry, we couldn't find a job","3000","Use successfully logs in $u1");

#Add a new Job
$sel->click_ok("link=New Job","Click on new job");
$sel->wait_for_text_present_ok("Job Title","3000","New job page is displayed");
my $html = $sel->get_html_source();
print "the html source is \n\n\n $html \n\n\n\n\n";

if ($html =~ m/.*listing_data[(.*?)]/ig)
{
	$html="listing_data["+$1+"][category]";
}
#Validation check

print "The category id is $html";
$sel->click_ok("link=Next");
$sel->is_text_present_ok("City is required","City Validation check is displayed");
$sel->is_text_present_ok("State is required","State Validation check is displayed");
$sel->is_text_present_ok("This field is required","Category Validation check is displayed");



$sel->type_ok("id=title", "$title","Enter the Job title in text field");
$sel->type_ok("id=apply_url", "apply Url");
$sel->type_ok("id=city", "Albany");
$sel->select_ok("id=state", "label=NY");
$sel->click_ok("link=Write new...");
$sel->type_ok("id=description", "$full_description","Enter the job description in text area");

$sel->pause("1500");
$sel->click_ok("link=Next");
#$sel->wait_for_text_present_ok("Where would you like to post","3000","Next page is displayed");






sub generate_random_number
{
	my $range = 800;
  	my $random_number = int(rand($range));
	return $random_number;
}
sub get_job_desc
{	
	my $ua = LWP::UserAgent->new;
    again:
   	my $job_id = generate_random_number(); 
    $ua->timeout(30);    
    $ua->env_proxy;
	my $response = $ua->get("http://jobservice1.jibe.com:8080/jobs/id/$job_id.json");
	my $actual_response=$response->decoded_content;
	my $perl_scalar = decode_json($actual_response);
    eval { $title= $perl_scalar->[0]->{title};};
	if($@) 
	{ 
	    if( ref $@ ) {
	        goto again;
	    }
	    else {
	        goto again;
	    }

	}
    $full_description= $perl_scalar->[0]->{full_description};
    $city= $perl_scalar->[0]->{city};
    $state= $perl_scalar->[0]->{state};
    $compensation="undisclosed";
}