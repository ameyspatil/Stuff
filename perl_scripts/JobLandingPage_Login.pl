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
	$browser="*chrome";
}

my $sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "$env" );

$sel->open_ok("/jobs/quality-assurance-analyst-jibe-new-york-city-ny");
$sel->set_speed("500");
$sel->wait_for_text_present_ok("Gilt", "9000",'The logged out job landing page opens');
$sel->click_ok("//div[\@id='content_left']/div/div[2]/ul[2]/li[2]/div/a");
$sel->click_ok("//img[\@alt='Login with LinkedIn']");

$sel->select_window_ok("name=ConnectWithLinkedIn","User Selects the Linkedin Login popup");
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Page Loads- waiting for text to be displayed');
$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa3\@gmail.com","User enters Linkedin Username");
$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124","User enters Linkedin Password");
$sel->click_ok("authorize","User authorizes the Linkedin Login credentials");
$sel->select_window("null");

$sel->wait_for_text_present_ok("ZIP Code","9000","Job app flow page opens");
$sel->click_ok("link=JIBE");
$sel->wait_for_text_present_ok("Social Dashboard", "9000","User sucessfully logs in using Linkedin");
$sel->click_ok("logout_link");
$sel->wait_for_text_present_ok("Harness the power of your","9000",'User successfully logs out');

$sel->open_ok("/jobs/quality-assurance-analyst-jibe-new-york-city-ny");
$sel->wait_for_text_present_ok("Gilt", "9000",'The logged out job landing page opens');
$sel->click_ok("//div[\@id='content_left']/div/div[2]/ul[2]/li[2]/div/a");
$sel->click_ok("//img[\@alt='Connect with Facebook']");
$sel->select_pop_up("null");

$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
$sel->type_ok("email", "facebookdontcare\@gmail.com",'User enters Facebook credentials - Username');
$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
$sel->key_press("pass", "\\13",'User hits enter to submit Facebook Login credentials');
$sel->select_window("null");

$sel->wait_for_text_present_ok("ZIP Code","9000","Job app flow page opens");
$sel->click_ok("link=JIBE");
$sel->wait_for_text_present_ok("tweet", "9000","User sucessfully logs in using Linkedin");
$sel->click_ok("logout_link");
$sel->wait_for_text_present_ok("Harness the power of your","9000",'User successfully logs out');

$sel->stop;

#$sel->click_ok("email");
#$sel->type_ok("email", "jibeqa\@gmail.com");
#$sel->type_ok("pass", "jibejibe1124");
#$sel->click_ok("uavilj_1");
