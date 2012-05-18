use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::Exception;
use env_config;



sub linkedin_login
{
	if ($u1 =~ m/dev/)
	{
		$sel->open_ok("500");
		$sel->set_speed("500");
		$sel->click_ok("link=Visit the homepage");
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
		#$sel->click_ok("link=Signout");
		#$sel->wait_for_page_to_load("90000");
		$sel->open_ok("$env");
		$sel->set_speed("500");
		$sel->wait_for_page_to_load("90000");
		$sel->click_ok("//img[\@alt='LinkedIn']",																		'User cicks on linkedin login button');
		$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
		if($sel->wait_for_page_to_load_ok("20000"))
		{
			$sel->click_ok("link=Continue", 'User clicks on Linkedin Continue,');
			$sel->select_window("null");
		}
		else
		{
			$sel->close();
			$sel->select_window("null");
			$sel->open_ok("$env");
			$sel->set_speed("500");
			$sel->click_ok("//img[\@alt='Facebook']",'User clicks on Facebook Login');
			$sel->wait_for_pop_up_ok("", "30000",'Facebook Login Popup Loading');
			$sel->select_pop_up("null");	
			$sel->type_ok("email", "jibeqa\@gmail.com",'User enters Facebook credentials - Username');
			$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
			$sel->key_press("pass", "\\13",'User returns Facebook Login credentials');
			$sel->select_window("null");
		}
		$sel->wait_for_page_to_load("30000");
		$sel->window_maximize();
		$sel->type_ok("q", "quality assurance",'Logged in LinkedIn user search');
		$sel->click("//button[\@type='submit']");
	}
	else
	{
		$sel->open_ok("$env");
		$sel->set_speed("500");
		$sel->wait_for_page_to_load("90000");
		$sel->click_ok("//img[\@alt='LinkedIn']",																		'User cicks on linkedin login button');
		$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
		if($sel->wait_for_page_to_load_ok("20000"))
		{
			$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
			$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
			$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
		}
		$sel->select_window("null");
		$sel->wait_for_page_to_load("30000");
		$sel->window_maximize();
	}
}

1;
