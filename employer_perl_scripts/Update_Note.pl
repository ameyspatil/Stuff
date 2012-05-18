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
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Job Postings");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Accountant", "User clicks on a Job posting that has a candidate");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Gray, Tom", "User clicks on the candidate's name");
$sel->wait_for_page_to_load("30000");
$sel->type_ok("id=notes", "A note to check Notes","User makes a note");
$sel->click_ok("name=commit","User clicks to Save the note");
#$sel->wait_for_page_to_load("30000");
$sel->wait_for_text_present_ok("Candidate Info was successfully updated.","Note has been successfully saved message");
$sel->pause("50000");
$sel->click_ok("link=Dashboard","User navigates to the Dashboard");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Job Postings");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Accountant", "User clicks on a Job posting that has a candidate");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Gray, Tom","User clicks on the candidate's name");
$sel->wait_for_page_to_load("30000");
$sel->wait_for_text_present_ok("A note to check Notes","User confirms to see if the previously saved note still exists");
$sel->type_ok("id=notes", "","User clears the saved note");
$sel->click_ok("name=commit","User clicks to Save the note");
#$sel->wait_for_page_to_load("30000");
$sel->pause("50000");
$sel->wait_for_text_present_ok("Candidate Info was successfully updated.","Note has been successfully saved message");

