use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More "no_plan";
use Test::Exception;

my $u1= $ARGV[0];
my $u2= $ARGV[1];
my $env= 0;
my $browser= '';

if ($u1 =~ m/dev/)
{
	$env="http://localhost:3000/";
}
elsif ($u1 =~ m/stg/)
{
	$env="http://jibeqa:jibejibe1124\@jibe.testbacon.com/";
}
elsif ($u1 =~ m/prd/)
{
	$env="http://www.jibe.com/";
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
                                    browser_url => "$env" );





$sel->start();
$sel->open_ok("$env",																												'Loading Home Page');
$sel->set_speed("500");
$sel->click_ok("//img[\@alt='Linkedin']", 'User clicks on Linkedin to sign in');
$sel->wait_for_page_to_load("30000");
$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com", 'Linkedin User Login  - Username');
$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124", 'Linkedin User Login  -  Password');
$sel->click_ok("authorize", 'Linkedin User Login - Authorize');
$sel->wait_for_page_to_load("30000");
$sel->open_ok("$env/jobs/manager-communications-mtv-networks-santa-monica-ca--1/job_applications/new", 'MTV job application page opens up');
$sel->wait_for_page_to_load("30000");
$sel->type_ok("job_application_email", "jibeqa\@gmail.com", 'MTV Job - User enters information in Job Application');
$sel->type_ok("job_application_street_address", "Testing test",'MTV Job - User enters information in Job Application');
$sel->type_ok("job_application_phone_number", "123-456-7890",'MTV Job - User enters information in Job Application');
$sel->select_ok("job_application_resume_id", "label=Resume.txt",'MTV Job - User enters information in Job Application - Selects a pre-uploaded resume');
$sel->select_ok("job_application_province_id", "label=New York", 'MTV Job - User enters information in Job Application');
$sel->click("//option[\@value='35']");
$sel->type_ok("job_application_zip_code", "10013",'User enters information in Job Application');
$sel->click_ok("link=Continue", 'User moves to second page of job application');
$sel->wait_for_page_to_load("30000");
$sel->click("link=Continue");
$sel->wait_for_page_to_load("30000");
$sel->select_ok("CUSTOM_831", "label=No", 'MTV Job - User enters information in Job Application');
$sel->click_ok("//option[\@value='1256']",'MTV Job - User enters information in Job Application');
$sel->select_ok("legalStatus", "label=I am authorized to work in this country for any employer",'User enters information in Job Application');
$sel->click_ok("//option[\@value='441']",'MTV Job - User enters information in Job Application');
$sel->type_ok("CUSTOM_293", "100,000",'MTV Job - User enters information in Job Application');
$sel->type_ok("CUSTOM_655", "Tester",'MTV Job - User enters information in Job Application');
$sel->type_ok("CUSTOM_645", "Tester",'MTV Job - User enters information in Job Application');
$sel->click_ok("link=Continue",'User submits third page of MTV job application');
$sel->wait_for_page_to_load("30000");
$sel->click_ok("cancel", 'User cancels submission of Job Application on the final page');
$sel->wait_for_page_to_load("30000");
