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
	$env="http://localhost:3001/";
}
elsif ($u1 =~ m/stg/)
{
	$env="http://employer.testbacon.com/";
}
elsif ($u1 =~ m/prd/)
{
	$env="http://employer.jibe.com/";
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
$sel->open_ok("$env","Loading Home Page");
$sel->set_speed("500");
$sel->type_ok("id=user_email", "jibeqa4\@gmail.com" , "User enters the Username");
$sel->type_ok("id=user_password", "jibejibe", "User enters the Password");
$sel->click_ok("name=commit","User clicks GO to sign in");
#$sel->wait_for_page_to_load("30000");
$sel->wait_for_text_present_ok("Jibe1", "Company Name is displayed");
$sel->wait_for_text_present_ok("New York", "Company City is verified");
$sel->wait_for_text_present_ok("100 Employees","Number of employees in the company are 100 on login");
$sel->wait_for_text_present_ok("This is a test company","Company description on login");
$sel->click_ok("link=Edit","User clicks on Edit to update the company profile");
$sel->wait_for_page_to_load("30000");
$sel->type_ok("id=company_service_city", "Washington DC", "Change the company city to Washington DC");
$sel->select_ok("id=company_service_state", "label=New Jersey","Change the state to New Jersey");
$sel->type_ok("id=company_service_num_employees", "90","Change the number of employees to 90");
$sel->type_ok("id=company_service_about", "This is still a test company","Change the company description");
$sel->click_ok("name=commit","User confirms the changes to company profile");
#$sel->wait_for_page_to_load("30000");
$sel->wait_for_text_present_ok("Company Profile was successfully updated.","Check for message that the company profile is updated");
#$sel->pause("50000");
$sel->click_ok("link=Job Postings","User traverses to another page");
$sel->wait_for_page_to_load("30000");
$sel->click_ok("link=Dashboard","User traverses back to the dashboard");
$sel->wait_for_page_to_load("30000");
$sel->wait_for_text_present_ok("Washington DC","Confirm the change of city");
$sel->wait_for_text_present_ok("90 Employees","Confirm the change of number of employees");
$sel->wait_for_text_present_ok("This is still a test company","Confirm the change of company description");
$sel->click_ok("link=Edit","User clicks on company edit");
$sel->wait_for_page_to_load("30000");
$sel->type_ok("id=company_service_city", "New York","User changes the city back to New York");
$sel->select_ok("id=company_service_state", "label=New York","User changes the state back to  New York");
$sel->type_ok("id=company_service_num_employees", "100","User changes the number of employees back to 100");
$sel->type_ok("id=company_service_about", "This is a test company","User changes the company desc back to the old one");
$sel->click_ok("name=commit","User confirms the same");
#$sel->pause("50000");
#$sel->wait_for_page_to_load("30000");
$sel->wait_for_text_present_ok("New York","User confirms the change of city");
$sel->wait_for_text_present_ok("100 Employees","User confirms the change in number of employees");
$sel->wait_for_text_present_ok("This is a test company","User confirms the change in company desc.");
