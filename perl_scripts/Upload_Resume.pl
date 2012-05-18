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

$sel->open_ok("$env",'Opening the test environment Home page');
$sel->set_speed("500");
$sel->click_ok("//img[\@alt='LinkedIn']", "User clicks on Linkedin Login button");
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Page Loads- waiting for text to be displayed');
$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com","User enters Linkedin Username");
$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124","User enters Linkedin Password");
$sel->click_ok("authorize","User authorizes the Linkedin Login credentials");
$sel->select_window("null");
$sel->window_maximize();
$sel->wait_for_text_present_ok("tweet","9000","The user sucessfully logs in");


$sel->click_ok("//div[\@id='user_info']/div/ul/li[1]/a/strong",'User clicks on Uploaded Resumes');
$sel->wait_for_text_present_ok("Cover Letters","9000","The resumes and cover letters page opens up");
$sel->click_ok("link=Add a Resume",'User clicks to add a new resume');
$sel->wait_for_text_present_ok("Upload Resume","9000","The upload resume page opens up");

if ($u1 =~ m/stg/)
{
	$sel->type_ok("resume_resume", "\/home\/boris\/Desktop\/resume.word.doc",'User enters the file path of the resume to be uploaded');
}
elsif ($u1 =~ m/prd/)
{
	$sel->type_ok("resume_resume", "C:\\Users\\amey\\Desktop\\Sample_Resume.pdf",'User enters the file path of the resume to be uploaded');
}

	
$sel->click_ok("//button[\@type='submit']",'User submits the resume path to begin resume upload');
$sel->wait_for_page_to_load("30000");

if ($u1 =~ m/stg/)
{
	$sel->is_text_present_ok("resume.word.doc",'Check to see if the uploaded resume displays');
}
elsif ($u1 =~ m/prd/)
{
	$sel->is_text_present_ok("Sample_Resume.pdf",'Check to see if the uploaded resume displays');
}


$sel->click_ok("nav_jobs",'User navigates to the Jobs landinng page');
$sel->wait_for_text_present_ok("tweet","9000","The user sucessfully logs in");
$sel->click_ok("//div[\@id='user_info']/div/ul/li[1]/a/strong",'User clicks on Uploaded Resumes');
$sel->wait_for_text_present_ok("Cover Letters","9000","The resumes and cover letters page opens up");
$sel->is_text_present_ok("Sample_Resume.pdf",'User verifies if the uploaded resume displays after navigating away from the resume page');
$sel->click_ok("nav_jobs",'User navigates to the jobs landing page');
$sel->wait_for_text_present_ok("tweet","9000","jobs page loads");
$sel->set_speed("5000");
$sel->click_ok("//div[\@id='user_info']/div/ul/li[1]/a/strong",'User clicks on Uploaded Resumes');
$sel->wait_for_page_to_load("30000");
$sel->click_ok("//div[\@id='search_results']/div[3]/div[2]/ul/li/a", 'User navigates to the saved resume page to delete the uploaded resume');
ok($sel->get_confirmation() =~ /^Are you sure you want to delete this resume[\s\S]$/ , 'User confirms deletion of the uploaded resume');
