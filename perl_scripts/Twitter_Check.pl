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
elsif ($u2 =~ m/latest/)
{
	$browser="*firefoxlatest";
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

if  (!($sel->wait_for_text_present_ok("tweet", "The Twitter server is up and running")))
{
	ok(0,"Twitter Server is down aborting test");
	goto end;
}
$sel->click_ok("link=Tweet","Click on Tweet Button");
$sel->wait_for_pop_up_ok("", "30000",'Twitter Auth Popup Loading');
$sel->select_pop_up("null");	
$sel->type_ok("username_or_email","jibeqa\@gmail.com","Enter the Twitter login name");
$sel->type_ok("password","jibejibe1124","Enter the Twitter password");
$sel->key_press("password", "\\13",'User hits return on Twitter Login credentials');
$sel->select_window("null");
sleep(10);
my $alert= $sel->get_alert();
#print "$alert\n";
if ($alert =~ m/You must enter a valid tweet/)
{
	ok(1, "The Twitter module validates that the text is invalid and hence it works ");
	#ok($sel->get_confirmation() =~ /^You must enter a valid tweet.[\s\S]$/ , 'User confirms invalid tweet');
}
else
{
	ok(0,"The App does not authorize the user and the tweet is not sent");
}
#$sel->click_ok("logout_link", 'User clicks on logout, after a FB login');
#$sel->wait_for_text_present_ok("You control your data on JIBE","9000",'User successfully logs out');
#$sel->open_ok("jobs/quality-assurance-engineer-jibe-new-york-ny",'Loading logged out jobs page');
#$sel->refresh();
#$sel->click_ok("link=Tweet","Click on Tweet Button");
#$sel->wait_for_pop_up_ok("", "30000",'Twitter Auth Popup Loading');
#$sel->select_pop_up("null");	
#$sel->wait_for_text_present_ok("Post Tweets for you.","User is succesfully logged out of the JIBE App for Twitter");
end:
$sel->stop;



