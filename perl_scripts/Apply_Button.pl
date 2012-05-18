use Test::More "no_plan";
require LWP::UserAgent;
use JSON::XS;
use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::Exception;


my $u1= $ARGV[0];
my $u2= $ARGV[1];
my $env= 0;
my $browser= '';
my $j_env=0;
my $u_env=0;
if ($u1 =~ m/stg/)
{
	$j_env="209.114.35.61:8080";
        $u_env="jibeqa:jibejibe1124\@jibe.testbacon.com";
}
elsif ($u1 =~ m/prd/)
{
	$j_env="173.203.239.198:8080";
        $u_env="www.jibe.com";
	$env="http://www.jibe.com";
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


my $sel = Test::WWW::Selenium->new( host => "localhost", 
                                port => 4444, 
                                browser => "$browser", 
                                browser_url => "$env" );


$sel->open_ok("$env/jobs/quality-assurance-engineer-jibe-new-york-ny", "Open an active job in the logged out state");
$sel->set_speed("500");

#Top Apply button login from Job desc page logged out state 

$sel->click_ok("//div[\@id='content_left']/div/div[2]/ul[2]/li[2]/div/a","Click on get Started");
$sel->wait_for_text_present_ok("Your data is always kept private on JIBE. Employers never see your","The login popup works for Get started on home page");
$sel->click_ok("//div[\@id='login_buttons']/table[2]/tbody/tr/td[1]/a/img","click on facebook login for Apply button from job desc logged out login box");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='login_buttons']/table[2]/tbody/tr/td[3]/a/img","click on linkedin login for Apply button from job desc logged out login box");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='login_buttons']/table[1]/tbody/tr/td[2]/a","Click on get Started");


#Bottom Apply button login from Job desc page logged out state 

$sel->click_ok("//div[\@id='content_left']/div/div[2]/div[2]/a","Click on get Started");
$sel->wait_for_text_present_ok("Your data is always kept private on JIBE. Employers never see your","The login popup works for Get started on home page");
$sel->click_ok("//div[\@id='login_buttons']/table[2]/tbody/tr/td[1]/a/img","click on facebook login for Apply button from job desc logged out login box");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='login_buttons']/table[2]/tbody/tr/td[3]/a/img","click on linkedin login for Apply button from job desc logged out login box");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='login_buttons']/table[1]/tbody/tr/td[2]/a","Close popup box");




