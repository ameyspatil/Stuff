use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::Exception;
use env_config;

sub settings
{	
	$sel->click_ok("link=Settings", 'User clicks on Setting tab under My \'Account\'');
	$sel->set_speed("1000");
	$sel->wait_for_page_to_load("30000");
	$sel->click_ok("//a[contains(text(),'Email Preferences')]", 'User clicks on \'Email Preferences\' under \'Settings\'');
	$sel->wait_for_page_to_load("30000");
	$sel->is_text_present_ok("Check below to alter your account email settings");
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
	$sel->wait_for_page_to_load_ok("30000");
	$sel->click_ok("//a[contains(text(),'Email Preferences')]");
	$sel->wait_for_page_to_load_ok("30000");
	$sel->is_text_present_ok("Check below to alter your account email settings");
	$sel->value_is_ok("user_message_preference_email_friend_joined_notifications", "off",'Check to see if the \'Friend Joined Notifications\' is checked');
	$sel->value_is_ok("user_message_preference_email_job_postings", "off",'Check to see if the \'Email Job Postings\' is checked');
	$sel->value_is_ok("user_message_preference_email_job_app_updates", "off",'Check to see if the \'Job Application updates\' is checked');
	$sel->click_ok("user_message_preference_email_friend_joined_notifications",'User checks \'Friend Joined Notifications\'');
	$sel->click_ok("user_message_preference_email_job_postings",'User checks \'Email Job Postings\'');
	$sel->click_ok("user_message_preference_email_job_app_updates", 'User checks \'Job Application Updates\'');
	$sel->click_ok("update_email_options",'User updates the checking of all the settings');
	$sel->wait_for_page_to_load("30000");
}
1;