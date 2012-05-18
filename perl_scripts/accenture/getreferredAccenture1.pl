	use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::More tests => 83;
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
elsif ($u2 =~ m/iehta/)
{$browser="*iehta";}

my $sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
                                    port => 4444, 
                                    browser => "$browser", 
                                    browser_url => "$env" );

my $iframe;
my $locator;
my $title= "Curam Developer";
my $job= "us-en/jobs/Pages/jobdetails.aspx?lang=en&job=00149822";
# Check the first page
$sel->open_ok("$job","Open Start Page");
$sel->set_speed("500");
my $html = $sel->get_html_source();
if ($html =~ m/the page you requested can't be found on/ig)
{
	ok(1,"The Job migh be deleted");
	plan skip_all => "The Job could be deleted";
	#ok(0 , "The Job could be deleted");
	#goto FINISH;
}
$sel->click_ok("GetReferredJobApplyButton1", "User clicks on the Get Referred Link on Accentures Job Desc page");
$sel->wait_for_element_present_ok("register-applicant","5000","Waiting for iframe to load on Step 1 page");
#$sel->click_ok("//section[\@id='applicant-data']/div[1]/div[3]/a");
#$sel->wait_for_text_present_ok("Negotiate new connectivity","Check if the Back button on Step 1 works");
#$sel->click_ok("get-referred-link", "get referred on Job desc page");
#$sel->wait_for_element_present_ok("register-applicant","5000");
$sel->click_ok("register-applicant","Click on Continue before entering any values in the text boxes");
$locator="window.document.getElementById('get-referred').childNodes[0].getAttribute('name')";
$iframe=$sel->get_eval($locator);
$sel->select_frame($iframe);
$sel->is_text_present_ok("$title","Check if the job title is displayed on Step 1");
$sel->is_text_present_ok("Your name is required.","Check if the text box validator for Name Works");
$sel->is_text_present_ok("A valid e-mail address is required.","Check if the text box validator for Email-id Works");
$sel->is_text_present_ok("Invalid file type","Check if the text box validator for Resume Upload works");
$sel->is_element_present_ok("link=Learn about Get Referred","Checking if the \'Learn about Get Referred\' button is displayed");
$sel->is_text_present_ok("Please enter your full name and e-mail address below","Check if text is displayed in the iframe");
$sel->type_ok("name", "Sham","User can enter Name on Step 1");
$sel->type_ok("email", "shampatel113\@gmail.com","User can enter Email-id on Step 1");
$sel->type_ok("resume", "C:\\Users\\amey\\Desktop\\Sample_Resume.pdf","User can enter Resume path on Step 1");
#$sel->type_ok("resume", "/Users/ameypatil/Desktop/Sample_Resume.pdf");
$sel->click_ok("register-applicant","User clicks on Continue on Step 1");
$sel->click_ok("//section[\@id='search-network']/div[5]/a","User clicks on Back button on Step 2");
$sel->value_is("email", "shampatel113\@gmail.com","Check to see if email textbox still has a vlaue after back on step 2");
$sel->click_ok("register-applicant","User clicks on Continue on Step 1");



# Check Send email
$sel->click_ok("//section[\@id='search-network']/div[1]/a[3]","Click to send and email");
$sel->wait_for_text_present_ok("Subject: Help me start a new career with Accenture!","Waiting for Subject line of email send to show up");
my $full_message=$sel->get_value("referrerMessage");
ok($full_message =~ m/The link above/ig,"The body of the email message loads");
$sel->type_ok("referrerName","Jibe Tester","Enter the name in the text box for send email");
$sel->type_ok("referrerEmail","shampatel113\@gmail.com","Enter the email address in the text box for send email");
$sel->click_ok("//section[\@id='compose-request']/div[2]/form/div[4]/div/a","Click back on email send Step 3");



# Check Linkedin
$sel->click_ok("//section[\@id='search-network']/div[1]/a[2]","User clicks on Linkedin Login");
$sel->select_pop_up("");
$sel->wait_for_text_present_ok("Only allow access if you trust this application with your LinkedIn", "9000",'Linkedin Login Page Loads- waiting for text to be displayed');
$sel->type_ok("session_key-oauthAuthorizeForm", "shampatel113\@gmail.com","User enters Linkedin Username");
$sel->type_ok("session_password-oauthAuthorizeForm", "jibejibe1124","User enters Linkedin Password");
$sel->click_ok("authorize","User authorizes the Linkedin Login credentials");
$sel->select_window("null");
$sel->select_frame($iframe);
$sel->wait_for_text_present_ok("Radhe Joshi","Connections Load and the Accenture connection is displayed");
$sel->click_ok("//section[\@id='search-network']/div[3]/div/ul/li/a","Click to send Radhe Joshi a linkedin message");
$sel->is_text_present_ok("Subject: Help me start a new career with Accenture!","Linkedin message loads and displays the Subject of the message");


# Check Facebook 
$sel->open_ok("$job","Open the Start Page to start testing Facebook flow");
$sel->set_speed("500");
$sel->click_ok("GetReferredJobApplyButton1", "User clicks on the Get Referred Link on Accentures Job Desc page");
$sel->wait_for_element_present_ok("register-applicant","5000","Waiting for iframe to load on Step 1 page");
$locator="window.document.getElementById('get-referred').childNodes[0].getAttribute('name')";
$iframe=$sel->get_eval($locator);
$sel->select_frame($iframe);
$sel->type_ok("name", "Sham","User can enter Name on Step 1");
$sel->type_ok("email", "shampatel113\@gmail.com","User can enter Email-id on Step 1");
$sel->type_ok("resume", "C:\\Users\\amey\\Desktop\\Sample_Resume.pdf","User can enter Resume path on Step 1");
#$sel->type_ok("resume", "/Users/ameypatil/Desktop/Sample_Resume.pdf");
$sel->click_ok("register-applicant","User clicks on Continue on Step 1");
$sel->click_ok("//section[\@id='search-network']/div[1]/a[1]","User clicks on Facebook to connect");
$sel->select_pop_up("");
$sel->wait_for_text_present_ok("Log in to use your Facebook", "9000",'Facebook Login Popup Loads- waiting for text in the popup to be displayed');
$sel->type_ok("email", "shampatel113\@gmail.com",'User enters Facebook credentials - Username');
$sel->type_ok("pass", "jibejibe1124",'User enters Facebook credentials - Password');
$sel->key_press("pass", "\\13",'User hits enter to submit Facebook Login credentials');
$sel->select_window("null");
$iframe=$sel->get_eval($locator);
$sel->select_frame($iframe);
$sel->wait_for_text_present_ok("Radhe Joshi","Waiting for connections to load and display an Accenture connection");
$sel->click_ok("//section[\@id='search-network']/div[3]/div/ul/li/a","Click to send a mesage to Radhe Joshi");
#$locator="window.document.getElementById('fb-root').getElementsByTagName('iframe')[0].getAttribute('name')";
#$iframe=$sel->get_eval($locator);
#$sel->select_frame($iframe);
$sel->pause(1000);
$sel->type_ok("feedform_user_message","Hey this is it ","User can enter some text in the message which means the message loads");



# Both together Linkedin and Facebook
$sel->open_ok("$job","Open start page");
$sel->set_speed("500");
$sel->click_ok("GetReferredJobApplyButton1","User clicks on the Get Referred Link on Accentures Job Desc page");
$sel->wait_for_element_present_ok("register-applicant","5000","Waiting for iframe to load on Step 1 page");
$locator="window.document.getElementById('get-referred').childNodes[0].getAttribute('name')";
$iframe=$sel->get_eval($locator);
$sel->select_frame($iframe);
$sel->type_ok("name", "Sham","User can enter Name on Step 1");
$sel->type_ok("email", "shampatel113\@gmail.com","User can enter Email-id on Step 1");
$sel->type_ok("resume", "C:\\Users\\amey\\Desktop\\Sample_Resume.pdf","User can enter Resume path on Step 1");
#$sel->type_ok("resume", "/Users/ameypatil/Desktop/Sample_Resume.pdf");
$sel->click_ok("register-applicant","User clicks on Continue on Step 1");
$sel->pause(1000);
$sel->click_ok("//section[\@id='search-network']/div[1]/a[2]","click to connect to Linkedin");
$sel->wait_for_text_present_ok("Radhe Joshi","Linkedin connections loads");
$sel->click_ok("//section[\@id='search-network']/div[1]/a[1]","Click to connect to facebook");
$sel->wait_for_text_present_ok("Radhe Joshi","Facebook connections load");
$sel->click_ok("//section[\@id='search-network']/div[3]/div/ul/li/a","Click Send request to the linkedin connection");
$sel->is_text_present_ok("Subject: Help me start a new career with Accenture!","Linkedin message loads");
$full_message=$sel->get_value("message");
my $give_referral;
if($full_message =~  m/.*https(.*)/gi)
{$give_referral="https".$1;}
$sel->select_frame("relative=parent");
$sel->open_ok($give_referral,"Opening Give Referral URl $give_referral");
my $temp=5;
while ($temp>0)
{
	$sel->wait_for_text_present_ok("Employee referral request","Check to see if the Give Referral page loads");
	$sel->wait_for_text_present_ok("Radhe","Check to see if the Give Referral TO name is displayed");
	$sel->wait_for_text_present_ok("Sham","Check to see if the Give Referral FROM name is displayed");
	$sel->wait_for_text_present_ok("$title","Check to see if the Give Referral job title is displayed");
	$sel->refresh();
	$temp--;
}	
$sel->click_ok("link=Next","user clicks on Next on the Give referral page");
$sel->wait_for_text_present_ok("Enterprise Sign On","9000","Next button on the Give Referral page works to display Enterprise login");
$sel->go_back();
$sel->wait_for_text_present_ok("Employee referral request","Check to see if the page loads","Give referral page loads again");
$sel->click_ok("link=Click here to download resume","resume can be downloaded");
$sel->pause(1000);
FINISH:
$sel->stop;