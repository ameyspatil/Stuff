#!/usr/bin/env ruby
require 'rubygems'
gem 'test-unit'
require "selenium-webdriver"
require 'rake'
require 'ci/reporter/rake/test_unit'
require 'ci/reporter/rake/test_unit_loader'
require "test/unit"

class Ruby11 < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for(:remote, :url => "http://windoze2.jibe.com:5555/wd/hub", :desired_capabilities => :chrome)
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
    @wait = Selenium::WebDriver::Wait.new(:timeout => 20)
    @driver.get "http://accenture.jibe.com/?job_id=0074865&job_name=Front-end%20Engineer&origin=http://careers.accenture.com"
    @wait.until { @driver.find_element(:id, "register-applicant")}
    @driver.find_element(:id, "name").click
    @driver.find_element(:id, "name").clear
    @driver.find_element(:id, "name").send_keys "Sham"
    @driver.find_element(:id, "email").clear
    @driver.find_element(:id, "email").send_keys "shampatel113@gmail.com"
    #To upload a file on IE - Running an AutoIT script
    #%x{ C:\\Users\\Amey\\Desktop\\uploadfile.exe }
    @driver.find_element(:id, "resume").send_keys "C:\\Users\\Amey\\Desktop\\Sample_Resume.pdf"    
    @driver.find_element(:id, "register-applicant").click
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end


  def test_ruby11
    # Start Testing
    @driver.get "http://accenture.jibe.com/?job_id=0074865&job_name=Front-end%20Engineer&origin=http://careers.accenture.com"
    assert(@driver.find_element(:tag_name => "body").text.include?("Get Referred"),"The Page loads")
    assert(@driver.find_element(:tag_name => "body").text.include?("Please enter your full name and e-mail address below"),"Text check on step 1")
    assert(@driver.find_element(:tag_name => "body").text.include?("Full Name"),"Text check on step 1")
    @driver.find_element(:id, "register-applicant").click
    assert(@driver.find_element(:tag_name => "body").text.include?("Your name is required"),"The text box validators work on step 1")
    assert(@driver.find_element(:tag_name => "body").text.include?("A valid e-mail address is required"),"The text box validators work on step 1")
    @driver.find_element(:id, "name").clear
    @driver.find_element(:id, "name").send_keys "Sham"
    @driver.find_element(:id, "email").clear
    @driver.find_element(:id, "email").send_keys "shampatel113@gmail.com"
    

    #To upload a file on IE - Running an AutoIT script
    #%x{ C:\\Users\\Amey\\Desktop\\uploadfile.exe }
    @driver.find_element(:id, "resume").send_keys "C:\\Users\\Amey\\Desktop\\Sample_Resume.pdf"    
    @driver.find_element(:id, "register-applicant").click
    sleep 2
    
    #Testing the back button on Step 2
    @driver.find_element(:xpath, "//section[@id='search-network']/div[5]/a").click
    assert_match("shampatel113@gmail.com", @driver.execute_script("return document.getElementById('email').value"), "The email id on step 1 is still populated after a back on step2")
    @driver.find_element(:id, "register-applicant").click


    # Testing the email aspect
   
    @driver.find_element(:link, "Or enter an e-mail address").click
    @driver.find_element(:id, "referrerName").clear
    @driver.find_element(:id, "referrerName").send_keys "jibetester"
    @driver.find_element(:id, "referrerEmail").clear
    @driver.find_element(:id, "referrerEmail").send_keys "jibeqa@gmail.com"
    assert_match("The link above", @driver.execute_script("return document.getElementById('referrerMessage').value"), "The email id on step 1 is still populated after a back on step2")
    @driver.find_element(:xpath, "//section[@id='compose-request']/div[2]/form/div[4]/div/a").click
  end    

  def test_step2  
    #Testing Linkedin
    @driver.find_element(:link, "LinkedIn").click
    sleep 2
    handles = @driver.window_handles
    #puts handles
    @driver.switch_to.window(handles[1])    
    @driver.find_element(:id, "session_key-oauthAuthorizeForm").clear
    @driver.find_element(:id, "session_key-oauthAuthorizeForm").send_keys "shampatel113@gmail.com"
    @driver.find_element(:id, "session_password-oauthAuthorizeForm").clear
    @driver.find_element(:id, "session_password-oauthAuthorizeForm").send_keys "jibejibe1124"
    @driver.find_element(:name, "authorize").click
    
    handles = @driver.window_handles
    @driver.switch_to.window(handles[0])
=begin    
    # Opening Linkedin Message
    sleep 2
    assert(@driver.find_element(:tag_name => "body").text.include?("Radhe"),"The Linkedin connections load")
    @driver.find_element(:xpath, "//section[@id='search-network']/div[3]/div/ul/li/a").click
    body = @driver.execute_script("return document.getElementById('message').value")
    if body =~  /.*https(.*)/
        url = $1
    end
    url = "https" + url
    assert_match("interested",body , "Linkedin message loads")
    @driver.find_element(:xpath, "//section[@id='compose-request']/div/form/div[2]/div/a").click
=end    


    # Testing Facebook
    @driver.find_element(:link, "Facebook").click
    @wait.until {@driver.window_handles.size > 1}
    handles = @driver.window_handles
    @driver.switch_to.window(handles[1])
    @wait.until { @driver.find_element(:tag_name => "body").text.include?("Email")}
    @driver.find_element(:id, "email").click
    @driver.find_element(:id, "email").clear
    @driver.find_element(:id, "email").send_keys "shampatel113@gmail.com"
    @driver.find_element(:id, "pass").clear
    @driver.find_element(:id, "pass").send_keys "jibejibe1124"
    @driver.find_element(:name, "login").click
    @wait.until {@driver.window_handles.size < 2}
    handles = @driver.window_handles
    @driver.switch_to.window(handles[0])
    
    #Opening Facebook message
    @wait.until { @driver.find_element(:xpath, "//section[@id='search-network']/div[3]/div/ul/li[2]/a") }
    @driver.find_element(:xpath, "//section[@id='search-network']/div[3]/div/ul/li[2]/a").click
    sleep 1
    iframename = @driver.execute_script("return document.getElementById('fb-root').getElementsByTagName('iframe')[0].getAttribute('name')")
    sleep 1
    @driver.switch_to.frame iframename
    assert(@driver.action.send_keys("hey").perform ,"The Hey has been typed")
    @driver.find_element(:name, "cancel").click

    #Testing the give referral   
    @driver.get url
    assert(@driver.find_element(:tag_name => "body").text.include?("Employee referral request"),"The give referral page opens up")
    assert(@driver.find_element(:tag_name => "body").text.include?("Radhe"),"The to field is populated correctly")
    assert(@driver.find_element(:tag_name => "body").text.include?("Sham"),"The from field loads correctly")
    assert(@driver.find_element(:tag_name => "body").text.include?("Front-end Engineer"),"The job title displays correctly")
    @driver.find_element(:link => "Next").click
    sleep 2
    assert(@driver.find_element(:tag_name => "body").text.include?("Enterprise"),"The next page of give referral opens up")
    #@driver.back
    #sleep 2
    #assert(@driver.find_element(:tag_name => "body").text.include?("Employee referral request"),"The give referral page opens up")
    #@driver.find_element(:link => "Click here to download resume").click

  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
end
