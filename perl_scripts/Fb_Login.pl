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
$sel->open_ok("$env");
$sel->set_speed("500");

$sel->click_ok("//img[\@alt='Facebook']",'User clicks on Facebook Login');
$sel->wait_for_pop_up_ok("", "30000",'Facebook Login Popup Loading');
$sel->select_pop_up("null");	

$sel->type_ok("email", "facebookdontcare\@gmail.com",'User enters Facebook credentials - Username');
$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
$sel->key_press("pass", "\\13",'User returns Facebook Login credentials');
#alias stagedb='mysql -u toby -puLT9L5BsVxBQDpFJ jibe_staging'
$sel->set_speed("5000");
$sel->select_window("null");
$sel->wait_for_text_present_ok("tweet","9000","The user sucessfully logs in");

$sel->click_ok("logout_link", 'User clicks on logout, after a FB login');
$sel->wait_for_text_present_ok("Harness the power of your",'User successfully logs out');

exit();
