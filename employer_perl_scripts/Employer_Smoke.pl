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
	$env="http://localhost:3001/";
}
elsif ($u1 =~ m/stg/)
{
	$env="http://employer.testbacon.com/";
}
elsif ($u1 =~ m/prd/)
{
	$env="http://employer.jibe.com/";
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
$sel->open_ok("$env","Loading Home Page");
$sel->set_speed("500");
$sel->type_ok("id=user_email", "jibeqa4\@gmail.com" , "User enters the Username");
$sel->type_ok("id=user_password", "jibejibe", "User enters the Password");
$sel->click_ok("name=commit","User clicks GO to sign in");
#$sel->wait_for_page_to_load("30000");
$sel->wait_for_text_present_ok("Signed in successfully.","Message of successful sign in is displayed");
$sel->wait_for_text_present_ok("Starred Users","Starred Candidates exist");
$sel->wait_for_text_present_ok("Jobs with New Applicants","Jobs with new applicants exist");
$sel->click_ok("link=Add a Job","User traverses to Add a new job tab");
#$sel->wait_for_page_to_load_ok("30000");
$sel->wait_for_text_present_ok("Post a Job","Post a job option is present");
$sel->wait_for_text_present_ok("Your Company Profile:","Option to edit company profile exists");
$sel->click_ok("link=Upload a Job","User traverses to the upload a job tab");
#$sel->wait_for_page_to_load_ok("30000");
$sel->wait_for_text_present_ok("Upload a Job","Upload a job page is displayed");
$sel->click_ok("link=JIBE's Commitment","User traverses to the JIBEs commitment page");
#$sel->wait_for_page_to_load_ok("30000");
$sel->wait_for_text_present_ok("The JIBE Commitment","The JIBE commitment page is displayed");
$sel->click_ok("link=FAQ","user traverses to the FAQ page");
#$sel->wait_for_page_to_load_ok("30000");
$sel->wait_for_text_present_ok("Frequently Asked Questions","The JIBE FAQ page is displayed");
$sel->click_ok("link=Sign Out","User clicks to sign out");
#$sel->wait_for_page_to_load_ok("30000");
$sel->wait_for_text_present_ok("Where your company's network is its future.","User successfully signs out");
