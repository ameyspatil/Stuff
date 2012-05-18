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
$sel->open_ok("$env",'Loading Home Page');
$sel->set_speed("1000");
$sel->click_ok("//img[\@alt='LinkedIn']", "User clicks on Linkedin Login button");
$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Page Loads- waiting for text to be displayed');
$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com","User enters Linkedin Username");
$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124","User enters Linkedin Password");
$sel->click_ok("authorize","User authorizes the Linkedin Login credentials");
$sel->select_window("null");
$sel->wait_for_text_present_ok("tweet","9000","The user sucessfully logs in");
#my $jobid = "0";
#my $html_source;
#$html_source = $sel->get_html_source();
#$html_source =~ m/job_id="(.*)"/;
#$jobid = $1;
$sel->click_ok("link=Save");
#$sel->click_ok("//div[\@id='job_result_$jobid']/div/div/ul/li[2]/span/a",'User clicks on a job to be saved');
$sel->is_text_present_ok("Saved!",'Checks to see if the text Save changes to  Saved!');
#$sel->click_ok("//div[\@id='user_info']/div[2]/ul/li[2]","click on saved jobs");
$sel->click_ok("link=1 Saved Jobs","click on saved jobs");

$sel->wait_for_page_to_load("30000");
#$sel->is_text_present_ok("Saved!",'User verifies if the saved job displays on the Saved-Jobs page');
#$sel->click_ok("link=Saved!", 'User Removes the saved job');
$sel->is_text_present_ok("Unsave",'User verifies if the saved job displays on the Saved-Jobs page');
$sel->click_ok("link=Unsave");
$sel->click("id=nav_jobs");
$sel->wait_for_text_present_ok("tweet","9000","The user navigates to job listing");
