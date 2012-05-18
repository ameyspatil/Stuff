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
$sel->click_ok("//img[\@alt='Linkedin']", 'User clicks on Linkedin to sign in');
$sel->wait_for_page_to_load("30000");
$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com", 'Linkedin User Login  - Username');
$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124", 'Linkedin User Login  -  Password');
$sel->click_ok("authorize", 'Linkedin User Login - Authorize');
$sel->wait_for_page_to_load("30000");


$sel->open_ok("$env/jobs/sr-java-slash-c++-developer-bank-of-america-new-york-ny--1/job_applications/new",'BoA Job Page');


$sel->wait_for_page_to_load("30000");
$sel->type_ok("job_application_email", "jibeqa\@gmail.com", 'BOA page 1 - User enters information in Job Application');
$sel->type_ok("job_application_phone_number", "123 456 7890",'BOA page 1 - User enters information in Job Application');
$sel->type_ok("job_application_street_address", "101 888 neww",'BOA page 1 - User enters information in Job Application');
$sel->type_ok("job_application_zip_code", "10013",'BOA page 1 - User enters information in Job Application');
$sel->select_ok("job_application_province_id", "label=New York",'BOA page 1 - User enters information in Job Application');
$sel->select_ok("job_application_resume_id", "label=Resume.txt",'BOA page 1 - User enters information in Job Application - Selects Resume');
$sel->select_ok("job_application_cover_letter_id", "label=cover_letter.pdf",'BOA page 1 - User enters information in Job Application - Selects Cover Letter');

$sel->click_ok("link=Continue", 'BOA page 1 - User enters submit');

$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Continue",'BOA page 2 - User enters submit');

$sel->wait_for_page_to_load("30000");
ok($sel->click("dialogTemplate-dialogForm-StatementBeforeAuthentificationContent-AcceptCheckbox_1"),'BOA page 3 - User enters information in Job Application');
$sel->select_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-candidatePersonalInfoBlock-CSCustomFormSubSection-_id153-dv_cs_candidate_personal_info_UDFCandidatePersonalInfo_Related_Work_Experience", "label=1",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("//option[\@value='art.hr.metaentity.common.selection.UDSElement__10120__2']",'BOA page 3 - User enters information in Job Application');
$sel->select_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-candidatePersonalInfoBlock-CSCustomFormSubSection-_id153-dv_cs_candidate_personal_info_UDFCandidatePersonalInfo_Relocation", "label=No, I would not consider relocating.",'BOA page 3 - User enters information in Job Application');
$sel->type_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-careerSectionEducationForm-educationFragmentIter-0-_id161-dv_cs_education_Institution", "National Test Pilot School (NTPS)",'BOA page 3 - User enters information in Job Application');

$sel->type_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-careerSectionWorkExperienceForm-workExperienceFragmentIter-0-_id162-dv_cs_experience_Employer", "test",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-0-questionRadio_art.hr.metaentity.question.PossibleAnswer__5075",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-1-questionRadio_art.hr.metaentity.question.PossibleAnswer__10255",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-2-questionRadio_art.hr.metaentity.question.PossibleAnswer__5087",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-3-questionRadio_art.hr.metaentity.question.PossibleAnswer__10257",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-4-questionRadio_art.hr.metaentity.question.PossibleAnswer__5077",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-5-questionRadio_art.hr.metaentity.question.PossibleAnswer__10935",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-6-questionRadio_art.hr.metaentity.question.PossibleAnswer__5079",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-7-questionRadio_art.hr.metaentity.question.PossibleAnswer__5081",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-8-questionRadio_art.hr.metaentity.question.PossibleAnswer__5083",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-9-questionRadio_art.hr.metaentity.question.PossibleAnswer__5085",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-0-questionRadio_art.hr.metaentity.question.PossibleAnswer__8535",'BOA page 3 - User enters information in Job Application');
$sel->click_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-1-questionRadio_art.hr.metaentity.question.PossibleAnswer__5089",'BOA page 3 - User enters information in Job Application');
$sel->type_ok("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-eSignatureBlock-CSCustomFormSubSection-_id166-dv_cs_esignature_Initials", "jibeqa");
$sel->click_ok("link=Continue",'BOA page 3 - User enters information in Job Application');
$sel->wait_for_page_to_load_ok("50000",'Application Submission page is displayed');
$sel->click_ok("cancel", 'User cancels BOA job application on final page');
$sel->wait_for_page_to_load("30000");







