use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::Exception;
use env_config;

sub fb_login
{
	$sel->open_ok("$env");
	$sel->set_speed("500");
	$sel->click_ok("//img[\@alt='Facebook']",'User clicks on Facebook Login');
	$sel->wait_for_pop_up_ok("", "30000",'Facebook Login Popup Loading');
	$sel->select_pop_up("null");	
	$sel->type_ok("email", "facebookdontcare\@gmail.com",'User enters Facebook credentials - Username');
	$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
	$sel->key_press("pass", "\\13",'User returns Facebook Login credentials');
	$sel->set_speed("1000");
	$sel->select_window("null");
	$sel->wait_for_page_to_load_ok("30000");
	$sel->click_ok("logout_link", 'User clicks on logout, after a FB login');
	$sel->wait_for_page_to_load_ok("30000");
	$sel->is_text_present_ok("comes to getting a job",'User successfully logs out');
}
1;
	
	
	
	

