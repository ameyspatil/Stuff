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
{$env="http://localhost:3000/";}
elsif ($u1 =~ m/stg/)
{$env="http://jibeqa:jibejibe1124\@jibe.testbacon.com/";}
elsif ($u1 =~ m/prd/)
{$env="http://careers.accenture.com/";}



if ($u2 =~ m/safari/)
{$browser="*safari";}
elsif ($u2 =~ m/firefox/)
{$browser="*firefox";}
elsif ($u2 =~ m/iexplore/)
{$browser="*iexplore";}
elsif ($u2 =~ m/chrome/)
{$browser="*chrome";}

my $sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "$env" );

my $iframe;
my $locator;

# Check the first page
$sel->open_ok("us-en/jobs/Pages/jobdetails-test.aspx?lang=en&job=00142752","Open Start Page");
$sel->set_speed("500");
$sel->click_ok("get-referred-link", "get referred on Job desc page","Click on Get Referred provided on Accenture");

$sel->wait_for_element_present_ok("register-applicant","5000","Wait to see if the Continue button on Step 1 is displayed");
$sel->click_ok("register-applicant","Click on Continue on Step 1");
$locator="window.document.getElementById('get-referred').childNodes[0].getAttribute('name')";
$iframe=$sel->get_eval($locator);
$sel->select_frame($iframe);
$sel->is_text_present_ok("Production Monitoring Analyst","Check if the iframe loads");
$sel->is_text_present_ok("Your name is required.");
$sel->is_text_present_ok("A valid e-mail address is required.");
$sel->is_text_present_ok("Invalid file type");
$sel->is_element_present_ok("link=Learn about Get Referred");
$sel->is_text_present_ok("Please enter your full name and e-mail address below");
$sel->type_ok("name", "Tom");
$sel->type_ok("email", "jibeqa\@gmail.com");
$sel->type_ok("resume", "C:\\Users\\amey\\Desktop\\Sample_Resume.pdf");
#$sel->type_ok("resume", "/Users/ameypatil/Desktop/Sample_Resume.pdf");
$sel->click_ok("register-applicant");
$sel->click_ok("//section[\@id='search-network']/div[5]/a");
$sel->value_is("email", "jibeqa\@gmail.com");
$sel->click_ok("register-applicant");



# Check Send email
$sel->click_ok("//section[\@id='search-network']/div[1]/a[3]");
$sel->wait_for_text_present_ok("Subject: Help me start a new career with Accenture!");
my $full_message=$sel->get_value("referrerMessage");
ok($full_message =~ m/The link above/ig,"The email message loads");
$sel->type_ok("referrerName","Jibe Tester","Enter the name in the text box for send email");
$sel->type_ok("referrerEmail","jibeqa\@gmail.com","Enter the email address in the text box for send email");
$sel->click_ok("//section[\@id='compose-request']/div[2]/form/div[4]/div/a");



# Check Linkedin
$sel->click_ok("//section[\@id='search-network']/div[1]/a[2]");
$sel->select_pop_up("");
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Page Loads- waiting for text to be displayed');
$sel->type_ok("session_key-oauthAuthorizeForm", "jibeqa\@gmail.com","User enters Linkedin Username");
$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124","User enters Linkedin Password");
$sel->click_ok("authorize","User authorizes the Linkedin Login credentials");
$sel->select_window("null");
$sel->select_frame($iframe);
$sel->wait_for_text_present_ok("Jimmy Sean");
$sel->click_ok("//section[\@id='search-network']/div[3]/div/ul/li/a");
$sel->is_text_present_ok("Subject: Help me start a new career with Accenture!");


# Check Facebook 
$sel->open_ok("us-en/jobs/Pages/jobdetails-test.aspx?lang=en&job=00142752");
$sel->set_speed("500");
$sel->click_ok("get-referred-link", "get referred on Job desc page");
$sel->wait_for_element_present_ok("register-applicant","5000");
$locator="window.document.getElementById('get-referred').childNodes[0].getAttribute('name')";
$iframe=$sel->get_eval($locator);
$sel->select_frame($iframe);
$sel->type_ok("name", "Tom");
$sel->type_ok("email", "jibeqa\@gmail.com");
$sel->type_ok("resume", "C:\\Users\\amey\\Desktop\\Sample_Resume.pdf");
#$sel->type_ok("resume", "/Users/ameypatil/Desktop/Sample_Resume.pdf");
$sel->click_ok("register-applicant");
$sel->click_ok("//section[\@id='search-network']/div[1]/a[1]");
$sel->select_pop_up("");
$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
$sel->type_ok("email", "jiberesumes\@gmail.com",'User enters Facebook credentials - Username');
$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
$sel->key_press("pass", "\\13",'User hits enter to submit Facebook Login credentials');
$sel->select_window("null");
$iframe=$sel->get_eval($locator);
$sel->select_frame($iframe);
$sel->wait_for_text_present_ok("Jimmy Sean");
$sel->click_ok("//section[\@id='search-network']/div[3]/div/ul/li/a");
#$locator="window.document.getElementById('fb-root').getElementsByTagName('iframe')[0].getAttribute('name')";
#$iframe=$sel->get_eval($locator);
#$sel->select_frame($iframe);
$sel->pause(1000);
$sel->type_ok("feedform_user_message","Hey this is it ");



# Both together Linkedin and Facebook
$sel->open_ok("us-en/jobs/Pages/jobdetails-test.aspx?lang=en&job=00142752");
$sel->set_speed("500");
$sel->click_ok("get-referred-link", "get referred on Job desc page");
$sel->wait_for_element_present_ok("register-applicant","5000");
$locator="window.document.getElementById('get-referred').childNodes[0].getAttribute('name')";
$iframe=$sel->get_eval($locator);
$sel->select_frame($iframe);
$sel->type_ok("name", "Tom");
$sel->type_ok("email", "jibeqa\@gmail.com");
$sel->type_ok("resume", "C:\\Users\\amey\\Desktop\\Sample_Resume.pdf");
#$sel->type_ok("resume", "/Users/ameypatil/Desktop/Sample_Resume.pdf");
$sel->click_ok("register-applicant");
$sel->click_ok("//section[\@id='search-network']/div[1]/a[2]");
$sel->wait_for_text_present_ok("Jimmy Sean");
$sel->click_ok("//section[\@id='search-network']/div[1]/a[1]");
$sel->wait_for_text_present_ok("Jimmy Sean");
$sel->click_ok("//section[\@id='search-network']/div[3]/div/ul/li/a");
$sel->is_text_present_ok("Subject: Help me start a new career with Accenture!");
$full_message=$sel->get_value("message");
my $give_referral;
if($full_message =~  m/.*https(.*)/gi)
{$give_referral="https".$1;}
$sel->select_frame("relative=parent");
$sel->open_ok($give_referral);
$sel->wait_for_text_present_ok("Employee referral request","Check to see if the Give Referral page loads");
$sel->wait_for_text_present_ok("Jimmy","Check to see if the Give Referral page loads");
$sel->wait_for_text_present_ok("Tom","Check to see if the Give Referral page loads");
$sel->wait_for_text_present_ok("Production Monitoring Analyst","Check to see if the Give Referral page loads");
$sel->click_ok("link=Next");
$sel->wait_for_text_present_ok("Enterprise Sign On","9000","Next button on the Give Referral page works");
$sel->go_back();
$sel->wait_for_text_present_ok("Employee referral request","Check to see if the page loads");
$sel->click_ok("link=Click here to download resume");
$sel->pause(1000);