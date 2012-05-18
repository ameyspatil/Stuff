require LWP::UserAgent;
use JSON::XS;
use strict;
use warnings;
use Time::HiRes qw(sleep);
use Test::WWW::Selenium;
use Test::Exception;
use env_config;

sub apply_button
{
	get_slug_from_active();
	
	sub get_slug_from_active
	{
	    my $ua = LWP::UserAgent->new;
	    $ua->timeout(3);    
	    $ua->env_proxy; 
	    my $response = $ua->get("http://$j_env/jobs/all/status/active.json");
	    my $actual_response=$response->decoded_content;
	    my $perl_scalar = decode_json($actual_response);
	    my $slug1= $perl_scalar->[0]->{slug};
	    my $title1= $perl_scalar->[0]->{title};
	    apply($slug1,$title1)
	}
	
	sub apply
	{
		my $sel = Test::WWW::Selenium->new( host => "windoze2.jibe.com", 
					    port => 4444, 
					    browser => "$browser", 
					    browser_url => "$env" );
		my ($slug,$title)=@_;
		
		$sel->open_ok("$env/jobs/$slug", "Open an active job in the logged out state");
		$sel->set_speed("500");
		if ($sel->is_text_present_ok("$title","Checking if the title for the active job is displayed on the logged out job desc page"))
		{
			$sel->click_ok("link=Apply","Click on Apply on the logged out job desc page");
			$sel->click_ok("css=a.linkedin-connect > img","Click on linkedin to sign in from the logged out job desc page");	
		}
		else
		{
			$sel->click_ok("//img[\@alt='Linkedin']",'User cicks on linkedin login button on the home page');
		}
		$sel->wait_for_page_to_load("30000");
		$sel->type_ok("id=session_key-oauthAuthorizeForm", "jibeqa\@gmail.com");
		$sel->type_ok("id=session_password-oauthAuthorizeForm", "jibejibe1124");
		$sel->click_ok("name=authorize");
		$sel->wait_for_page_to_load_ok("30000");
		$sel->is_text_present_ok("$title");
		$sel->click_ok("id=nav_jobs");
		$sel->wait_for_page_to_load_ok("30000");
		
		my $html_source = $sel->get_html_source();
		$html_source =~ m/job_id="(.*)"/;
		my $jobid = $1;
		my $html_title;
		$html_source =~ m/ceid.*>(.*)<\/a>/;
		$html_title = $1;
		$sel->click_ok("link=Apply","User clicks on apply for $html_title");
		$sel->wait_for_page_to_load_ok("30000");
		$sel->is_text_present_ok("$html_title");
		$sel->click_ok("link=JIBE");
		$sel->wait_for_page_to_load_ok("30000");
		$sel->click_ok("link=$html_title");
		$sel->wait_for_page_to_load_ok("30000");
		$sel->click_ok("link=Apply");
		$sel->wait_for_page_to_load_ok("30000");
		$sel->is_text_present_ok("$html_title");
		$sel->click_ok("id=logout_link");
		$sel->wait_for_page_to_load_ok("30000");
	}	

}