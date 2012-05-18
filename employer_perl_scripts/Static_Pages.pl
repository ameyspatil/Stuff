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
$sel->wait_for_text_present_ok("Where your company's network is its future.");
$sel->click_ok("link=JIBE's Commitment");
#$sel->wait_for_page_to_load_ok("30000");
$sel->wait_for_text_present_ok("The JIBE Commitment");
$sel->wait_for_text_present_ok("The job search process should be an efficient and easy experience.");
$sel->click_ok("link=FAQ");
#$sel->wait_for_page_to_load_ok("30000");
$sel->wait_for_text_present_ok("Frequently Asked Questions");
$sel->wait_for_text_present_ok("What if I don't have an ATS?");
$sel->click_ok("//div[\@id='footer']/footer/ul/li[2]/ul/li[5]/a");
#$sel->wait_for_page_to_load_ok("30000");
$sel->wait_for_text_present_ok("Your Message");
$sel->click_ok("//div[\@id='footer']/footer/ul/li[2]/ul/li[7]/a");
#$sel->wait_for_page_to_load_ok("30000");
$sel->wait_for_text_present_ok("This Privacy Policy was last revised on");
$sel->wait_for_text_present_ok("User Content you post to the Service");
$sel->click_ok("//div[\@id='footer']/footer/ul/li[2]/ul/li[9]/a");
#$sel->wait_for_page_to_load_ok("30000");
$sel->wait_for_text_present_ok("Terms of Use Agreement");
$sel->wait_for_text_present_ok("This Agreement applies to all visitors, users, and");
