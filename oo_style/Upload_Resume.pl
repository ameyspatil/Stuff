use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::Exception;
use env_config;


sub upload_resume
{	
	$sel->click_ok("//div[\@id='user_info']/div/ul/li[1]/a/strong",'User clicks on Uploaded Resumes');
	$sel->wait_for_page_to_load("30000");
	$sel->click_ok("link=Add a Resume",'User clicks to add a new resume');
	$sel->wait_for_page_to_load("30000");
	
	if ($u2 =~ m/chrome/)
	{
		$sel->type_ok("resume_resume", "\/home\/boris\/Desktop\/resume.word.doc",'User enters the file path of the resume to be uploaded');
	}
	elsif ($u2 =~ m/firefox/)
	{
		$sel->type_ok("resume_resume", "C:\\Users\\amey\\Desktop\\Sample_Resume.pdf",'User enters the file path of the resume to be uploaded');
	}	
	$sel->click_ok("//button[\@type='submit']",'User submits the resume path to begin resume upload');
	$sel->wait_for_page_to_load("30000");
	
	if ($u2 =~ m/chrome/)
	{
		$sel->is_text_present_ok("resume.word.doc",'Check to see if the uploaded resume displays');
	}
	elsif ($u2 =~ m/firefox/)
	{
		$sel->is_text_present_ok("Sample_Resume.pdf",'Check to see if the uploaded resume displays');
	}
	$sel->click_ok("nav_jobs",'User navigates to the Jobs landinng page');
	$sel->wait_for_page_to_load("30000");
	$sel->click_ok("//div[\@id='user_info']/div/ul/li[1]/a/strong",'User clicks on Uploaded Resumes');
	$sel->wait_for_page_to_load("30000");
	$sel->is_text_present_ok("Sample_Resume.pdf",'User verifies if the uploaded resume displays after navigating away from the resume page');
	$sel->click_ok("nav_jobs",'User navigates to the jobs landing page');
	$sel->wait_for_page_to_load("30000");
	$sel->set_speed("1000");
	$sel->click_ok("//div[\@id='user_info']/div/ul/li[1]/a/strong",'User clicks on Uploaded Resumes');
	$sel->wait_for_page_to_load("30000");
	$sel->click_ok("//div[\@id='search_results']/div[3]/div[2]/ul/li/a", 'User navigates to the saved resume page to delete the uploaded resume');
	$sel->get_confirmation_ok('User confirms deletion of the uploaded resume') ;
}
1;