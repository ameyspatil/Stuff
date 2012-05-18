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
$sel->set_speed("500");
$sel->click_ok("id=learn_more", "Click to open the recruiting pages");

$sel->wait_for_text_present_ok("Recruiting evolved","30000","Recruiting page loads");

$sel->click_ok("//a[contains(\@href,'get-referred')]","Click on Get referred learn more");
$sel->wait_for_text_present_ok("your existing platform","Get Referred info page loads");
$sel->is_element_present_ok("link=Contact us to learn more","Contact us button on Get refereed page is displayed");
$sel->click_ok("css=a.tab.next > span","Click on next to view next info page");

$sel->wait_for_text_present_ok("JIBE Post allows users","3000","Jibe Post info page loads");
$sel->is_element_present_ok("link=Email us for info","Email us link is displayed");
$sel->is_element_present_ok("link=Contact us to learn more","Contact us button on Jibe Post page is displayed");
$sel->click_ok("css=a.tab.next > span","Click on next to view next info page");

$sel->wait_for_text_present_ok("JIBE Apply allows you","3000","Jibe Apply info page loads");
$sel->is_element_present_ok("link=Contact us to learn more","Contact us button on Jibe Apply page is displayed");
$sel->click_ok("css=a.tab.next > span","Click on next to view next info page");

$sel->wait_for_text_present_ok("Every JIBE user signs in using","3000","Dot come info page loads");
$sel->is_text_present_ok("Every JIBE user signs in using","Dot come info page loads");
$sel->click_ok("link=Home","Home button on top left corner page is displayed");

$sel->wait_for_text_present_ok("Innovative solutions");
$sel->click("link=About Us");
$sel->wait_for_text_present_ok("JIBE is a software company that provides enterprises","3000","About us page loads");
$sel->is_element_present_ok("css=img[alt=\"If You Build IT, They Will Come\"]","White page download image displayed");

$sel->click("link=Blog");
$sel->wait_for_text_present_ok("Blog","3000","Jibe blog page opens");
$sel->is_element_present_ok("css=img[alt=\"If You Build IT, They Will Come\"]","White page download image displayed");


$sel->click("link=Press");
$sel->wait_for_text_present_ok("Please direct media inquiries","media page opens");
$sel->is_element_present_ok("css=img[alt=\"If You Build IT, They Will Come\"]","White page download image displayed");

$sel->click("link=Contact Us");
$sel->wait_for_text_present_ok("If you are interested in learning","3000","Contact us page opens up");
