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


my $sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "$env" );
	
$sel->open_ok("$env", "THe home page opens up");
$sel->set_speed("500");


#Sign in with get started on the Home Page

#$sel->click_ok("//div[\@id='feature']/a","Click on get Started");
#$sel->wait_for_text_present_ok("Your data is always kept private on JIBE. Employers never see your","The login popup works for Get started on home page");
#$sel->click_ok("//div[\@id='modal']/div/a[1]/img","click on facebook login for get started login box");
#$sel->select_pop_up("null");	
#$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
#$sel->close();
#$sel->select_window("null");
#$sel->click_ok("//div[\@id='modal']/div/a[2]/img","click on linkedin login for get started login box");
#$sel->select_pop_up("null");	
#$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Popup Loads- waiting for text in the popup to be displayed');
#$sel->close();
#$sel->select_window("null");
#$sel->click_ok("//div[\@id='modal']/a","Close the Login popup");
#$sel->wait_for_text_present_ok("When it comes to getting a job","The login popup works");

# Sign in with About US on home page

#$sel->click_ok("//div[\@id='signin']/a[1]","Click on facebook below About JIbe on home page");
#$sel->select_pop_up("null");	
#$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
#$sel->close();
#$sel->select_window("null");
#$sel->click_ok("//div[\@id='signin']/a[2]","Close the Login popup");
#$sel->select_pop_up("null");	
#$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Popup Loads- waiting for text in the popup to be displayed');
#$sel->close();
#$sel->select_window("null");


#Stats page verification

$sel->open_ok("$env/stats", "THe logged out Stats page opens up");
$sel->click_ok("//div[\@id='stats']/div[2]/div[1]/div[2]/a","Click on get Started");
$sel->wait_for_text_present_ok("Your data is always kept private on JIBE","The login popup works from the logged out stats page");
$sel->click_ok("//div[\@id='modal']/div/div/div/a[1]/img","click on facebook login for Stats page login popup");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup (from stats page) Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='modal']/div/div/div/a[2]/img","click on linkedin login for Stats page login popup");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Popup (from stats page)Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='modal']/a","close login box on stats page");


#Jibe About Us Login Check



#changed for now!!!!
$sel->click_ok("link=FAQ",'Static Pages - FAQ Link present ');
$sel->wait_for_text_present_ok("JIBE FAQ","9000",'Static Pages - FAQ text check');

$sel->click_ok("//div[\@id='sign_in']/ul/li[2]/a/img","About us facebook Login");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='sign_in']/ul/li[3]/a/img","About us Linkedin Login");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");



#Jibe FAQ Login Check

$sel->click_ok("link=FAQ",'Static Pages - FAQ Link present ');
$sel->wait_for_text_present_ok("JIBE FAQ","9000",'Static Pages - FAQ text check');

$sel->click_ok("//div[\@id='sign_in']/ul/li[2]/a/img","Commitment facebook Login");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='sign_in']/ul/li[3]/a/img","Commitment Linkedin Login");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");




#Jibe Privacy Policy Login Check

$sel->click_ok("link=Privacy Policy",'Static Pages - Privacy Policy Link present');
$sel->wait_for_text_present_ok("Privacy Policy","9000",'Static Pages - Privacy Policy text check');

$sel->click_ok("//div[\@id='sign_in']/ul/li[2]/a/img","Commitment facebook Login");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='sign_in']/ul/li[3]/a/img","Commitment Linkedin Login");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");



#Jibe Terms of Service Login Check

$sel->click_ok("link=Terms of Service", 'Static Pages - Terms of Service Agreement Link present');
$sel->wait_for_text_present_ok("right to amend this Agreement","9000",'Static Pages -  Terms of Service');


$sel->click_ok("//div[\@id='sign_in']/ul/li[2]/a/img","Commitment facebook Login");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='sign_in']/ul/li[3]/a/img","Commitment Linkedin Login");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");


#Top Apply button login from Job desc page logged out state 
$sel->open_ok("$env/jobs/quality-assurance-engineer-jibe-new-york-ny", "Open an active job in the logged out state");
$sel->window_maximize();
$sel->set_speed("500");
$sel->click_ok("//div[\@id='content_left']/div/div[2]/ul[2]/li[2]/div/a","Click on get Started");
$sel->wait_for_text_present_ok("Your data is always kept private on JIBE. Employers never see your","The login popup works for Get started on home page");
$sel->click_ok("//img[\@alt='Connect with Facebook']","click on facebook login for Apply button from job desc logged out login box");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//img[\@alt='Login with LinkedIn']","click on linkedin login for Apply button from job desc logged out login box");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='modal']/a","Close modal");



#Bottom Apply button login from Job desc page logged out state 

$sel->click_ok("//div[\@id='content_left']/div/div[2]/div[2]/a","Click on get Started");
$sel->wait_for_text_present_ok("Your data is always kept private on JIBE. Employers never see your","The login popup works for Get started on home page");
$sel->click_ok("//img[\@alt='Connect with Facebook']","click on facebook login for Apply button from job desc logged out login box");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//img[\@alt='Login with LinkedIn']","click on linkedin login for Apply button from job desc logged out login box");
$sel->select_pop_up("null");	
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Popup Loads- waiting for text in the popup to be displayed');
$sel->close();
$sel->select_window("null");
$sel->click_ok("//div[\@id='modal']/a","Close modal");