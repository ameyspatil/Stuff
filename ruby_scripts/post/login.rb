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
    @wait.until { @driver.find_element(:id, "user_session_email")}
    @driver.find_element(:id, "user_session_email").clear
    @driver.find_element(:id, "user_session_email").send_keys "macys@jibe.com"
    @driver.find_element(:id, "user_session_password").clear
    @driver.find_element(:id, "user_session_password").send_keys "jibejibe1124"
    @driver.find_element(:id, "login").click
    @wait.until {@driver.find_element(:tag_name => "body").text.include?("Sorry, we couldn't find a job")}
    verify { assert @driver.find_element(:tag_name => "body").text.include?("Sorry, we couldn't find a job"), "Login Works for Macys"}
    @driver.find_element(:xpath, "//div[@id='user-info']/div/a[2]").click
    @driver.find_element(:link, "Logout").click
    @wait.until {@driver.find_element(:id, "user_session_email")}
    @driver.find_element(:id, "user_session_email").clear
    @driver.find_element(:id, "user_session_email").send_keys "resumes@jibe.com"
    @driver.find_element(:id, "user_session_password").clear
    @driver.find_element(:id, "user_session_password").send_keys "jibejibe1124"
    @driver.find_element(:id, "login").click
    @wait.until {@driver.find_element(:tag_name => "body").text.include?("Posted Jobs")}
    verify { assert @driver.find_element(:tag_name => "body").text.include?("Posted Jobs"), "Login works for Bayard"}
    @driver.find_element(:xpath, "//div[@id='user-info']/div/a[2]/b").click
    @driver.find_element(:link, "Logout").click
    @wait.until {@driver.find_element(:id, "user_session_email")}
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
