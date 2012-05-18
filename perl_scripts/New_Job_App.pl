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
$sel->open_ok("$env",																												'Loading Home Page');
$sel->set_speed("1000");
$sel->click_ok("//img[\@alt='Linkedin']", 'User clicks on Linkedin to sign in');
$sel->wait_for_page_to_load("200000");
$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com", 'Linkedin User Login  - Username');
$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124", 'Linkedin User Login  -  Password');
$sel->click_ok("authorize", 'Linkedin User Login - Authorize');
$sel->wait_for_page_to_load("30000");

$sel->open_ok("job_application/manager-communications-mtv-networks-santa-monica-ca--1",'MTV job page');



$sel->is_text_present_ok("Review and Submit Your Application","Checking if the Review and Submit page opens up");
$sel->is_text_present_ok("Informational Questions","Text check of informational questions - as these jobs have questions");
$sel->is_text_present_ok("WWWWWW WWWWWW","Text Check of a connection's name already being displayed");
$sel->is_element_present_ok("link=Cancel","Check to see if the Cancel button is displayed on page 4");
$sel->is_element_present_ok("link=Submit Application","Check to see if the Submit Application button is displayed on page 4");
$sel->click_ok("link=Edit","User clicks on profile edit button");

$sel->wait_for_text_present_ok("Email Address","Checking to see if the profile edit page is displayed");
$sel->click_ok("//div[\@id='profile']/div[2]/a[2]","Applicant clicks on continue on page 1");
 
$sel->wait_for_text_present_ok("Answer some basic employer questions:","Checking if the questions page opens up");

$sel->is_element_present_ok("link=Go Back","Check to if the Go Back button is displayed on the questions page");
$sel->click_ok("//div[\@id='questions']/div[2]/a[3]","user clicks on continue on the questions page");
$sel->wait_for_text_present_ok("Get people you know to give you a thumbs up","Check to see if the connections page - page 3 is displayed");
$sel->click_ok("//div[\@id='manage']/form/ul/li[2]/a","user traveres to the connections sent tab");
$sel->is_text_present_ok("WWWWWW WWWWWW","user checks to see if the already sent connecton's name is still displayed");
$sel->is_element_present_ok("//div[\@id='thumbs']/div[2]/a[2]","User checks if the GO BACK BUTTON is displayed on the connections page");
$sel->is_element_present_ok("//div[\@id='thumbs']/div[2]/a[1]","User checks if the CANCEL button is displayed on the connections page");
$sel->click_ok("//div[\@id='thumbs']/div[2]/a[3]","User clicks on continue on the connections page");

$sel->wait_for_text_present_ok("Review and Submit Your Application","User waits for the final submit page - page 4 to open up");
$sel->is_text_present_ok("Informational Questions","text check on page 4");
$sel->is_text_present_ok("WWWWWW WWWWWW","text check on page 4");
$sel->is_element_present_ok("link=Cancel","User checks if the CANCEL button is displayed on page 4");
$sel->is_element_present_ok("link=Submit Application","User checks if the SUBMIT APPLICATION button is displayed on page 4");
$sel->click_ok("link=Cancel","User clicks on cancel on the final submit page");
$sel->wait_for_page_to_load("30000");



$sel->open_ok("job_application/sr-java-slash-c++-developer-bank-of-america-new-york-ny--1",'BoA job Page');

$sel->is_text_present_ok("Review and Submit Your Application","Checking if the Review and Submit page opens up");
$sel->is_text_present_ok("Informational Questions","Text check of informational questions - as these jobs have questions");
$sel->is_text_present_ok("WWWWWW WWWWWW","Text Check of a connection's name already being displayed");
$sel->is_element_present_ok("link=Cancel","Check to see if the Cancel button is displayed on page 4");
$sel->is_element_present_ok("link=Submit Application","Check to see if the Submit Application button is displayed on page 4");
$sel->click_ok("link=Edit","User clicks on profile edit button");

$sel->wait_for_text_present_ok("Email Address","Checking to see if the profile edit page is displayed");
$sel->click_ok("//div[\@id='profile']/div[2]/a[2]","Applicant clicks on continue on page 1");
 
$sel->wait_for_text_present_ok("Answer some basic employer questions:","Checking if the questions page opens up");

$sel->is_element_present_ok("link=Go Back","Check to if the Go Back button is displayed on the questions page");
$sel->click_ok("//div[\@id='questions']/div[2]/a[3]","user clicks on continue on the questions page");
$sel->wait_for_text_present_ok("Get people you know to give you a thumbs up","Check to see if the connections page - page 3 is displayed");
$sel->click_ok("//div[\@id='manage']/form/ul/li[2]/a","user traveres to the connections sent tab");
$sel->is_text_present_ok("WWWWWW WWWWWW","user checks to see if the already sent connecton's name is still displayed");
$sel->is_element_present_ok("//div[\@id='thumbs']/div[2]/a[2]","User checks if the GO BACK BUTTON is displayed on the connections page");
$sel->is_element_present_ok("//div[\@id='thumbs']/div[2]/a[1]","User checks if the CANCEL button is displayed on the connections page");
$sel->click_ok("//div[\@id='thumbs']/div[2]/a[3]","User clicks on continue on the connections page");

$sel->wait_for_text_present_ok("Review and Submit Your Application","User waits for the final submit page - page 4 to open up");
$sel->is_text_present_ok("Informational Questions","text check on page 4");
$sel->is_text_present_ok("WWWWWW WWWWWW","text check on page 4");
$sel->is_element_present_ok("link=Cancel","User checks if the CANCEL button is displayed on page 4");
$sel->is_element_present_ok("link=Submit Application","User checks if the SUBMIT APPLICATION button is displayed on page 4");
$sel->click_ok("link=Cancel","User clicks on cancel on the final submit page");
$sel->wait_for_page_to_load("30000");

