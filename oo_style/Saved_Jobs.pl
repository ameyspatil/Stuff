use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::Exception;
use env_config;


sub saved_jobs
{
	$sel->open_ok("jobs",'Loading Home Page');
	
	#my $jobid = "0";
	#my $html_source;
	#$html_source = $sel->get_html_source();
	#$html_source =~ m/job_id="(.*)"/;
	#$jobid = $1;
	$sel->click_ok("link=Save");
	#$sel->click_ok("//div[\@id='job_result_$jobid']/div/div/ul/li[2]/span/a",'User clicks on a job to be saved');
	$sel->is_text_present_ok("Saved!",'Checks to see if the text Save changes to  Saved!');
	$sel->click_ok("link=1 Saved Jobs",'User navigates to the saved jobs page');
	$sel->wait_for_page_to_load("30000");
	#$sel->is_text_present_ok("Saved!",'User verifies if the saved job displays on the Saved-Jobs page');
	#$sel->click_ok("link=Saved!", 'User Removes the saved job');
	$sel->is_text_present_ok("Unsave",'User verifies if the saved job displays on the Saved-Jobs page');
	$sel->click_ok("link=Unsave");
	$sel->click("id=nav_jobs");
	$sel->wait_for_page_to_load_ok("30000");
}
1;