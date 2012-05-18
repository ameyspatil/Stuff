use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::Exception;

require 'Static_Pages.pl'; 
require 'LinkedIn_Login.pl';
require 'Fb_Login.pl';
require 'My_Account.pl';
require 'Settings.pl';
require 'Saved_Jobs.pl';
require 'Pagination.pl';
require 'Upload_Resume.pl';
require 'Job_Applications.pl';
require 'Apply_Button.pl';
use env_config;

my $u1= $ARGV[0];

static_pages();
#apply_button();
#if (!($u1 =~ m/dev/))
#{	fb_login();}
linkedin_login();
pagination();
if (!($u1 =~ m/dev/))
{	my_account(); }
settings();
saved_jobs();
upload_resume();
job_applications();
$sel->stop;
