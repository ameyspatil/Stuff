use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More "no_plan";
use Test::Exception;

my $u1= $ARGV[0];
my $u2= $ARGV[1];
my $env= 0;
my $location="/home/boris/Desktop/LoginChecks/FacebookLogin/".localtime(time);

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


my $facebook_fail_count=0;
my $home_fail_count=0;
my $logged_fail_count=0;
$sel->start;
$sel->open_ok("$env");
$sel->window_maximize();
$sel->set_speed("500");
if ($sel->wait_for_text_present_ok("Harness the power of your","Home page opens up"))
{
	facebook();
}
else
{
	$home_fail_count++;
	$sel->capture_screenshot($location.'homepagefailed_'.$home_fail_count.'_times'.'.png');
	$sel->open_ok("$env");
	if ($sel->wait_for_text_present_ok("Harness the power of your","Home page opens up"))
		{
			facebook();	
		}
	else
	{
		$home_fail_count++;
		$sel->capture_screenshot($location.'homepagefailed_'.$home_fail_count.'_times'.'.png');
		$sel->open_ok("$env");
		if ($sel->wait_for_text_present_ok("Harness the power of your","Home page opens up"))
			{
				facebook();	
			}
	}
}

sub facebook
{
	$sel->click_ok("link=FB",'User clicks on Facebook Login image on the Home page');
	$sel->select_pop_up("null");	
	if ($sel->wait_for_text_present_ok("Log in to use your Facebook", "30000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed'))
	{	
		$sel->type_ok("email", "facebookdontcare\@gmail.com",'User enters Facebook credentials - Username');
		$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
		$sel->key_press("pass", "\\13",'User hits enter to submit Facebook Login credentials');
		$sel->select_window("null");
		if($sel->wait_for_text_present_ok("Stacey Lin", "30000","User sucessfully logs in using FB"))
		{
			$sel->click("css=span");
			$sel->click_ok("link=Logout", 'User clicks on logout, after a FB login');
			$sel->wait_for_text_present_ok("Harness the power of your","30000",'User successfully logs out');
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
		$facebook_fail_count++;
		$sel->capture_screenshot($location.'facebookpopupfailed_'.$facebook_fail_count.'_times'.'.png');
		$sel->select_pop_up("null");
		$sel->close();
		$sel->select_window("null");
		$sel->open_ok("$env");
		$sel->set_speed("1000");
		$sel->wait_for_text_present_ok("Harness the power of your","Home page opens up");
		$sel->click_ok("link=FB",'User clicks on Facebook Login image on the home page to login');
		$sel->select_pop_up("null");
		if ($sel->wait_for_text_present_ok("Log in to use your Facebook", "30000",'Facebook Login Popup Loads - waiting for the text to be displayed in the popup'))
		{	
			$sel->type_ok("email", "facebookdontcare\@gmail.com",'User enters Facebook credentials - Username');
			$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
			$sel->key_press("pass", "\\13",'User hits enter to submit Facebook Login credentials');
			$sel->select_window("null");
			if($sel->wait_for_text_present_ok("Stacey Lin", "30000","User sucessfully logs in using FB"))
			{
				$sel->click("css=span");
				$sel->click_ok("link=Logout", 'User clicks on logout, after a FB login');
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
			$facebook_fail_count++;
			$sel->capture_screenshot($location.'facebookpopupfailed_'.$facebook_fail_count.'_times'.'.png');
			$sel->select_pop_up("null");
			$sel->close();
			$sel->select_window("null");
			$sel->open_ok("$env");
			$sel->wait_for_text_present_ok("Harness the power of your","Home page opens up");
			$sel->click_ok("link=FB",'User clicks on Facebook Login');
			$sel->select_pop_up("null");
			if ($sel->wait_for_text_present_ok("Log in to use your Facebook", "30000",'Facebook Login Popup Loads'))
			{
				$sel->type_ok("email", "facebookdontcare\@gmail.com",'User enters Facebook credentials - Username');
				$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
				$sel->key_press("pass", "\\13",'User returns Facebook Login credentials');
				$sel->select_window("null");
				if($sel->wait_for_text_present_ok("Stacey Lin", "30000","User sucessfully logs in using FB"))
				{
					$sel->click("css=span");
					$sel->click_ok("link=Logout", 'User clicks on logout, after a FB login');
					$sel->wait_for_text_present_ok("Harness the power of your","30000",'User successfully logs out');
				}
				else
				{
					$logged_fail_count++;
					$sel->capture_screenshot($location.'loginjobspagefailed_'.$logged_fail_count.'_times'.'.png');
				}
			}
	
		}

	}
}	
end:
if ($facebook_fail_count != 0) {ok(0,"The Facebook Popup page has failed to load $facebook_fail_count times\n");}
if ($home_fail_count != 0)     {ok(0,"The Home page \(www.jibe.com\) has failed to load $home_fail_count times\n");}
$sel->stop;
if ($logged_fail_count != 0)
{
	ok(0,"The jobs page after a Facebook Login has failed to load $logged_fail_count times\n");
	$sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "$env" );
	$sel->start;
	$sel->open_ok("$env");
	$sel->window_maximize();
	$sel->set_speed("500");
	if ($sel->wait_for_text_present_ok("Harness the power of your","Home page opens up"))
	{
		facebook1();
	}
	else
	{
		$home_fail_count++;
		$sel->capture_screenshot($location.'homepagefailed_'.$home_fail_count.'_times'.'.png');
		$sel->open_ok("$env");
		if ($sel->wait_for_text_present_ok("Harness the power of your","Home page opens up"))
			{
				facebook1();	
			}
		else
		{
			$home_fail_count++;
			$sel->capture_screenshot($location.'homepagefailed_'.$home_fail_count.'_times'.'.png');
			$sel->open_ok("$env");
			if ($sel->wait_for_text_present_ok("Harness the power of your","Home page opens up"))
				{
					facebook1();	
				}
		}
	}
	
	sub facebook1
	{
		$sel->click_ok("link=FB",'User clicks on Facebook Login');
		$sel->select_pop_up("null");	
		if ($sel->wait_for_text_present_ok("Log in to use your Facebook", "30000",'Facebook Login Popup Loads'))
		{
			$sel->type_ok("email", "facebookdontcare\@gmail.com",'User enters Facebook credentials - Username');
			$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
			$sel->key_press("pass", "\\13",'User returns Facebook Login credentials');
			$sel->select_window("null");
			if($sel->wait_for_text_present_ok("Stacey Lin", "30000","User sucessfully logs in using FB"))
			{
				$sel->click("css=span");
				$sel->click_ok("link=Logout", 'User clicks on logout, after a FB login');
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
			$facebook_fail_count++;
			$sel->capture_screenshot($location.'facebookpopupfailed_'.$facebook_fail_count.'_times'.'.png');
			$sel->select_pop_up("null");
			$sel->close();
			$sel->select_window("null");
			$sel->open_ok("$env");
			$sel->set_speed("500");
			$sel->wait_for_page_to_load_ok("30000");
			$sel->click_ok("link=FB",'User clicks on Facebook Login');
			$sel->select_pop_up("null");
			if ($sel->wait_for_text_present_ok("Log in to use your Facebook", "30000",'Facebook Login Popup Loads'))
			{	
				
				$sel->type_ok("email", "facebookdontcare\@gmail.com",'User enters Facebook credentials - Username');
				$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
				$sel->key_press("pass", "\\13",'User returns Facebook Login credentials');
				$sel->select_window("null");
				if($sel->wait_for_text_present_ok("Stacey Lin", "30000","User sucessfully logs in using FB"))
				{
					$sel->click("css=span");
					$sel->click_ok("link=Logout", 'User clicks on logout, after a FB login');
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
				$facebook_fail_count++;
				$sel->capture_screenshot($location.'facebookpopupfailed_'.$facebook_fail_count.'_times'.'.png');
				$sel->select_pop_up("null");
				$sel->close();
				$sel->select_window("null");
				$sel->open_ok("$env");
				$sel->wait_for_page_to_load_ok("30000");
				$sel->click_ok("link=FB",'User clicks on Facebook Login');
				$sel->select_pop_up("null");
				if ($sel->wait_for_text_present_ok("Log in to use your Facebook", "30000",'Facebook Login Popup Loads'))
				{
					$sel->type_ok("email", "facebookdontcare\@gmail.com",'User enters Facebook credentials - Username');
					$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
					$sel->key_press("pass", "\\13",'User returns Facebook Login credentials');
					$sel->select_window("null");
					if($sel->wait_for_text_present_ok("Stacey Lin", "30000","User sucessfully logs in using FB"))
					{
						$sel->click("css=span");
						$sel->click_ok("link=Logout", 'User clicks on logout, after a FB login');
						$sel->wait_for_text_present_ok("Harness the power of your","30000",'User successfully logs out');
					}
					else
					{
						$logged_fail_count++;
						$sel->capture_screenshot($location.'loginjobspagefailed_'.$logged_fail_count.'_times'.'.png');
					}
				}
		
			}
	
		}
	}	
}
end1: 	
if ($facebook_fail_count > 1) {ok(0,"The Facebook Popup page has failed to load $facebook_fail_count times\n");}
if ($home_fail_count > 1)     {ok(0,"The Home page \(www.jibe.com\) has failed to load $home_fail_count times\n");}
if ($logged_fail_count > 1)   {ok(0,"The jobs page after a Facebook Login has failed to load $logged_fail_count times\n");}
$sel->stop;
exit();
