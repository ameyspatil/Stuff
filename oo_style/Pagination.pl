use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::Exception;
use env_config;

sub pagination
{
	$sel->refresh();
	$sel->wait_for_page_to_load("30000");
	$sel->click_ok("link=2",'Click on the second page of the search results to check pagination');
	$sel->click_ok("link=3",'Click on the third page of the search results to check pagination');
	$sel->type_ok("q", "Sales");
	$sel->click_ok("//button[\@type='submit']");
	$sel->set_speed("5000");
	$sel->refresh();
	$sel->is_text_present_ok("job results for \"Sales\"");
	$sel->click_ok("link=2");
}
1;