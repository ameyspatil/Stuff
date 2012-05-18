#!/usr/bin/env ruby
require 'rubygems'
gem 'test-unit'
require "test/unit"
require 'test/unit/ui/console/testrunner'
require "selenium-webdriver"
require "httparty"
require "setup"
#require 'rake'
#require 'ci/reporter/rake/test_unit'
#require 'ci/reporter/rake/test_unit_loader'

$args = ARGV.dup

class Delete < Test::Unit::TestCase
extend Test::Unit::Assertions
  def setup 
    if Setup.server == 'remote'
      @driver = Selenium::WebDriver.for(:remote, :url => "http://windoze2.jibe.com:5555/wd/hub", :desired_capabilities => Setup.browser)
    elsif Setup.server == 'local'
      @driver = Selenium::WebDriver.for Setup.browser
    else
      STDERR.puts "unknown server type "
      exit! 1
    end
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
    @driver.get Setup.env
    @wait = Selenium::WebDriver::Wait.new(:timeout => 30)
  end
  
  def teardown
    @driver.quit
    assert_equal [], @verification_errors
  end
  
  def test_delete
    @driver.find_element(:id, "login").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("error kept you from logging"),"The login validation works"}
    @driver.find_element(:id, "user_session_email").clear
    @driver.find_element(:id, "user_session_email").send_keys "resumes@jibe.com"
    @driver.find_element(:id, "user_session_password").clear
    @driver.find_element(:id, "user_session_password").send_keys "jibejibe1124"
    @driver.find_element(:id, "login").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("Posted Jobs"),"User can successfully log in"}
    
    @driver.find_element(:link, "2").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("Impressions"),"Pagination works to display page 2"}
    
    @driver.find_element(:link, "Next ›").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("Impressions"),"Pagination works to display \"next\" page"}
    
    @driver.find_element(:link, "Last »").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("Impressions"),"Pagination works to display \"last\" page"}
    
    @driver.find_element(:id, "title").clear
    @driver.find_element(:id, "title").send_keys "Driver"
    @driver.find_element(:css, "input.btn-info").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("DRIVERS"),"Search works to display jobs with Driver as text"}
    
    @driver.find_element(:link, "Job Boards").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("Craigslist"),"Job board page opens up"}
    
    @driver.find_element(:link, "Stats").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("Total Free Posts"),"Stats Page loads"}
    
    @driver.find_element(:link, "Users").click
    @driver.find_element(:link, "All Users").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("resumes@jibe.com"),"All Users page loads "}
    
    @driver.find_element(:link, "Users").click
    @driver.find_element(:link, "Add User").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("New user"),"Add User page loads"}
    
    @driver.find_element(:link, "Groups").click
    @driver.find_element(:link, "Add Group").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("Create new group"),"All Group page is displayed"}
    
    @driver.find_element(:xpath, "//div[@id='user-info']/div/a[2]").click
    @driver.find_element(:link, "Logout").click
    verify { assert @driver.find_element(:tag_name => "body").text.include?("Please log in"),"User Successfully logs out"}
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
