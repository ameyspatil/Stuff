
use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More tests => 23;
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

my $waste=0;

$sel->start();
$sel->open_ok("$env","Loading Home Page");
$sel->set_speed("500");
$sel->type_ok("id=user_email", "jibeqa4\@gmail.com" , "User enters the Username");
$sel->type_ok("id=user_password", "jibejibe", "User enters the Password");
$sel->click_ok("name=commit","User clicks GO to sign in");  
$sel->wait_for_page_to_load("30000");
$sel->is_text_present_ok("Gray, Tom","Candidates name is originally starred");
$sel->click_ok("link=Star","User clicks on the Star on the dashboard to Unstar the candidate");
$sel->pause("90000");
$sel->click_ok("link=Dashboard","User traverses to the Dashboard");
if ($sel->is_text_present("Gray, Tom"))
{
    print "not ok - The unstarring does not work when done from the dashboard \n";
}
else
{
    ok($waste = $waste +1);
}
$sel->click_ok("link=Job Postings");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Accountant","User traverses to the individual Job Post");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Star","User Stars the candidiate on the individual Job Post");
$sel->pause("5000");
$sel->click_ok("link=Dashboard","User traverses to the Dashboard");
$sel->wait_for_page_to_load("30000");
$sel->is_text_present_ok("Gray, Tom","Candidate appears on the Dashboard as starred, after starred on the individual Job Post");
$sel->click_ok("link=Job Postings");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Accountant","User traverses to the individual Job Post");
$sel->wait_for_page_to_load("30000");   
$sel->click_ok("link=Gray, Tom","User clicks on the candidate profile page");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Star","User clicks on the Star on the candidate profile page to Unstar the candidate");
$sel->pause("5000");
$sel->click_ok("link=Dashboard","User traverses to the Dashboard");
$sel->wait_for_page_to_load("30000");
if ($sel->is_text_present("Gray, Tom"))
{
    print "not ok - The unstarring does not work when done from the candidate profile page \n";
}
else
{
    ok($waste = $waste +1);
}
$sel->click_ok("link=Job Postings");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Accountant","User traverses to the individual Job Post");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Star","User Stars the candidiate on the individual Job Post");
$sel->pause("5000");
$sel->click_ok("link=Dashboard","User traverses to the Dashboard");
$sel->wait_for_page_to_load("30000");
