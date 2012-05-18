require 'rubygems'
gem 'test-unit'
require "selenium-webdriver"
require 'rake'
require 'ci/reporter/rake/test_unit'
require 'ci/reporter/rake/test_unit_loader'
require "test/unit"

class Sendrequest < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for(:remote, :url => "http://windoze2.jibe.com:5555/wd/hub", :desired_capabilities => :chrome)
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end


  def test_givereferralcheck
    # Start Testing
    @driver.get "http://careers.accenture.com/us-en/jobs/Pages/jobdetails.aspx?lang=en&job=00142752"
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
    wait.until { @driver.find_element(:tag_name => "body").text.include?("Production Support Analyst")}
    @driver.find_element(:id,"GetReferredJobApplyButton1").click
    sleep 5
    frameid = @driver.execute_script("return document.getElementById('get-referred').childNodes[0].getAttribute('name')")
    @driver.switch_to.frame "#{frameid}"
    assert(@driver.find_element(:tag_name => "body").text.include?("Get Referred"),"The Page loads")
    assert(@driver.find_element(:tag_name => "body").text.include?("Please enter your full name and e-mail address below"),"Text check on step 1")
    assert(@driver.find_element(:tag_name => "body").text.include?("Full Name"),"Text check on step 1")
    @driver.find_element(:id, "name").send_keys "Sham"
    @driver.find_element(:id, "email").clear
    @driver.find_element(:id, "email").send_keys "shampatel113@gmail.com"
    

    #To upload a file on IE - Running an AutoIT script
    #%x{ C:\\Users\\Amey\\Desktop\\uploadfile.exe }
    @driver.find_element(:id, "resume").send_keys "C:\\Users\\Amey\\Desktop\\Sample_Resume.pdf"    
    @driver.find_element(:id, "register-applicant").click
    sleep 2
    
    # Testing the email aspect
    sleep 5
    @driver.find_element(:xpath, "//section[@id='search-network']/div[1]/a[3]").click
    @driver.find_element(:id, "referrerName").clear
    @driver.find_element(:id, "referrerName").send_keys "jibetester"
    @driver.find_element(:id, "referrerEmail").clear
    @driver.find_element(:id, "referrerEmail").send_keys "garbage@jibe.com"
    assert_match("The link above", @driver.execute_script("return document.getElementById('referrerMessage').value"), "The email id on step 1 is still populated after a back on step2")
    #@driver.find_element(:xpath, "//section[@id='compose-request']/div[2]/form/div[4]/div/a").click
    url =@driver.execute_script("return document.getElementById('referrerLink').value")
    @driver.find_element(:xpath, "//section[@id='compose-request']/div[2]/form/div[4]/div/button").click
    @driver.switch_to.default_content
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)
    wait.until { @driver.find_element(:tag_name => "body").text.include?("Production Support Analyst")}
    sleep 10
    @driver.get "#{url}"
    wait.until {@driver.find_element(:tag_name => "body").text.include?("Employee referral request")}
    wait.until {@driver.find_element(:tag_name => "body").text.include?("jibetester")}
    wait.until {@driver.find_element(:tag_name => "body").text.include?("Sham")}
    wait.until {@driver.find_element(:tag_name => "body").text.include?("Production Support Analyst")}
    @driver.navigate.refresh
    wait.until {@driver.find_element(:tag_name => "body").text.include?("Employee referral request")}
    @driver.navigate.refresh
    wait.until {@driver.find_element(:tag_name => "body").text.include?("Employee referral request")}
    @driver.navigate.refresh
    wait.until {@driver.find_element(:tag_name => "body").text.include?("Employee referral request")}
    @driver.navigate.refresh
    wait.until {@driver.find_element(:tag_name => "body").text.include?("Employee referral request")}
    @driver.find_element(:link => "Next").click
    sleep 2
    assert(@driver.find_element(:tag_name => "body").text.include?("Enterprise"),"The next page of give referral opens up") 

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
