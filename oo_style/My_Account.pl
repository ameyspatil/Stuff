use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::Exception;
use env_config;


sub my_account
{	
	$sel->click_ok("link=My Profile",'User click on My Profile');
	$sel->set_speed("500");
	$sel->wait_for_page_to_load_ok("30000");
	
	$sel->click_ok("link=My Profile",'User click on My Profile');
	$sel->wait_for_page_to_load("30000");
	$sel->is_text_present_ok("First Name","Verifying My account page is displayed");
	$sel->is_text_present_ok("Last Name","Verifying My account page is displayed");
	$sel->click_ok("link=My Stats",'User clicks on My Stats');
	$sel->wait_for_page_to_load("30000");
	$sel->is_text_present_ok("Top Employers",'Text check on My Stats Page');
	$sel->is_text_present_ok("Unemployment",'Text check on My Stats Page');
	$sel->click_ok("link=Browse my network",'User clicks on My Network');
	$sel->wait_for_page_to_load("30000");
	$sel->is_text_present_ok("Popular Job Titles",'Text check on My Network page');
	$sel->click_ok("link=Settings",'User clicks on Settings Page');
	$sel->wait_for_page_to_load("30000");
}
1;