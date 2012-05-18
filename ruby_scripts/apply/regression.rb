require 'rubygems'
gem 'test-unit'
require "selenium-webdriver"
require 'rake'
require 'ci/reporter/rake/test_unit'
require 'ci/reporter/rake/test_unit_loader'
require "test/unit"


class Iphone < Test::Unit::TestCase
server = ARGV[0]
  
if server == "local"
    def setup    
        #Local machine run
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile['general.useragent.override'] = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A341 Safari/528.16'
        @driver = Selenium::WebDriver.for :firefox, :profile => profile
        @driver.manage.timeouts.implicit_wait = 30
        @verification_errors = []
    end    
elsif server == "remote"
    def setup
        #Remote machine run
        server = "htts://windoze2.jibe.com:5555/wd/hub"
        profile = Selenium::WebDriver::Firefox::Profile.new
        profile['general.useragent.override'] = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_0 like Mac OS X; en-us) AppleWebKit/528.18 (KHTML, like Gecko) Version/4.0 Mobile/7A341 Safari/528.16"
        capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(:native_events => true, :firefox_profile => profile)
        @driver = Selenium::WebDriver.for(:remote, :desired_capabilities => capabilities, :url => server)
        @driver.manage.timeouts.implicit_wait = 30
        @verification_errors = []
    end
end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_new
    @driver.get "http://www.jibe.com"
    #All footer links
    @driver.find_element(:link, "FAQ").click
    assert(@driver.find_element(:tag_name => "body").text.include?("Once you login using"),"The FAQ page loads")
    @driver.navigate.back
    @driver.find_element(:link, "Privacy Policy").click
    assert(@driver.find_element(:tag_name => "body").text.include?("explains what information of yours"),"The Privacy Policy page loads")
    @driver.navigate.back
    @driver.find_element(:link, "Terms of Use").click
    assert(@driver.find_element(:tag_name => "body").text.include?("We reserve the right to amend this"),"The Terms of Use Page loads")
    @driver.navigate.back
    @driver.find_element(:link, "Contact Us").click
    assert(@driver.find_element(:tag_name => "body").text.include?("What do you need help with"),"The Contact US page loads")
    @driver.navigate.back

    #Facebook Login
    @driver.find_element(:xpath, "//img[@alt='Facebook']").click
    sleep 2
    handles = @driver.window_handles
    @driver.switch_to.window(handles[1])
    @driver.find_element(:name, "email").click
    @driver.find_element(:name, "email").clear
    @driver.find_element(:name, "email").send_keys "facebookdontcare@gmail.com"
    @driver.find_element(:name, "pass").clear
    @driver.find_element(:name, "pass").send_keys "jibejibe1124"
    @driver.find_element(:name, "login").click
    sleep 2
    handles = @driver.window_handles
    @driver.switch_to.window(handles[0])
=begin
    #Signing out from Facebook
    @driver.find_element(:id, "btn_menu").click
    @driver.find_element(:link, "Sign Out").click
    assert(@driver.find_element(:tag_name => "body").text.include?("Sign in with"),"Facebook User can successfully log out")

    #Linkedin Login
    @driver.find_element(:xpath, "//img[@alt='Linkedin']").click
    sleep 2
    @driver.find_element(:id, "action-no-app").click
    @driver.find_element(:id, "session_key-oauthAuthorizeForm").clear
    @driver.find_element(:id, "session_key-oauthAuthorizeForm").send_keys "jibeqa@gmail.com"
    @driver.find_element(:id, "session_password-oauthAuthorizeForm").clear
    @driver.find_element(:id, "session_password-oauthAuthorizeForm").send_keys "jibejibe1124"
    @driver.find_element(:name, "authorize").click
=end
    #Navigate to the Stats page
    @driver.find_element(:id, "btn_menu").click
    @driver.find_element(:link, "Stats").click
    assert(@driver.find_element(:tag_name => "body").text.include?("Popular Job Titles"),"The Stats page loads")

    #Navigate to the Dashboard
    @driver.find_element(:id, "btn_menu").click
    @driver.find_element(:link, "Dashboard").click
    assert(@driver.find_element(:tag_name => "body").text.include?("Resumes / Cover Letters"),"The Stats page loads")
    assert(@driver.find_element(:tag_name => "body").text.include?("Saved Jobs"),"The Stats page loads")
    assert(@driver.find_element(:tag_name => "body").text.include?("Applications"),"The Stats page loads")
    assert(@driver.find_element(:tag_name => "body").text.include?("Linked Accounts"),"The Stats page loads")
    
    #Navigate to the jobs listing page
    @driver.find_element(:id, "btn_menu").click
    @driver.find_element(:link, "Jobs").click

    #Applying to a job
    @driver.get "http://www.jibe.com/jobs/groupon-live-account-representative-groupon-chicago-il--1/job_applications/new"
    @driver.find_element(:id, "job_application_resume_id").find_element(:css,"option[value='459369']").click #167986 for jibeqa@gmail.com
    @driver.find_element(:link,"Continue").click
    assert(@driver.find_element(:tag_name => "body").text.include?("Connections"),"The Connections page loads")
    @driver.find_element(:link,"Continue").click
    assert(@driver.find_element(:tag_name => "body").text.include?("Questions"),"The Questions page loads")
    @driver.find_element(:link,"Continue").click
    sleep 5
    assert(@driver.find_element(:tag_name => "body").text.include?("Review Your Application"),"The Final Submit - Review application loads")
    @driver.find_element(:id, "btn_menu").click
    @driver.find_element(:link, "Jobs").click

    #Signing out
    @driver.find_element(:id, "btn_menu").click
    @driver.find_element(:link, "Sign Out").click
    assert(@driver.find_element(:tag_name => "body").text.include?("Sign in with"),"Linkedin User can successfully log out")
  end
end
