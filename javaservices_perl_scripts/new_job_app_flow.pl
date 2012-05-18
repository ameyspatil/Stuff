use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More "no_plan";
use Test::Exception;
require LWP::UserAgent;
use JSON::XS;
use Redis;

my $dbindex;
my $redis_server_name;

my $u1= $ARGV[0];
my $u2= $ARGV[1];
my $u_env= 0;
my $j_env=0;
my $c_env=0;
my $browser= '';
my $counter;

if ($u1 =~ m/dev/)
{
	$u_env="http://localhost:3000/";
}
elsif ($u1 =~ m/stg/)
{
	$j_env="209.114.35.61:8080";#jobservice ip address
        $c_env="companyservice1.staging.jibe.com:8080";##"209.114.47.232:8080";#companyservice ip address
        $u_env='jibeqa:jibejibe1124@jibe.testbacon.com';
	$redis_server_name ='app1.testbacon.com:6379';
	$dbindex =2;
}
elsif ($u1 =~ m/prd/)
{
	$j_env="jobservice1.jibe.com:8080";
	$c_env="companyservice1.jibe.com:8080";##"209.114.47.232:8080";#companyservice ip address
    $u_env="www.jibe.com";
	$redis_server_name ='metal.jibe.com:6379';
	$dbindex=4;
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

my $sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "http://$u_env" );


my %tested_companies;
my $tmp_company_name;

$sel->start();
$sel->open_ok("jobs",'Open the home page');
$sel->set_speed("500");
$sel->wait_for_page_to_load("90000");
$sel->click_ok("//img[\@alt='LinkedIn']",'User cicks on linkedin login button');
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
if($sel->wait_for_page_to_load_ok("20000"))
	{
		$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
		$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
		$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
	}
$sel->select_window("null");
$sel->wait_for_text_present_ok("tweet","90000","User Successfully logs in");
$sel->window_maximize();

my $offset_count=0;
while ($offset_count < 174)
{
	get_company_id($offset_count);
	$offset_count = $offset_count + 25;
}


while ( my ($key, $value) = each(%tested_companies) ) {
        print "$key => $value\n\n";
    }

$sel->stop();

sub pages_two_and_three
{
    my ($slug) = @_;
    
    my $current_html=$sel->get_html_source();
   
    if($current_html =~ m/ZIP/)
    {
		$tested_companies{ $tmp_company_name } = "Job slug $slug - only loaded till Profile Edit";
		profile_page($slug);
		get_questions($slug);
		connections_page($slug);
    }	
    
    elsif ($current_html =~ m/basic employer questions/ || $current_html =~ m/There are no questions/)
    {   
		$tested_companies{ $tmp_company_name } = "Job slug $slug - only loaded till Questions page";
		get_questions($slug);
		connections_page($slug);
    }
    elsif ($current_html =~ m/Ask people you know/)
    {
		$tested_companies{ $tmp_company_name } = "Job slug $slug - only loaded till Connections Page";
		connections_page($slug);
    }
    elsif($current_html =~ m/Not done yet/)
    {
		$tested_companies{ $tmp_company_name } = "Job slug $slug - only loaded till review page";
		review_page($slug);
		$sel->click_ok("link=Edit","User clicks on profile edit button");
		profile_page($slug);
		get_questions($slug);
		#$sel->click_ok("link=Continue","User submits the connections page of the job application for $slug");
		connections_page($slug);
    }
    else
    {
    	$tested_companies{ $tmp_company_name } = "Job slug $slug - failed to load the new app flow in 30 seconds";
    	ok(0,"Job slug $slug - failed to load the new app flow in 30 seconds");
    	goto end;	
    }
    review_page($slug);
    $sel->click_ok("link=Cancel","User clicks on cancel on the final submit page");
    $sel->wait_for_text_present_ok("tweet","30000","Job is successfully Cancelled");
    $tested_companies{ $tmp_company_name } = "Job slug $slug - tested successfully";
    end:
    $sel->click_ok("link=JIBE");
    $sel->wait_for_text_present_ok("tweet","30000","Job is successfully Cancelled");
}

sub profile_page
{
    my ($tmp_slug) = @_;
    $sel->wait_for_text_present_ok("ZIP Code","Checking to see if the profile edit page is displayed");
    $sel->type_ok("application_data_email", "jibeqa\@gmail.com", "$tmp_slug Job Page - User enters job appication contact email id");
    $sel->type_ok("application_data_street_address", "Testing test","$tmp_slug Job Page - User enters street address");
    $sel->type_ok("application_data_phone_number", "223-456-7890","$tmp_slug Job Page - User enters the phone number");
    $sel->select_ok("application_data_resume_id", "label=140799_Resume_.pdf","$tmp_slug Job Page - User selects a pre-uploaded resume");
    $sel->select_ok("application_data_cover_letter_id", "label=cover_letter.pdf","$tmp_slug Job Page - User enters information in Job Application - Selects Cover Letter");
    $sel->select_ok("application_data_province_id", "label=New York", "$tmp_slug Job Page - User selects the state");
    $sel->click("//option[\@value='35']");
    $sel->type_ok("application_data_zip_code", "10013","$tmp_slug Job Page - User enters the zipcode");
    $sel->click_ok("//div[\@id='profile']/div[2]/a[2]","Applicant clicks on continue on page 1");	
 }
    
sub get_questions
{
    my ($tmp_slug) = @_;
    $sel->wait_for_element_present_ok("//div[\@id='questions']/div[2]/a[1]","$tmp_slug - User checks if the Continue Button is displayed on the connections page");
    my $ua = LWP::UserAgent->new;
    $ua->timeout(30);
    $ua->env_proxy; 
    my $response = $ua->get("http://$j_env/jobs/slug/$tmp_slug/user/52416373/questions.json");
    my $actual_response=$response->decoded_content;
    my $perl_scalar = decode_json($actual_response);
    my $hello=0;
    foreach (@{$perl_scalar->[0]->{questions}})
        {
                my $question=$_;
                
                $hello++;
                  if ($question =~ m/type=\"text\"/i)
                          {
                                if($question =~ m/id=\"(.*?)\"/)
                                {
									my $number=$1;
									my $particular='company_questions[editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-careerSectionEducationForm-educationFragmentIter-0-_id161-dv_cs_education_Institution][]';
									if ($question =~ m/\Q$particular/i)	
									{
										$sel->type_ok("$number", "Aalborg Universitet","This is a textbox input for question Number:$hello for slug=$tmp_slug");
									}
									else
									{
										if ($question =~ m/date/i)
										   {
										   	$sel->type_ok("$number", "12/12/2012","This is a text area input - type date for question Number:$hello for slug=$tmp_slug");
										   }
										   else
										   {
										   	$sel->type_ok("$number", "100000","This is a text area input -standard for question Number:$hello for slug=$tmp_slug");
										   }
									}
				                }  
                          }
                  elsif ($question =~ m/checkbox/i)
                          {
                                if($question =~ m/id=\"(.*?)\"/)
                                {
                                   my $checkbox_id= $1;
                                   if($sel->get_value($checkbox_id) =~ m/off/)
                                   {
                                    $sel->click_ok("$checkbox_id","This is a checkbox input for question Number:$hello for slug=$tmp_slug");
                                    }
                                }  
                          }
			  
				  elsif ($question =~ m/textarea/i)
						  {
							if($question =~ m/id=\"(.*?)\"/)
							{
							   my $textarea_id = $1;
							   if ($question =~ m/date/i)
							   {
							   	$sel->type_ok("$textarea_id", "12/12/2012","This is a text area input - type date for question Number:$hello for slug=$tmp_slug");
							   }
							   else
							   {
							   	$sel->type_ok("$textarea_id", "100000","This is a text area input -standard for question Number:$hello for slug=$tmp_slug");
							   }
							}  
						  }  
                  elsif ($question =~ m/<\/option>/i)
                          {
                                if($question =~ m/id=\"(.*?)\".*>(.*?)<\/option>/)
                                {
                                   $sel->select_ok("$1", "label=$2", "This is a dropdown selection for question Number:$hello for slug=$tmp_slug");
                                }   
                          }
                  elsif ($question =~ m/type=\"radio\"/i)
                          {
                                  if($question =~ m/id=\"(.*?)\"/)
                                {
                                   $sel->click_ok("$1","This is a radio selection for question Number:$hello for slug=$tmp_slug");
                                }
                          }
                   else
                        {
                         print"\nQuestion number:$hello is not a text, checkbox, radio or dropdown selection style question for slug:$tmp_slug.\nThe question is \n$question\n";
                         }	
        }
	$sel->click_ok("//div[\@id='questions']/div[2]/a[3]","User submits the questions page of the job application for $tmp_slug");
	if (!($sel->wait_for_text_present_ok("Ask people you know to give you a thumbs up","$tmp_slug - Check to see if the connections page - page 3 is displayed")))
	{
		$sel->click_ok("link=Continue","User submits the questions page of the job application for $tmp_slug");
	}
	#$sel->click_ok("//div[\@id='questions']/div[2]/a[3]","user clicks on continue on the questions page");
}
 
 
sub connections_page
{
	my ($tmp_slug) = @_;
	if(!($sel->wait_for_text_present_ok("Giving you a Thumbs Up takes your connections","$tmp_slug - Check to see if the connections page - page 3 is displayed")))
	{
		$sel->refresh();
	}
	my $skip_step;
	my $current_html1=$sel->get_html_source();
	if($current_html1 =~ m/.*step\">(.*?)<\/a><\/span>/ig)
		{
		   $skip_step=$1;
		   $sel->click_ok("link=$skip_step");
		}   
	$sel->click_ok("link=Skip");
	$sel->click_ok("//div[\@id='thumbs']/div[2]/a[3]","User clicks on continue on the connections page");
	
}

sub connections_page1
{
	my ($tmp_slug) = @_;
	$sel->wait_for_text_present_ok("Ask people you know to give you a thumbs up","$tmp_slug - Check to see if the connections page - page 3 is displayed");
	
	my $skip_step;
	my $current_html1=$sel->get_html_source();
	if($current_html1 =~ m/.*step\">(.*?)<\/a><\/span>/ig)
	{$skip_step=$1}
	else
	{$skip_step='Skip this step ->'}
	$sel->click_ok("link=$skip_step");
}

sub review_page
{
	my ($tmp_slug) = @_;
	$sel->wait_for_text_present_ok("Click submit to complete your application","Checking if the Review and Submit page opens up");
	#$sel->is_text_present_ok("Informational Questions","Text check of informational questions - as these jobs have questions");
	#$sel->is_text_present_ok("Bob Coast L","Text Check of a connection's name already being displayed");
	$sel->is_element_present_ok("link=Cancel","Check to see if the Cancel button is displayed on page 4");
	$sel->is_element_present_ok("link=Submit Application","Check to see if the Submit Application button is displayed on page 4");
}

sub get_slug_for_active_job_from_company_id
{
    my ($active_id)=@_;
    my $get_slug=0;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(30);    
    $ua->env_proxy; 
    my $response = $ua->get("http://$j_env/jobs/all.json?company=$active_id");
    my $actual_response=$response->decoded_content;
    my $perl_scalar = decode_json($actual_response);
    $get_slug= $perl_scalar->[0]->{slug};
    
    if ($get_slug)
    {
    	$tested_companies{ $tmp_company_name } = "Slug \/jobs\/$get_slug did not open in 30 seconds ";
    	check_jibejob($get_slug);
    }	
}

sub check_jibejob
{
	my ($sluggish)=@_;
	#$sluggish = 'sr-clinical-analyst-express-scripts-missouri-minnesota';
	$sel->open_ok("/jobs/$sluggish","$sluggish job page");
	$sel->wait_for_text_present_ok("tweet","30000","Job Desc page is displayed");
    my $current_html=$sel->get_html_source();
    if($current_html =~ m/Detailed Description/)
    {
		if (!($current_html =~ m/Applied/))
		{
			$sel->click_ok("link=Apply", "Click on $sluggish apply button on job desc page");
	    	$sel->wait_for_page_to_load_ok("30000");
	    	my $current_html1 = $sel->get_html_source();
		    if($current_html1 =~ m/You have exited JIBE/)
		    {
				ok (1,'The job with $sluggish is an iframe job');
				$sel->select_frame("index=0");
				my $current11_html=$sel->get_html_source();
				if($current11_html =~ m/body/i)
				{
					ok("1","Job Application Page is displayed");
					$tested_companies{ $tmp_company_name } = "Iframe job $sluggish - displays some text";
				}
				else 
				{
					ok("0","Job Application fails to load");
					$tested_companies{ $tmp_company_name } = "Iframe job $sluggish - is BLANK";
				}
				$sel->select_frame("relative=top");
		    }
		    else
		    {
		    	$tested_companies{ $tmp_company_name } = "Job slug $sluggish - apply button has bee clicked waiting for page to load";
		    	$sel->pause(3000);
		    	pages_two_and_three($sluggish);   
		    }
		}
		else 
		{
			$tested_companies{ $tmp_company_name } = "Job slug $sluggish - has already been applied to";
			ok("1", "User has already applied to the job");   
		}    
    }
    else
    {
    	$tested_companies{ $tmp_company_name } = "Job slug $sluggish is inactive";
    	ok("1", "This company is inactive now ");   
    }

}


sub check_redis
{
	my ($company_id)=@_;
	my $keys ="company_uses_new_flow_".$company_id;
	my $r = Redis->new( server => "$redis_server_name", debug => 0);
	$r->select( $dbindex );
	my $value = $r->get( $keys );
	if ($value)
	{return $value}
	else
	{return 'false'}
	
}

sub get_company_id
{
	my ($offset)=@_;
	my $get_id=0;
	my $ua = LWP::UserAgent->new;
	$ua->timeout(30);    
	$ua->env_proxy; 
	my $response = $ua->get("http://$c_env/companies/all.json?offset=$offset&limit=25");
	my $actual_response=$response->decoded_content;
	my $perl_scalar = decode_json($actual_response);
	$counter=@{$perl_scalar};
	$counter--;
	while ($counter>=0)
	{
	    $get_id= $perl_scalar->[$counter]->{id};
	    print "Testing company :  $perl_scalar->[$counter]->{company_name} \n";
	    #my $redis_state=check_redis($perl_scalar->[$counter]->{id});
	    #if ($redis_state =~ m/true/)
	    #{get_slug_for_active_job_from_company_id($get_id);}
	    $tmp_company_name= $perl_scalar->[$counter]->{company_name};
	    $tested_companies{ $tmp_company_name } = 'Started but no Jobs';
	    if (!($tmp_company_name =~ m/Microsoft/i || $tmp_company_name =~ m/ikon/i || $tmp_company_name =~ m/ricoh/i))
	    {
		    get_slug_for_active_job_from_company_id($get_id);
		}
		else
		{
			$tested_companies{ $tmp_company_name } = 'Microsoft or Ikon or Ricoh';
			ok(1,"This is either Microsoft or Ricoh or Ikon so no tests will be performed");
		}    
	    $counter--;
	}
}


