use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More "no_plan";
use Test::Exception;

my $u1= $ARGV[0];
my $u2= $ARGV[1];
my $env= 0;
my $location="/home/boris/Desktop/LoginChecks/LinkedinLogin/".localtime(time);
my $browser= '';

if ($u1 =~ m/dev/)
{
	$env="http://windoze2.jibe.com:9000/";
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
	$browser="*chrome5";
}



my $sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "$env" );


my $linkedin_fail_count=0;
my $home_fail_count=0;
my $logged_fail_count=0;
$sel->start;
$sel->open_ok("$env");
$sel->window_maximize();
$sel->set_speed("500");
if ($sel->wait_for_text_present_ok("Harness the power of your","Home page opens up"))
{
	linkedin();
}
else
{
	$home_fail_count++;
	$sel->capture_screenshot($location.'homepagefailed_'.$home_fail_count.'_times'.'.png');
	$sel->open_ok("$env");
	if ($sel->wait_for_text_present_ok("Harness the power of your","Home page opens up"))
		{
			linkedin();	
		}
	else
	{
		$home_fail_count++;
		$sel->capture_screenshot($location.'homepagefailed_'.$home_fail_count.'_times'.'.png');
		$sel->open_ok("$env");
		if ($sel->wait_for_text_present_ok("Harness the power of your","Home page opens up"))
			{
				linkedin();	
			}
	}
}

sub linkedin
{
	$sel->click_ok("link=LI",'User cicks on linkedin login button');
	#$sel->select_window("name=ConnectWithLinkedIn");
	if ($sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "30000",'Linkedin Login Page Loads- waiting for text to be displayed'))
	{
		$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
		$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
		$sel->click	("authorize",'Authorization of Linkedin User credentials');
		#$sel->select_window("null");
		if($sel->wait_for_text_present_ok("Tom Gray", "30000","User sucessfully logs in using Linkedin"))
		{
			sleep(1);
			$sel->click("css=span");
			$sel->click_ok("link=Logout", 'User clicks on logout, after a Linkedin login');
			$sel->wait_for_text_present_ok("Harness the power of your","7000",'User successfully logs out');
		}
		else
		{
			$logged_fail_count++;
			$sel->capture_screenshot($location.'loginjobspagefailed_'.$logged_fail_count.'_times'.'.png');
			goto end;
		}
	}
	else
	{
		$linkedin_fail_count++;
		$sel->capture_screenshot($location.'linkedinloginpagefailed_'.$linkedin_fail_count.'_times'.'.png');
		#$sel->select_pop_up("null");
		#$sel->close();
		#$sel->select_window("null");
		$sel->open_ok("$env");
		$sel->set_speed("500");
		$sel->wait_for_page_to_load_ok("30000");
		$sel->click_ok("link=LI",																		'User cicks on linkedin login button');
		#$sel->select_window("name=ConnectWithLinkedIn");
		if ($sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "30000",'Linkedin Login Page Loads- waiting for text to be displayed'))
		{
			$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
			$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
			$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
			#$sel->select_window("null");
			if($sel->wait_for_text_present_ok("Tom Gray", "30000","User sucessfully logs in using Linkedin"))
			{
				sleep(1);
				$sel->click("css=span");
				$sel->click_ok("link=Logout", 'User clicks on logout, after a Linkedin login');
				$sel->wait_for_text_present_ok("Harness the power of your","30000",'User successfully logs out');
			}
			else
			{
				$logged_fail_count++;
				$sel->capture_screenshot($location.'loginjobspagefailed_'.$logged_fail_count.'_times'.'.png');
			}
		}
		else
		{
			$linkedin_fail_count++;
			$sel->capture_screenshot($location.'linkedinloginpagefailed_'.$linkedin_fail_count.'_times'.'.png');
			#$sel->select_pop_up("null");
			#$sel->close();
			#$sel->select_window("null");
			$sel->open_ok("$env");
			$sel->set_speed("500");
			$sel->wait_for_page_to_load_ok("30000");
			$sel->click_ok("link=LI",'User cicks on linkedin login button');
			#$sel->select_window("name=ConnectWithLinkedIn");
			if ($sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "30000",'Linkedin Login Page Loads- waiting for text to be displayed'))
			{
				$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
				$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
				$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
				#$sel->select_window("null");
				if($sel->wait_for_text_present_ok("Tom Gray", "30000","User sucessfully logs in using Linkedin"))
				{
					sleep(1);
					$sel->click("css=span");
					$sel->click_ok("link=Logout", 'User clicks on logout, after a Linkedin login');
					$sel->wait_for_text_present_ok("Harness the power of your","30000",'User successfully logs out');
				}
				else
				{
					$logged_fail_count++;
					$sel->capture_screenshot($location.'loginjobspagefailed_'.$logged_fail_count.'_times'.'.png');
				}
			}	
			else
			{
				$linkedin_fail_count++;
				$sel->capture_screenshot($location.'linkedinloginpagefailed_'.$linkedin_fail_count.'_times'.'.png');
			}	
		}
	
	}

}
end:
if ($linkedin_fail_count != 0){ok(0,"The Linkedin Login Authorization page has failed to load $linkedin_fail_count times\n");}
if ($home_fail_count != 0){ok(0,"The Home page \(www.jibe.com\) has failed to load $home_fail_count times\n");}
$sel->stop;
if ($logged_fail_count != 0)
{
	ok(0,"The jobs page after a Linked Login has failed to load $logged_fail_count times\n");
	$sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "$env" );


my $linkedin_fail_count=0;
my $home_fail_count=0;
my $logged_fail_count=0;
$sel->start;
$sel->open_ok("$env");
$sel->window_maximize();
$sel->set_speed("500");
if ($sel->wait_for_page_to_load_ok("30000"))
{
	linkedin1();
}
else
{
	$home_fail_count++;
	$sel->capture_screenshot($location.'homepagefailed_'.$home_fail_count.'_times'.'.png');
	$sel->open_ok("$env");
	if ($sel->wait_for_page_to_load_ok("30000"))
		{
			linkedin1();	
		}
	else
	{
		$home_fail_count++;
		$sel->capture_screenshot($location.'homepagefailed_'.$home_fail_count.'_times'.'.png');
		$sel->open_ok("$env");
		if ($sel->wait_for_page_to_load_ok("30000"))
			{
				linkedin1();	
			}
	}
}

sub linkedin1
{
	$sel->click_ok("link=LI",'User cicks on linkedin login button');
	#$sel->select_window("name=ConnectWithLinkedIn");
	if ($sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "30000",'Linkedin Login Page Loads- waiting for text to be displayed'))
	{
		$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
		$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
		$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
		#$sel->select_window("null");
		if($sel->wait_for_text_present_ok("Tom Gray", "30000","User sucessfully logs in using Linkedin"))
		{
			sleep(1);
			$sel->click("css=span");
			$sel->click_ok("link=Logout", 'User clicks on logout, after a Linkedin login');
			$sel->wait_for_text_present_ok("Harness the power of your","30000",'User successfully logs out');
		}
		else
		{
			$logged_fail_count++;
			$sel->capture_screenshot($location.'loginjobspagefailed_'.$logged_fail_count.'_times'.'.png');
			goto end1;
		}
	}
	else
	{
		$linkedin_fail_count++;
		$sel->capture_screenshot($location.'linkedinloginpagefailed_'.$linkedin_fail_count.'_times'.'.png');
		#$sel->select_pop_up("null");
		#$sel->close();
		#$sel->select_window("null");
		$sel->open_ok("$env");
		$sel->set_speed("500");
		$sel->wait_for_page_to_load_ok("30000");
		$sel->click_ok("link=LI",																		'User cicks on linkedin login button');
		#$sel->select_window("name=ConnectWithLinkedIn");
		if ($sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "30000",'Linkedin Login Page Loads- waiting for text to be displayed'))
		{
			$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
			$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
			$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
			#$sel->select_window("null");
			if($sel->wait_for_text_present_ok("Tom Gray", "30000","User sucessfully logs in using Linkedin"))
			{
				sleep(1);
				$sel->click("css=span");
				$sel->click_ok("link=Logout", 'User clicks on logout, after a Linkedin login');
				$sel->wait_for_text_present_ok("Harness the power of your","30000",'User successfully logs out');
			}
			else
			{
				$logged_fail_count++;
				$sel->capture_screenshot($location.'loginjobspagefailed_'.$logged_fail_count.'_times'.'.png');
			}
		}
		else
		{
			$linkedin_fail_count++;
			$sel->capture_screenshot($location.'linkedinloginpagefailed_'.$linkedin_fail_count.'_times'.'.png');
			#$sel->select_pop_up("null");
			#$sel->close();
			#$sel->select_window("null");
			$sel->open_ok("$env");
			$sel->set_speed("500");
			$sel->wait_for_page_to_load_ok("30000");
			$sel->click_ok("link=LI",'User cicks on linkedin login button');
			#$sel->select_window("name=ConnectWithLinkedIn");
			if ($sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "30000",'Linkedin Login Page Loads- waiting for text to be displayed'))
			{
				$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com",'Use enters Linkedin Login Credentials - UserName');
				$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124",'Use enters Linkedin Login Credentials - Password');
				$sel->click_ok("authorize",'Authorization of Linkedin User credentials');
				#$sel->select_window("null");
				if($sel->wait_for_text_present_ok("Tom Gray", "30000","User sucessfully logs in using Linkedin"))
				{
					sleep(1);
					$sel->click("css=span");
					$sel->click_ok("link=Logout", 'User clicks on logout, after a Linkedin login');
					$sel->wait_for_text_present_ok("Harness the power of your","30000",'User successfully logs out');
				}
				else
				{
					$logged_fail_count++;
					$sel->capture_screenshot($location.'loginjobspagefailed_'.$logged_fail_count.'_times'.'.png');
				}
			}	
			else
			{
				$linkedin_fail_count++;
				$sel->capture_screenshot($location.'linkedinloginpagefailed_'.$linkedin_fail_count.'_times'.'.png');
			}	
		}
	
	}

}
	
	
}
end:
if ($linkedin_fail_count > 1){ok(0,"The Linkedin Login Authorization page has failed to load $linkedin_fail_count times\n");}
if ($home_fail_count > 1){ok(0,"The Home page \(www.jibe.com\) has failed to load $home_fail_count times\n");}
if ($logged_fail_count > 1) {ok(0,"The jobs page after a Linked Login has failed to load $logged_fail_count times\n");}

$sel->stop;
exit();
