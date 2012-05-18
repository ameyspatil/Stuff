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

$sel->wait_for_text_present_ok("tweet","9000","The user sucessfully logs in");

$sel->click_ok("link=My Profile",'User click on My Profile');


$sel->wait_for_text_present_ok("First Name","9000","My account page displayed");
$sel->wait_for_text_present_ok("Last Name","9000","My account page displayed");

$sel->click_ok("link=My Stats",'User clicks on My Stats');

$sel->wait_for_text_present_ok("Top Employers","9000",'Text check on My Stats Page');
$sel->wait_for_text_present_ok("Unemployment","9000",'Text check on My Stats Page');
$sel->click_ok("link=Browse my network",'User clicks on My Network');

$sel->wait_for_text_present_ok("Popular Job Titles","9000",'Text check on My Network page');
