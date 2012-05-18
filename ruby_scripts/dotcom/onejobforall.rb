#!/usr/bin/env ruby

require 'rubygems'
gem 'test-unit'
require "test/unit"
require 'test/unit/ui/console/testrunner'

require "selenium-webdriver"
require "httparty"
require "json"
require 'rake'
require 'ci/reporter/rake/test_unit'
require 'ci/reporter/rake/test_unit_loader'

$args = ARGV.dup

class Services
  include HTTParty
  format :json
  def self.slug_by_id(id)
    response = get "http://jobservice1.jibe.com:8080/jobs/all.json?company=#{id}&status=active"
    if response.size == 0
        0
    else
        response.parsed_response[0]['slug']
    end      
  end
  def self.questions_by_slug(slug)
    response = get "http://jobservice1.jibe.com:8080/jobs/slug/#{slug}/user/52416373/questions.json" 
    response
  end
  def self.get_company_id(offset)
    response = get "http://companyservice1.jibe.com:8080/companies/all.json?offset=#{offset}&limit=25"
    response
  end  
end

class RegressionTesting < Test::Unit::TestCase
    extend Test::Unit::Assertions

    def self.startup
        @@driver = Selenium::WebDriver.for(:remote, :url => "http://windoze2.jibe.com:5555/wd/hub", :desired_capabilities => :chrome)
        @@driver.manage.timeouts.implicit_wait = 30
        @@verification_errors = []
        @@driver.get "http://www.jibe.com/"
        @@wait = Selenium::WebDriver::Wait.new(:timeout => 30)
        @@wait_less = Selenium::WebDriver::Wait.new(:timeout => 15)
        @@driver.find_element(:link, "LI").click
        @@driver.find_element(:id, "session_key-oauthAuthorizeForm").clear
        @@driver.find_element(:id, "session_key-oauthAuthorizeForm").send_keys "jibeqa@gmail.com"
        @@driver.find_element(:id, "session_password-oauthAuthorizeForm").clear
        @@driver.find_element(:id, "session_password-oauthAuthorizeForm").send_keys "jibejibe1124"
        @@driver.find_element(:name, "authorize").click
        @@wait.until {@@driver.find_element(:tag_name => "body").text.include?("Tom Gray")}
    end

    def setup
    end
   
    def profile_edit (company_id)
        @@wait.until {@@driver.find_element(:id, "application_data_email")}
        @@driver.find_element(:id, "application_data_email").clear
        @@driver.find_element(:id, "application_data_email").send_keys "jibeqa@gmail.com"
        @@driver.find_element(:id, "application_data_street_address").clear
        @@driver.find_element(:id, "application_data_street_address").send_keys "Test Street"
        @@driver.find_element(:id, "application_data_city").clear
        @@driver.find_element(:id, "application_data_city").send_keys "Test City"
        Selenium::WebDriver::Support::Select.new(@@driver.find_element(:id, "application_data_resume_id")).select_by(:text, "Sample_Resume.pdf")
        Selenium::WebDriver::Support::Select.new(@@driver.find_element(:id, "application_data_province_id")).select_by(:text, "New York")
        if company_id == 30
                if @@driver.execute_script("return document.querySelectorAll(\'input#application_data_job_seeker_information_notice[type=checkbox]\')[0].checked")
                #if !@driver.execute_script("return document.getElementById('application_data_job_seeker_information_notice').checked")
                else
                        @@driver.find_element(:xpath, "(//input[@id='application_data_job_seeker_information_notice'])[2]").click
                end    
        end   
        @@driver.find_element(:link, "Continue").click
    end
    
    def questions (company_id, slug)
        @@wait.until {@@driver.find_element(:tag_name => "body").text.include?("basic employer questions") || @@driver.find_element(:tag_name => "body").text.include?("There are no questions for this job")}
        questions = Services.questions_by_slug(slug)
        question_number = 0
        questions[0]['questions'].each do |i|
            if i =~ /id=\"(.*?)\"/
                id =$1    
                question_number = question_number + 1
                if  i =~ /type=\"text\"/i
                    #puts "the text box id for #{question_number} is #{id}\n"
                    if i =~ /value=\"\"/
                        if i =~ /date/i
                            @@driver.find_element(:id, "#{id}").clear
                            @@driver.find_element(:id, "#{id}").send_keys "12/12/2012"
                        else    
                            @@driver.find_element(:id, "#{id}").clear
                            @@driver.find_element(:id, "#{id}").send_keys "1000"
                        end
                    end
                elsif i =~ /checkbox/i
                    #puts "#{question_number} is a checkbox with full question #{i}"
                    if !@@driver.execute_script("return document.getElementById('#{id}').checked")
                        #puts "inside checkbox for #{id}"
                        @@driver.find_element(:id, "#{id}").click
                    end    
                elsif i =~ /textarea/i
                    #puts "the textarea id for #{question_number} is #{id}\n"
                    if i =~ /date/i
                        @@driver.find_element(:id, "#{id}").clear
                        @@driver.find_element(:id, "#{id}").send_keys "12/12/2012"
                    else    
                        @@driver.find_element(:id, "#{id}").clear
                        @@driver.find_element(:id, "#{id}").send_keys "1000 - text area"
                    end 
                elsif i =~ /<\/option>/i
                    #puts "the options id for #{question_number} is #{id}\n"
                    if i =~ /selected/i
                    else    
                        if i =~ /id=\"(.*?)\".*>(.*?)<\/option>/
                            label =$2
                            Selenium::WebDriver::Support::Select.new(@@driver.find_element(:id, "#{id}")).select_by(:text, "#{label}")
                        end
                    end        
                elsif i =~ /type=\"radio\"/i
                    #puts "the radio id for #{question_number} is #{id}\n"
                    @@driver.find_element(:id, "#{id}").click
                else
                    #puts "\n\n\n\n\n\nthis is the #{i}\n\n\n\n\n"
                    verify{ assert 'false',"Question:#{question_number} did not get detected with an id:#{id}"}
                end
            else
                #puts "\n\n\n\n\n\nthis is the #{i}\n\n\n\n\n"
                verify{ assert 'false',"Question:#{question_number} does not have an id"}
            end            
        end
        @@driver.find_element(:link, "Continue").click
        
    end

    def connections(company_id,slug)
        begin
            @@wait.until {@@driver.find_element(:tag_name => "body").text.include?("Select connections to include")}
        rescue
            @@driver.switch_to.alert.accept
            @@driver.save_screenshot("#{company_id}.png")
            assert_true( "false", "The Company: #{company_id} for #{slug} did not get all questions answered")
            #verify { assert @@driver.find_element(:tag_name => "body").text.include?("Does not matter"), "The Company: #{company_id} for #{slug} did not get all questions answered"}
            return 5
        end    
        @@wait.until {@@driver.find_element(:link, "Continue")}
        @@driver.find_element(:link, "Continue").click 
    end

    def final_review
        @@wait.until {@@driver.find_element(:xpath,"//div[@id='application_review']/dl/dt[1]/a")}
        @@driver.find_element(:xpath,"//div[@id='application_review']/dl/dt[1]/a").click # Click on Edit for profile
    end

    offset_count=0;
    while (offset_count < 174)
        companies = Services.get_company_id(offset_count)
                companies.each do |i|
                        define_method :"test_#{i['company_name']}_#{i['id']}_jobapplication" do
                            puts "Testing Company:\"" + i['company_name'] + "\""
                            slug = Services.slug_by_id(i['id'])
                            if slug != 0
                                @@driver.get "http://www.jibe.com/jobs/#{slug}"
                                begin
                                    @@wait.until {@@driver.find_element(:link, "Apply")}
                                rescue
                                    if @@driver.find_element(:tag_name => "body").text.include?("Sorry, this job is not active anymore.")
                                        assert "true" , "The job:#{slug} is not active"
                                    elsif @@driver.find_element(:tag_name => "body").text.include?("Applied")
                                        assert "true" , "The user has already applied to #{slug}"
                                    else 
                                        verify { assert "false", "For company id:#{i['id']} the #{slug} had some issue"}
                                        @@driver.get "http://www.jibe.com/jobs/"
                                    end    
                                    next
                                end        
                                    
                                @@driver.find_element(:link, "Apply").click
                                    
                                if @@driver.find_element(:tag_name => "body").text.include?("Upload a resume")
                                    profile_edit(i['id'])
                                    questions(i['id'], slug)
                                    if connections(i['id'], slug) == 5
                                        next
                                    end    
                                elsif @@driver.find_element(:tag_name => "body").text.include?("basic employer questions") || @@driver.find_element(:tag_name => "body").text.include?("There are no questions for this job")
                                    questions(i['id'], slug)
                                    if connections(i['id'], slug) == 5
                                        next
                                    end    
                                elsif @@driver.find_element(:tag_name => "body").text.include?("Select connections to include")
                                    connections(i['id'], slug)
                                    final_review()
                                    profile_edit(i['id'])
                                    questions(i['id'], slug)
                                    if connections(i['id'], slug) == 5
                                        next
                                    end    
                                elsif  @@driver.find_element(:tag_name => "body").text.include?("Not done yet")
                                    final_review()
                                    profile_edit(i['id'])
                                    questions(i['id'], slug)
                                    if connections(i['id'], slug) == 5
                                        next
                                    end    
                                elsif  @@driver.find_element(:tag_name => "body").text.include?("You have exited JIBE")
                                    verify {assert "false", "This is an iframe job" }
                                    next
                                else    
                                    assert "false","Something went terrible wrong"
                                end
                                
                                sleep 2
                                verify { assert @@driver.find_element(:xpath,"//div[@id='application_review']/dl/dt[1]/a"),"The Final Submit - Review application loads FAILS HERE!"}
                                verify { assert @@driver.find_element(:xpath, "//div[@id='review']/div[2]/a[1]"),"The Final Submit xpath is here"}
                                #@@wait.until { @@driver.find_element(:css, "#review > div.application-actions > a.btn_cancel").displayed?}
                                #@@driver.find_element(:css, "#review > div.application-actions > a.btn_cancel").click
                                @@wait.until { @@driver.find_element(:xpath, "//div[@id='review']/div[2]/a[1]").displayed?}
                                @@driver.find_element(:xpath, "//div[@id='review']/div[2]/a[1]").click
                            else
                                assert "true", "No jobs for this company"
                            end    
                        end
                end
        offset_count=offset_count + 25
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
        #assert_equal [], @verification_errors
    end

    def self.shutdown
        extend Test::Unit::Assertions
        #@@driver.find_element(:xpath, "//div[@id='review']/div[2]/a[1]").click   # the xpath alternative for Cancel on Final Review Page
        puts @@verification_errors
        @@driver.quit
        assert_equal [], @@verification_errors
    end 


end

