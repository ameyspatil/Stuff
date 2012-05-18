#!/usr/bin/env ruby

require 'rubygems'
gem 'test-unit'
require "test/unit"
require 'test/unit/ui/console/testrunner'
require "selenium-webdriver"

require 'rake'
require 'ci/reporter/rake/test_unit'
require 'ci/reporter/rake/test_unit_loader'

$args = ARGV.dup

class RegressionTesting < Test::Unit::TestCase

    def server()  ($args[0] || 'remote').to_sym; end
    def browser() ($args[1] || 'firefox').to_sym; end

    def setup
        @driver = case server
            when :remote then
                caps = {  
                          :browserName => browser,  
                          :platform => "LINUX"  
                        }
                Selenium::WebDriver.for(:remote, :url => "http://windoze2.jibe.com:5552/wd/hub", :desired_capabilities => browser)
            when :local then
                Selenium::WebDriver.for browser
            else
                STDERR.puts "unknown server type '#{server}'"
                exit! 1
        end
        @driver.manage.timeouts.implicit_wait = 30
        @verification_errors = []
        @driver.manage.window.resize_to(1000, 1000)
        @wait = Selenium::WebDriver::Wait.new(:timeout => 30)
    end

    def teardown
        @driver.quit
        assert_equal [], @verification_errors
    end
     
    def test_facebooklogin
        #Test Firefox Login
        @driver.get "http://www.jibe.com/"
        begin
            assert @driver.find_element(:tag_name => "body").text.include?("Harness the power of your"),"Jibe Home page opens successfully"
        rescue
            @driver.save_screenshot("homepageFB.png")  
            verify { assert @driver.find_element(:tag_name => "body").text.include?("Harness the power of your"),"Facebook User can successfully log out"}
        end 
        @driver.find_element(:link, "FB").click
        begin 
            @wait.until {@driver.window_handles.size > 1}
        rescue
            @driver.save_screenshot("fbpopupdisplayed.png")
            verify {assert_match false,true,"The Facebook popup does not open"}  
        end        
        handles = @driver.window_handles
        @driver.switch_to.window(handles[1])
        begin
            assert @driver.find_element(:name, "email")
        rescue
            @driver.save_screenshot("fbpauthscreen.png")
            verify {assert_match false,true, "The facebook popup is blank"}
        end
        @driver.find_element(:name, "email").click
        @driver.find_element(:name, "email").clear
        @driver.find_element(:name, "email").send_keys "facebookdontcare@gmail.com"
        @driver.find_element(:name, "pass").clear
        @driver.find_element(:name, "pass").send_keys "jibejibe1124"
        @driver.find_element(:name, "login").click
        sleep 1
        @wait.until {@driver.window_handles.size < 2}
        handles = @driver.window_handles
        @driver.switch_to.window(handles[0])
        begin
                assert @driver.find_element(:tag_name => "body").text.include?("Stacey Lin"),"The Facebook user successfully logs in"
        rescue
                @driver.save_screenshot("fblogincheck.png")  
                verify {assert_match false,true,"The Facebook user successfully logs in"}
        end
        @driver.find_element(:css, "span").click
        @driver.find_element(:link, "Logout").click
        begin
                assert @driver.find_element(:tag_name => "body").text.include?("Harness the power of your"),"Facebook User can successfully log out"
        rescue
                @driver.save_screenshot("fblogout.png")  
                verify {assert_match false,true,"Facebook User can successfully log out"}
        end
    end

    def test_linkedinlogin
        #Test Linkedin Login
        @driver.get "http://www.jibe.com/"
        begin
            assert @driver.find_element(:tag_name => "body").text.include?("Harness the power of your"),"Jibe Home page opens successfully"
        rescue
            @driver.save_screenshot("homepageLI.png")  
            verify {assert_match false,true,"Facebook User can successfully log out"}
        end        
        @driver.find_element(:link, "LI").click
        begin
            assert @driver.find_element(:id, "session_key-oauthAuthorizeForm")
        rescue
            @driver.save_screenshot("LIauthscreen.png")  
            verify {assert_match false,true,"Linkedin Login screen is displayed"}
        end    
        @driver.find_element(:id, "session_key-oauthAuthorizeForm").clear
        @driver.find_element(:id, "session_key-oauthAuthorizeForm").send_keys "jibeqa@gmail.com"
        @driver.find_element(:id, "session_password-oauthAuthorizeForm").clear
        @driver.find_element(:id, "session_password-oauthAuthorizeForm").send_keys "jibejibe1124"
        @driver.find_element(:name, "authorize").click
        begin
                @wait.until { @driver.find_element(:tag_name => "body").text.include?("Tom Gray") || @driver.find_element(:tag_name => "body").text.include?("Thomas Grayus")}
        rescue
                @driver.save_screenshot("linkedinLogin.png")
                verify {assert_match false,true,"The Linkedin user successfully logs in"}  
        end
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

