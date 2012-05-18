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
elsif ($u2 =~ m/iphone/)
{
	$browser="*firefoxiphone";
}


my $sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "$env" );


$sel->open_ok("$env");
$sel->set_speed("500");
$sel->click_ok("link=About Us",'Static Pages - About Us');
$sel->wait_for_text_present_ok("where friends help friends land","9000",'Static Pages - About Us text check');
$sel->click_ok("link=FAQ",'Static Pages - FAQ Link present ');
$sel->wait_for_text_present_ok("JIBE FAQ","9000",'Static Pages - FAQ text check');
$sel->click_ok("link=Privacy Policy",'Static Pages - Privacy Policy Link present');
$sel->wait_for_text_present_ok("Privacy Policy","9000",'Static Pages - Privacy Policy text check');
$sel->click_ok("link=Terms of Service", 'Static Pages - Terms of Service Agreement Link present');
$sel->wait_for_text_present_ok("right to amend this Agreement","9000",'Static Pages -  Terms of Service');
