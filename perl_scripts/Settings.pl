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
$sel->click_ok("link=Settings", 'User clicks on Setting tab under My \'Account\'');
$sel->wait_for_text_present_ok("Settings", "9000",'Settings page is dispayed');


$sel->click_ok("//a[contains(text(),'Email Preferences')]", 'User clicks on \'Email Preferences\' under \'Settings\'');
$sel->wait_for_text_present_ok("Check below to alter your account email settings", "9000",'Email Pref page is displayed');

if(!($sel->value_is_ok("user_message_preference_email_friend_joined_notifications", "on",'Check to see if the \'Friend Joined Notifications\' is checked')))
{
	$sel->click_ok("user_message_preference_email_friend_joined_notifications",'User checks \'Friend Joined Notifications\' to get it back to original state');
} 

if(!($sel->value_is_ok("user_message_preference_email_job_postings", "on",'Check to see if the \'Email Job Postings\' is checked')))
{
	$sel->click_ok("user_message_preference_email_job_postings",'User checks \'Email Job Postings\' to get it back to original state');
}

if(!($sel->value_is_ok("user_message_preference_email_job_app_updates", "on",'Check to see if the \'Job Application updates\' is checked')))
{
	$sel->click_ok("user_message_preference_email_job_app_updates",'User checks \'Job Application updates\' to get it back to original state');
}


$sel->click_ok("update_email_options", 'User updates the unchecking of all the settings');
$sel->wait_for_page_to_load("30000");


$sel->value_is_ok("user_message_preference_email_friend_joined_notifications", "on",'Check to see if the \'Friend Joined Notifications\' is checked');
$sel->value_is_ok("user_message_preference_email_job_postings", "on",'Check to see if the \'Email Job Postings\' is checked');
$sel->value_is_ok("user_message_preference_email_job_app_updates", "on",'Check to see if the \'Job Application updates\' is checked');
$sel->click_ok("user_message_preference_email_friend_joined_notifications",'User unchecks \'Friend Joined Notifications\'');
$sel->click_ok("user_message_preference_email_job_postings",'User unchecks \'Email Job Postings\'');
$sel->click_ok("user_message_preference_email_job_app_updates",'User unchecks \'Job Application updates\'');
$sel->click_ok("update_email_options", 'User updates the unchecking of all the settings');
$sel->wait_for_page_to_load("30000");
#$sel->click_ok("//img[\@alt='Linkedin']", 'User signs in after logging out');
#$sel->wait_for_page_to_load("30000");
#$sel->click_ok("link=Continue", 'User clicks on Linkedin Continue,');
#$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Settings");
$sel->wait_for_text_present_ok("Settings", "9000",'Settings page is dispayed');


$sel->click_ok("//a[contains(text(),'Email Preferences')]");
$sel->wait_for_text_present_ok("Check below to alter your account email settings", "9000",'Email Pref page is displayed');


$sel->value_is_ok("user_message_preference_email_friend_joined_notifications", "off",'Check to see if the \'Friend Joined Notifications\' is checked');
$sel->value_is_ok("user_message_preference_email_job_postings", "off",'Check to see if the \'Email Job Postings\' is checked');
$sel->value_is_ok("user_message_preference_email_job_app_updates", "off",'Check to see if the \'Job Application updates\' is checked');
$sel->click_ok("user_message_preference_email_friend_joined_notifications",'User checks \'Friend Joined Notifications\'');
$sel->click_ok("user_message_preference_email_job_postings",'User checks \'Email Job Postings\'');
$sel->click_ok("user_message_preference_email_job_app_updates", 'User checks \'Job Application Updates\'');
$sel->click_ok("update_email_options",'User updates the checking of all the settings');
$sel->wait_for_page_to_load("30000");
