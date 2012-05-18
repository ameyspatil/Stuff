use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More "no_plan";
use Test::Exception;

my $u1= $ARGV[0];
my $u2= $ARGV[1];
my ($username , $password , $env , $browser, $text_check);

if ($u1 =~ m/dev/)
{
	$env="http://localhost:3000/";
}
elsif ($u1 =~ m/stg/)
{
	$env="http://jibepost.testbacon.com/";
	$username="resumes\@jibe.com";
	$password="jibejibe1124";
	$text_check="Posted Jobs"
}
elsif ($u1 =~ m/prd/)
{
	$env="http://jibepost.jibe.com/";
	$username="amey\@jibe.com";
	$password="jibejibe1124";
	$text_check="Sorry, we couldn't find a job"
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


$sel->open_ok("/login","Jibe Post $u1 login page opens up");
$sel->type_ok("id=user_session_email", "$username","user enters Username");
$sel->type_ok("id=user_session_password", "$password","user enters password");
$sel->click("id=login","User clicks on Sign in");
$sel->wait_for_text_present_ok("$text_check","3000","Use successfully logs in $u1");
$sel->click("//div[\@id='user-info']/div/a[2]/b");
$sel->click_ok("link=Logout","User clicks to logout");
$sel->wait_for_text_present_ok("Please log in:","User successfully logs out $u1");
