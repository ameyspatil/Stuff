use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::Exception;
use env_config;



sub static_pages
{
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
}
1;