use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More "no_plan";
use Test::Exception;
require LWP::UserAgent;
use JSON::XS;

my $u1= $ARGV[0];
my $u2= $ARGV[1];
my $u_env= 0;
my $j_env=0;
my $c_env=0;
my $browser= '';
my $counter;
if ($u1 =~ m/dev/)
{
	$u_env="http://windoze2.jibe.com:3000/";
}
elsif ($u1 =~ m/stg/)
{
	$j_env="209.114.35.61:8080";#jobservice ip address
        $c_env="companyservice1.jibe.com:8080";##"209.114.47.232:8080";#companyservice ip address
        $u_env="http://jibeqa:jibejibe1124\@jibe.testbacon.com";
}
elsif ($u1 =~ m/prd/)
{
	$j_env="jobservice1.jibe.com:8080";
	$c_env="companyservice1.jibe.com:8080";##"209.114.47.232:8080";#companyservice ip address
    $u_env="http://www.jibe.com";
}

if ($u2 =~ m/safari/){$browser="*safari";}
elsif ($u2 =~ m/firefox/){$browser="*firefox";}
elsif ($u2 =~ m/iexplore/){$browser="*iexplore";}
elsif ($u2 =~ m/chrome/){$browser="*chrome";}

my $sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "$u_env" );
$sel->start();
$sel->open_ok("$u_env",'Loading Home Page');
$sel->set_speed("500");
$sel->click_ok("//img[\@alt='LinkedIn']", "User clicks on Linkedin Login button");
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Page Loads- waiting for text to be displayed');
$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com","User enters Linkedin Username");
$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124","User enters Linkedin Password");
$sel->click_ok("authorize","User authorizes the Linkedin Login credentials");
$sel->select_window("null");
$sel->wait_for_text_present_ok("Top Connected Categories", "9000","User sucessfully logs in using Linkedin");
$sel->window_maximize();

get_slug_for_active_job_from_company_id30();
$sel->stop();

$sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "$u_env" );

$sel->start();
$sel->open_ok("$u_env",'Loading Home Page');
$sel->set_speed("500");
$sel->click_ok("//img[\@alt='LinkedIn']", "User clicks on Linkedin Login button");
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Page Loads- waiting for text to be displayed');
$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com","User enters Linkedin Username");
$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124","User enters Linkedin Password");
$sel->click_ok("authorize","User authorizes the Linkedin Login credentials");
$sel->select_window("null");
$sel->wait_for_text_present_ok("tweet","9000","The user sucessfully logs in");
$sel->window_maximize();

get_slug_for_active_job_from_company_id30();
$sel->stop();





sub get_slug_for_active_job_from_company_id26
{
    my $company_id1=26;#ikon
    my $get_slug=0;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(30);    
    $ua->env_proxy; 
    my $response = $ua->get("http://$j_env/jobs/all.json?company=$company_id1");
    my $actual_response=$response->decoded_content;
    my $perl_scalar = decode_json($actual_response);
    $get_slug= $perl_scalar->[1]->{slug};
    if ($get_slug)
    {
    pages_two_and_three($get_slug);
    }	
}

sub get_slug_for_active_job_from_company_id30
{
    my $company_id1=30;#warner chilcott
    my $get_slug=0;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(30);    
    $ua->env_proxy; 
    my $response = $ua->get("http://$j_env/jobs/all.json?company=$company_id1");
    my $actual_response=$response->decoded_content;
    my $perl_scalar = decode_json($actual_response);
    $get_slug= $perl_scalar->[0]->{slug};
    if ($get_slug)
    {
    pages_two_and_three($get_slug);
    }   
}

sub get_slug_for_active_job_from_company_id25
{
    my $company_id2=25;#Gilt
    my $get_slug=0;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(30);    
    $ua->env_proxy; 
    my $response = $ua->get("http://$j_env/jobs/all.json?company=$company_id2");
    my $actual_response=$response->decoded_content;
    my $perl_scalar = decode_json($actual_response);
    $get_slug= $perl_scalar->[0]->{slug};
    if ($get_slug)
    {
    pages_two_and_three($get_slug);
    }
}

sub pages_two_and_three
{
    my ($slug) = @_;
    $sel->open_ok("/job_application/$slug","$slug job page");
    $sel->wait_for_page_to_load("30000");
    
    my $current_html=$sel->get_html_source();
   
    if($current_html =~ m/ZIP/)
    {
	profile_page($slug);
	get_questions($slug);
	connections_page($slug);
    }	
    
    elsif ($current_html =~ m/basic employer questions/ || $current_html =~ m/There are no questions for this job/)
    {   
	get_questions($slug);
	connections_page($slug);
    }
    
    elsif ($current_html =~ m/Giving you a Thumbs Up takes your connections/)
    {
	connections_page($slug);
    }
    else
    {
	review_page($slug);
	$sel->click_ok("link=Edit","User clicks on profile edit button");
	profile_page($slug);
	get_questions($slug);
	$sel->click_ok("link=Continue","User submits the connections page of the job application for $slug");
	connections_page($slug);
    }
    review_page($slug);
}

sub profile_page
{
    my ($tmp_slug) = @_;
    $sel->wait_for_text_present_ok("ZIP Code","Checking to see if the profile edit page is displayed");
    $sel->type_ok("application_data_email", "jibeqa456789\@gmail.com", "$tmp_slug Job Page - User enters job appication contact email id");
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
    if (!($sel->wait_for_text_present_ok("Answer some basic employer questions:","Checking if the questions page opens up")))
    {
	$sel->refresh();
    }
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
                                        $sel->type_ok("$number", "100000","This is a textbox input for question Number:$hello for slug=$tmp_slug");
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
                				   $sel->type_ok("$1", "100000","This is a text area input for question Number:$hello for slug=$tmp_slug");
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
	$sel->click_ok("//div[\@id='questions']/div[2]/a[3]","user clicks on continue on the questions page");
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


sub review_page
{
	my ($tmp_slug) = @_;
	if(!($sel->wait_for_text_present_ok("Click submit to complete your application","Checking if the Review and Submit page opens up")))
	{
		$sel->refresh();
	}
	$sel->is_text_present_ok("Informational Questions","Text check of informational questions - as these jobs have questions");
	$sel->is_element_present_ok("link=Cancel","Check to see if the Cancel button is displayed on page 4");
	$sel->is_element_present_ok("link=Submit Application","Check to see if the Submit Application button is displayed on page 4");
}

