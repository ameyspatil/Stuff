package env_config;
use strict;
use warnings;
use Test::WWW::Selenium;
use Exporter;
use Test::More "no_plan";


our $u1= $ARGV[0];
our $u2= $ARGV[1];
our $env=0;
our $browser=0;
our $j_env=0;
our $u_env=0;
our $c_env=0;

if ($u1 =~ m/dev/)
{
	$env="http://js01.internal.jibe.com:3000/";
}
elsif ($u1 =~ m/stg/)
{
	$env="http://jibeqa:jibejibe1124\@jibe.testbacon.com/";
	$j_env="209.114.35.61:8080";
	$u_env="http://jibeqa:jibejibe1124\@jibe.testbacon.com/";
}
elsif ($u1 =~ m/prd/)
{
	$env="http://www.jibe.com/";
	$j_env="jobservice1.jibe.com:8080";
    $u_env="www.jibe.com";
	$c_env="companyservice1.jibe.com:8080";##"209.114.47.232:8080";#companyservice ip address
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


our $sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
				    port => 4444, 
				    browser => "$browser", 
				    browser_url => "$env" );


		   
our @ISA = qw(Exporter);	   
our @EXPORT = qw($env $browser $sel $u1 $u2 $j_env $u_env $c_env);
