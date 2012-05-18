#!/usr/bin/env ruby
require 'rubygems'
gem 'test-unit'
require "selenium-webdriver"
require 'rake'
require 'ci/reporter/rake/test_unit'
require 'ci/reporter/rake/test_unit_loader'
require "test/unit"
require 'setup'

$args = ARGV.dup

class RegressionTesting < Test::Unit::TestCase
 extend Test::Unit::Assertions

    def self.startup
        if Setup.server == 'remote'
          @@driver = Selenium::WebDriver.for(:remote, :url => "http://windoze2.jibe.com:5555/wd/hub", :desired_capabilities => Setup.browser)
        elsif Setup.server == 'local'
          @@driver = Selenium::WebDriver.for Setup.browser
        else
          STDERR.puts "unknown server type "
          exit! 1
        end
        @@driver.manage.timeouts.implicit_wait = 30
        @@verification_errors = []
        @@driver.get Setup.initial_values + $job_url
        @@wait = Selenium::WebDriver::Wait.new(:timeout => 30)
    end

    def setup
    end    

    def test_1test1
        puts  "sleeping for 5 now"
        sleep 2
    end    
   
    def test_profile
        #@@wait.until {@@driver.find_element(:id, "#{$job_title}")}
        assert(@@driver.find_element(:tag_name => "body").text.include?("Get Referred"),"The Page loads")
        assert(@@driver.find_element(:tag_name => "body").text.include?("Please enter your full name and e-mail address below"),"Text check on step 1")
        assert(@@driver.find_element(:tag_name => "body").text.include?("Full Name"),"Text check on step 1")
        @@driver.find_element(:id, "register-applicant").click
        assert(@@driver.find_element(:tag_name => "body").text.include?("Your name is required"),"The text box validators work on step 1")
        assert(@@driver.find_element(:tag_name => "body").text.include?("A valid e-mail address is required"),"The text box validators work on step 1")
        @@driver.find_element(:id, "name").clear
        @@driver.find_element(:id, "name").send_keys "Sham"
        @@driver.find_element(:id, "email").clear
        @@driver.find_element(:id, "email").send_keys "#{$email}"
        @@driver.find_element(:id, "resume").send_keys "C:\\Users\\Amey\\Desktop\\Sample_Resume.pdf"    
        @@driver.find_element(:id, "register-applicant").click
        @@wait.until {@@driver.find_element(:id, "#{$job_title}")}
    end
    


    def element_present?(how, what)
        @@driver.find_element(how, what)
        true
    rescue Selenium::WebDriver::Error::NoSuchElementError
        false
    end

    def verify(&blk)
        yield
    rescue Test::Unit::AssertionFailedError => ex
        @@verification_errors << ex
    end

    def teardown
    end

    def self.shutdown
        extend Test::Unit::Assertions
        puts @@verification_errors
        @@driver.quit
        assert_equal [], @@verification_errors
    end

end

