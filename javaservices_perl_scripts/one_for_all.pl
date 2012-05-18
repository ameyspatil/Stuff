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
        $u_env="jibeqa:jibejibe1124\@jibe.testbacon.com";
}
elsif ($u1 =~ m/prd/)
{
	$j_env="jobservice1.jibe.com:8080";
	$c_env="companyservice1.jibe.com:8080";##"209.114.47.232:8080";#companyservice ip address
        $u_env="www.jibe.com";
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



$sel->start();
$sel->open_ok("http://$u_env",'Open the home page');
$sel->set_speed("500");
$sel->wait_for_page_to_load("90000");
$sel->click_ok("//img[\@alt='Linkedin']",																		'User cicks on linkedin login button');
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
if($sel->wait_for_page_to_load_ok("20000"))
	{
		$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
		$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
		$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
	}
$sel->select_window("null");
$sel->wait_for_page_to_load("90000");
$sel->window_maximize();

get_company_id_0();
$sel->stop();

$sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "http://$u_env" );



$sel->start();
$sel->open_ok("http://$u_env",'Open the home page');
$sel->set_speed("500");
$sel->wait_for_page_to_load("90000");
$sel->click_ok("//img[\@alt='Linkedin']",																		'User cicks on linkedin login button');
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
if($sel->wait_for_page_to_load_ok("20000"))
	{
		$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
		$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
		$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
	}
$sel->select_window("null");
$sel->wait_for_page_to_load("90000");
$sel->window_maximize();

get_company_id_25();
$sel->stop();


$sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "http://$u_env" );



$sel->start();
$sel->open_ok("http://$u_env",'Open the home page');
$sel->set_speed("500");
$sel->wait_for_page_to_load("90000");
$sel->click_ok("//img[\@alt='Linkedin']",																		'User cicks on linkedin login button');
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
if($sel->wait_for_page_to_load_ok("20000"))
	{
		$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
		$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
		$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
	}
$sel->select_window("null");
$sel->wait_for_page_to_load("90000");
$sel->window_maximize();

get_company_id_50();
$sel->stop();




$sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "http://$u_env" );



$sel->start();
$sel->open_ok("http://$u_env",'Open the home page');
$sel->set_speed("500");
$sel->wait_for_page_to_load("90000");
$sel->click_ok("//img[\@alt='Linkedin']",																		'User cicks on linkedin login button');
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
if($sel->wait_for_page_to_load_ok("20000"))
	{
		$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
		$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
		$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
	}
$sel->select_window("null");
$sel->wait_for_page_to_load("90000");
$sel->window_maximize();

get_company_id_75();
$sel->stop();




$sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "http://$u_env" );



$sel->start();
$sel->open_ok("http://$u_env",'Open the home page');
$sel->set_speed("500");
$sel->wait_for_page_to_load("90000");
$sel->click_ok("//img[\@alt='Linkedin']",																		'User cicks on linkedin login button');
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
if($sel->wait_for_page_to_load_ok("20000"))
	{
		$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
		$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
		$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
	}
$sel->select_window("null");
$sel->wait_for_page_to_load("90000");
$sel->window_maximize();

get_company_id_100();
$sel->stop();





$sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "http://$u_env" );



$sel->start();
$sel->open_ok("http://$u_env",'Open the home page');
$sel->set_speed("500");
$sel->wait_for_page_to_load("90000");
$sel->click_ok("//img[\@alt='Linkedin']",																		'User cicks on linkedin login button');
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
if($sel->wait_for_page_to_load_ok("20000"))
	{
		$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
		$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
		$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
	}
$sel->select_window("null");
$sel->wait_for_page_to_load("90000");
$sel->window_maximize();

get_company_id_125();
$sel->stop();





$sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "http://$u_env" );



$sel->start();
$sel->open_ok("http://$u_env",'Open the home page');
$sel->set_speed("500");
$sel->wait_for_page_to_load("90000");
$sel->click_ok("//img[\@alt='Linkedin']",																		'User cicks on linkedin login button');
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
if($sel->wait_for_page_to_load_ok("20000"))
	{
		$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
		$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
		$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
	}
$sel->select_window("null");
$sel->wait_for_page_to_load("90000");
$sel->window_maximize();

get_company_id_150();
$sel->stop();



sub pages_two_and_three
{
    my ($slug) = @_;
    #$slug = 'executive-team-leader-assets-protection-mpls-slash-st-paul-north-slash-west-slash-central-mn-wes-job-target-mn--1';
    $sel->open_ok("http://$u_env/jobs/$slug/job_applications/new","$slug job page");
    $sel->wait_for_page_to_load("30000");
    $sel->type_ok("job_application_email", "jibeqa\@gmail.com", "$slug Job Page - User enters job appication contact email id");
    $sel->type_ok("job_application_street_address", "Testing test","$slug Job Page - User enters street address");
    $sel->type_ok("job_application_phone_number", "223-456-7890","$slug Job Page - User enters the phone number");
    $sel->select_ok("job_application_resume_id", "label=140799_Resume_.pdf","$slug Job Page - User selects a pre-uploaded resume");
    $sel->select_ok("job_application_cover_letter_id", "label=cover_letter.pdf","$slug Job Page - User enters information in Job Application - Selects Cover Letter");
    $sel->select_ok("job_application_province_id", "label=New York", "$slug Job Page - User selects the state");
    $sel->click("//option[\@value='35']");
    $sel->type_ok("job_application_zip_code", "10013","$slug Job Page - User enters the zipcode");
    $sel->click_ok("link=Continue", "$slug Job Page - User clicks on continue to move to the second page of the job application");
    $sel->wait_for_page_to_load("30000");
    $sel->click_ok("link=Continue","$slug Job Page - User clicks on continue on the connections page");
    $sel->wait_for_page_to_load_ok("30000");
       
    get_questions($slug);
    
    $sel->click_ok("link=Continue","User submits third page of the job application for $slug");
    $sel->wait_for_page_to_load_ok("30000");
    $sel->is_text_present_ok("Review Your Application","Verifying \'Review Your Application\' text exists on the final pagefor $slug.");
    $sel->click_ok("cancel", 'User cancels submission of Job Application on the final page');
    $sel->wait_for_page_to_load_ok("30000");
    $sel->click_ok("link=JIBE");
}
    
sub get_questions
{
    my ($tmp_slug) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(3);
    $ua->env_proxy; 
    my $response = $ua->get("http://$j_env/jobs/slug/$tmp_slug/user/16/questions.json");
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
					{$sel->type_ok("$number", "Aalborg Universitet","This is a textbox input for question Number:$hello for slug=$tmp_slug");}
					else
					{$sel->type_ok("$number", "100000","This is a textbox input for question Number:$hello for slug=$tmp_slug");}
                                }  
                          }
                  elsif ($question =~ m/checkbox/i)
                          {
                                if($question =~ m/id=\"(.*?)\"/)
                                {
                                   $sel->click_ok("$1","This is a checkbox input for question Number:$hello for slug=$tmp_slug");
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
}
            



sub get_slug_for_active_job_from_company_id
{
    my ($active_id)=@_;
    my $get_slug=0;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(3);    
    $ua->env_proxy; 
    my $response = $ua->get("http://$j_env/jobs/all.json?company=$active_id");
    my $actual_response=$response->decoded_content;
    my $perl_scalar = decode_json($actual_response);
    $get_slug= $perl_scalar->[0]->{slug};
    if ($get_slug)
    {
    pages_two_and_three($get_slug);
    }	
}


sub get_company_id_0
{
	my $get_id=0;
	my $offset=0;
	my $ua = LWP::UserAgent->new;
	$ua->timeout(3);    
	$ua->env_proxy; 
	
	my $response = $ua->get("http://$c_env/companies/all.json?offset=0&limit=25");
	my $actual_response=$response->decoded_content;
	my $perl_scalar = decode_json($actual_response);
	$counter=@{$perl_scalar};
	$counter--;
	while ($counter>=0)
	{
	    $get_id= $perl_scalar->[$counter]->{id};
	    get_slug_for_active_job_from_company_id($get_id);
	    $counter--;
	}
}


sub get_company_id_25
{
	my $get_id=0;
	my $offset=0;
	my $ua = LWP::UserAgent->new;
	$ua->timeout(3);    
	$ua->env_proxy; 
	
	my $response = $ua->get("http://$c_env/companies/all.json?offset=25&limit=25");
	my $actual_response=$response->decoded_content;
	my $perl_scalar = decode_json($actual_response);
	$counter=@{$perl_scalar};
	$counter--;
	while ($counter>=0)
	{
	    $get_id= $perl_scalar->[$counter]->{id};
	    get_slug_for_active_job_from_company_id($get_id);
	    $counter--;
	}
}



sub get_company_id_50
{
	my $get_id=0;
	my $offset=0;
	my $ua = LWP::UserAgent->new;
	$ua->timeout(3);    
	$ua->env_proxy; 
	
	my $response = $ua->get("http://$c_env/companies/all.json?offset=50&limit=25");
	my $actual_response=$response->decoded_content;
	my $perl_scalar = decode_json($actual_response);
	$counter=@{$perl_scalar};
	$counter--;
	while ($counter>=0)
	{
	    $get_id= $perl_scalar->[$counter]->{id};
	    get_slug_for_active_job_from_company_id($get_id);
	    $counter--;
	}
}


sub get_company_id_75
{
	my $get_id=0;
	my $offset=0;
	my $ua = LWP::UserAgent->new;
	$ua->timeout(3);    
	$ua->env_proxy; 
	
	my $response = $ua->get("http://$c_env/companies/all.json?offset=75&limit=25");
	my $actual_response=$response->decoded_content;
	my $perl_scalar = decode_json($actual_response);
	$counter=@{$perl_scalar};
	$counter--;
	while ($counter>=0)
	{
	    $get_id= $perl_scalar->[$counter]->{id};
	    get_slug_for_active_job_from_company_id($get_id);
	    $counter--;
	}
}



sub get_company_id_100
{
	my $get_id=0;
	my $offset=0;
	my $ua = LWP::UserAgent->new;
	$ua->timeout(3);    
	$ua->env_proxy; 
	
	my $response = $ua->get("http://$c_env/companies/all.json?offset=100&limit=25");
	my $actual_response=$response->decoded_content;
	my $perl_scalar = decode_json($actual_response);
	$counter=@{$perl_scalar};
	$counter--;
	while ($counter>=0)
	{
	    $get_id= $perl_scalar->[$counter]->{id};
	    get_slug_for_active_job_from_company_id($get_id);
	    $counter--;
	}	
}

sub get_company_id_125
{
	my $get_id=0;
	my $offset=0;
	my $ua = LWP::UserAgent->new;
	$ua->timeout(3);    
	$ua->env_proxy; 
	
	my $response = $ua->get("http://$c_env/companies/all.json?offset=125&limit=25");
	my $actual_response=$response->decoded_content;
	my $perl_scalar = decode_json($actual_response);
	$counter=@{$perl_scalar};
	$counter--;
	while ($counter>=0)
	{
	    $get_id= $perl_scalar->[$counter]->{id};
	    get_slug_for_active_job_from_company_id($get_id);
	    $counter--;
	}	
}

sub get_company_id_150
{
	my $get_id=0;
	my $offset=0;
	my $ua = LWP::UserAgent->new;
	$ua->timeout(3);    
	$ua->env_proxy; 
	
	my $response = $ua->get("http://$c_env/companies/all.json?offset=150&limit=25");
	my $actual_response=$response->decoded_content;
	my $perl_scalar = decode_json($actual_response);
	$counter=@{$perl_scalar};
	$counter--;
	while ($counter>=0)
	{
	    $get_id= $perl_scalar->[$counter]->{id};
	    get_slug_for_active_job_from_company_id($get_id);
	    $counter--;
	}	
}

