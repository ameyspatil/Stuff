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
    response = get "http://jobservice1.jibe.com:8080/jobs/all.json?company=#{id}"
    response.parsed_response[0]['slug']
  end
  def self.questions_by_slug(slug)
    response = get "http://jobservice1.jibe.com:8080/jobs/slug/#{slug}/user/52416373/questions.json" 
    response
  end  
end

class RegressionTesting < Test::Unit::TestCase

    def server()  ($args[0] || 'remote').to_sym; end
    def browser() ($args[1] || 'firefox').to_sym; end

    def setup
        @driver = case server
            when :remote then
                caps = {  
                          :browserName => browser,  
                          #:platform => "LINUX"  
                        }
                Selenium::WebDriver.for(:remote, :url => "http://windoze2.jibe.com:5555/wd/hub", :desired_capabilities => browser)
            when :local then
                Selenium::WebDriver.for browser
            else
                STDERR.puts "unknown server type '#{server}'"
                exit! 1
        end

        @driver.manage.timeouts.implicit_wait = 30
        @verification_errors = []
        @driver.get "http://www.jibe.com/"
        @driver.manage.window.resize_to(300, 700)

        @wait = Selenium::WebDriver::Wait.new(:timeout => 30)
    end

    def teardown
        @driver.quit
        assert_equal [], @verification_errors
    end

    def login
        @driver.find_element(:link, "LI").click
        #wait = Selenium::WebDriver::Wait.new(:timeout => 20)
        #wait.until {@driver.window_handles.size > 1}
        #handles = @driver.window_handles
        #@driver.switch_to.window(handles[1])
        @driver.find_element(:id, "session_key-oauthAuthorizeForm").clear
        @driver.find_element(:id, "session_key-oauthAuthorizeForm").send_keys "jibeqa@gmail.com"
        @driver.find_element(:id, "session_password-oauthAuthorizeForm").clear
        @driver.find_element(:id, "session_password-oauthAuthorizeForm").send_keys "jibejibe1124"
        @driver.find_element(:name, "authorize").click 
    end

    def test_pagination
        @wait.until { @driver.find_element(:name, "q")}
        @driver.find_element(:name, "q").clear
        @driver.find_element(:name, "q").send_keys "Amazon"
        @driver.find_element(:name, "q").send_keys [:return]
        sleep 0.5
        html_source = @driver.page_source
        urls = html_source.scan(/href=\"(.*?)\" class/i)
        @driver.find_element(:link, "2").click
        sleep 0.5
        html_source = @driver.page_source
        urls2 = html_source.scan(/href=\"(.*?)\" class/i)
        if urls==urls2
            verify { assert "false","Pagination after search form logged out state did not work"}
        else
            verify { assert "true","Pagination after search form logged out state works"}
        end        
    end

    def test_recruiting
        #B2B testing
        @driver.find_element(:id, "learn_more").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("Recruiting evolved"), "The Jibe Recruitment Page loads"}
        @driver.find_element(:xpath, "//a[contains(@href,'get-referred')]").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("Reverse the model"), "The Jibe Recruitment - Get Referred Page loads"}
        @driver.find_element(:css, "a.tab.next > span").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("JIBE Post allows users"), "The Jibe Recruitment - Jibe Post Page loads"}
        @driver.find_element(:css, "a.tab.next > span").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("JIBE Apply allows you to"), "The Jibe Recruitment- JIBE Apply Page loads"}
        @driver.find_element(:css, "a.tab.next > span").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("Every JIBE user signs in using"), "The Jibe Recruitment - Dot Com Page loads"}
        @driver.find_element(:link, "About Us").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("recruiting solutions focused on mobile"), "The Jibe Recruitment - About Us Page loads"}
        @driver.find_element(:link, "Blog").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("Blog"), "The Jibe Recruitment - Blog Page loads"}
        @driver.find_element(:link, "Press").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("Please direct media"), "The Jibe Recruitment - Media Page loads"}
        @driver.find_element(:link, "Contact Us").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("If you are interested in learning more"), "The Jibe Recruitment - Contact Us Page loads"}
        @driver.find_element(:css, "button[type=\"submit\"]").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("Select at least one product"), "B2B contact us validations work"}
        @driver.find_element(:name, "first_name").clear
        @driver.find_element(:name, "first_name").send_keys "Testing - Name"
        @driver.find_element(:name, "last_name").clear
        @driver.find_element(:name, "last_name").send_keys "Testing - Last Name"
        @driver.find_element(:name, "company").clear
        @driver.find_element(:name, "company").send_keys "Testing - Company"
        @driver.find_element(:name, "title").clear
        @driver.find_element(:name, "title").send_keys "Testing - Title"
        @driver.find_element(:name, "email").clear
        @driver.find_element(:name, "email").send_keys "test@test.com"
        @driver.find_element(:name, "phone").clear
        @driver.find_element(:name, "phone").send_keys "1234567890"
        @driver.find_element(:name, "products[]").click
        Selenium::WebDriver::Support::Select.new(@driver.find_element(:name, "referral")).select_by(:text, "Email/Newsletter")
        @driver.find_element(:name, "message").clear
        @driver.find_element(:name, "message").send_keys "Please ignore this email"
    end

    def test_footerlinks
        @driver.get "http://www.jibe.com/"

        #Test footer links
        @driver.find_element(:link, "About Us").click
        begin
                assert @driver.find_element(:tag_name => "body").text.include?("JIBE is the leading innovator in "),"The Jibe Commitment Page loads"
        rescue
                @driver.save_screenshot("about.png")
                verify { assert @driver.find_element(:tag_name => "body").text.include?("JIBE is the leading innovator in "),"The Jibe Commitment Page loads"}
        end        
        @driver.find_element(:link, "FAQ").click
        begin
                assert @driver.find_element(:tag_name => "body").text.include?("We know that finding a job "),"The FAQ Page loads"
        rescue
                @driver.save_screenshot("faq.png")
                verify { assert @driver.find_element(:tag_name => "body").text.include?("We know that finding a job "),"The FAQ Page loads"}
        end
        @driver.find_element(:link, "Contact Us").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("We are here to"),"The Contact US Page loads"}
        @driver.find_element(:link, "Privacy Policy").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("explains what information"),"The Privacy Poilcy Page loads"}
        @driver.find_element(:link, "Terms of Use").click
        verify { assert @driver.find_element(:tag_name => "body").text.include?("you may use our"),"The Terms of Use Page loads"}
        @driver.find_element(:link, "JIBE").click
    end
     
    def test_facebooklogin
        #Test Firefox Login
        @driver.find_element(:link, "FB").click
        begin 
                @wait.until {@driver.window_handles.size > 1}
        rescue
                @driver.save_screenshot("fbpopupdisplayed.png")  
        end        
        handles = @driver.window_handles
        @driver.switch_to.window(handles[1])
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
                verify { assert @driver.find_element(:tag_name => "body").text.include?("Stacey Lin"),"The Facebook user successfully logs in"}
        end
        @driver.find_element(:css, "span").click
        @driver.find_element(:link, "Logout").click
        begin
                assert @driver.find_element(:tag_name => "body").text.include?("Harness the power of your"),"Facebook User can successfully log out"
        rescue
                @driver.save_screenshot("fblogout.png")  
                verify { assert @driver.find_element(:tag_name => "body").text.include?("Harness the power of your"),"Facebook User can successfully log out"}
        end
    end

    def test_linkedinlogin
        #Test Linkedin Login
        @driver.find_element(:link, "LI").click
        #wait.until {@driver.window_handles.size > 1}
        #handles = @driver.window_handles
        #@driver.switch_to.window(handles[1])
        @driver.find_element(:id, "session_key-oauthAuthorizeForm").clear
        @driver.find_element(:id, "session_key-oauthAuthorizeForm").send_keys "jibeqa@gmail.com"
        @driver.find_element(:id, "session_password-oauthAuthorizeForm").clear
        @driver.find_element(:id, "session_password-oauthAuthorizeForm").send_keys "jibejibe1124"
        @driver.find_element(:name, "authorize").click
        #wait.until {@driver.window_handles.size < 2}
        #handles = @driver.window_handles
        #@driver.switch_to.window(handles[0])
        begin
                @wait.until { @driver.find_element(:tag_name => "body").text.include?("Tom Gray")}
        rescue
                @driver.save_screenshot("linkedinLogin.png")  
        end
        verify { assert @driver.find_element(:tag_name => "body").text.include?("Tom Gray"),"The Linkedin user successfully logs in"}
        #@driver.find_element(:css, "span").click
        #@driver.find_element(:link, "Logout").click
        #verify { assert @driver.find_element(:tag_name => "body").text.include?("Harness the power of your"),"Facebook User can successfully log out"}
    end

    def test_profileandapplications
        # Test My Account
        login()
        @wait.until { @driver.find_element(:tag_name => "body").text.include?("Tom Gray")}
        @driver.find_element(:css, "span").click
        @driver.find_element(:link, "Profile").click
        @wait.until { @driver.find_element(:tag_name => "body").text.include?("Resumes")} 
        begin
                assert @driver.find_element(:tag_name => "body").text.include?("Resumes"),"First name on profile page is displayed"
        rescue
                @driver.save_screenshot("profileresumecheck.png")
                verify { assert @driver.find_element(:tag_name => "body").text.include?("Resumes"),"First name on profile page is displayed"}
        end  
        verify { assert_equal @driver.execute_script("return document.getElementsByName('user[first_name]')[0].value"),'Tom',"First name on profile page is displayed"}
        verify { assert_equal @driver.execute_script("return document.getElementsByName('user[last_name]')[0].value"),'Gray',"Last name on profile page is displayed"}
        verify { assert_equal @driver.execute_script("return document.getElementsByName('user[email]')[0].value"),'jibeqa@gmail.com',"Email on profile page is displayed"}
        @driver.find_element(:name, "user[first_name]").clear
        @driver.find_element(:name, "user[first_name]").send_keys "Thomas"
        @driver.find_element(:name, "user[last_name]").clear
        @driver.find_element(:name, "user[last_name]").send_keys "Grayus"
        @driver.find_element(:name, "user[email]").clear
        @driver.find_element(:name, "user[email]").send_keys "jibeqaABC@gmail.com"
        @driver.find_element(:css, "button.btn").click
        #user navigates out of the profile page
        @driver.find_element(:link, "JIBE").click
        @driver.find_element(:css, "span").click
        @driver.find_element(:link, "Profile").click 
        #check to see if the changes made are actually stored
        begin
                assert @driver.find_element(:tag_name => "body").text.include?("Profile updated successfully!"),"Profile values are changed successfully"
        rescue
                @driver.save_screenshot("namechangedsuccessfully.png")
                verify { assert @driver.find_element(:tag_name => "body").text.include?("Profile updated successfully!"),"Profile values are changed successfully"}
        end
        @driver.navigate.refresh
        @wait.until { @driver.find_element(:tag_name => "body").text.include?("Resumes")} 
        begin
                assert_equal @driver.execute_script("return document.getElementsByName('user[first_name]')[0].value"),'Thomas',"First name on profile page is displayed"
        rescue
                @driver.save_screenshot("newnameshownafterchange.png")
                verify { assert_equal @driver.execute_script("return document.getElementsByName('user[first_name]')[0].value"),'Thomas',"First name on profile page is displayed"}
        end
        verify { assert_equal @driver.execute_script("return document.getElementsByName('user[last_name]')[0].value"),'Grayus',"Last name on profile page is displayed"}
        verify { assert_equal @driver.execute_script("return document.getElementsByName('user[email]')[0].value"),'jibeqaABC@gmail.com',"Email on profile page is displayed"}
        #getting the old values back
        @driver.find_element(:name, "user[first_name]").clear
        @driver.find_element(:name, "user[first_name]").send_keys "Tom"
        @driver.find_element(:name, "user[last_name]").clear
        @driver.find_element(:name, "user[last_name]").send_keys "Gray"
        @driver.find_element(:name, "user[email]").clear
        @driver.find_element(:name, "user[email]").send_keys "jibeqa@gmail.com"
        @driver.find_element(:css, "button.btn").click
        verify { assert_equal @driver.execute_script("return document.getElementsByName('user[first_name]')[0].value"),'Tom',"First name on profile page is displayed"}
        verify { assert_equal @driver.execute_script("return document.getElementsByName('user[last_name]')[0].value"),'Gray',"Last name on profile page is displayed"}
        verify { assert_equal @driver.execute_script("return document.getElementsByName('user[email]')[0].value"),'jibeqa@gmail.com',"Email on profile page is displayed"}
        verify { assert @driver.find_element(:tag_name => "body").text.include?("Profile updated successfully!"),"Profile values are changed successfully"}
    end

    def test_twitter
        login()
        @wait.until { @driver.find_element(:tag_name => "body").text.include?("Tom Gray")}
        @driver.find_element(:link, "Ask JIBE").click
        @wait.until { @driver.find_element(:link, "Tweet")}
        @driver.find_element(:link, "Tweet").click
        begin 
                @wait.until {@driver.window_handles.size > 1}
        rescue
                @driver.save_screenshot("twitterpopup.png")
        end        
        handles = @driver.window_handles
        @driver.switch_to.window(handles[1])
        @wait.until { @driver.find_element(:id, "username_or_email") }
        @driver.find_element(:id, "username_or_email").clear
        @driver.find_element(:id, "username_or_email").send_keys "jibeqa@gmail.com"
        @driver.find_element(:id, "password").clear
        @driver.find_element(:id, "password").send_keys "jibejibe1124"
        @driver.find_element(:id, "allow").click
        @wait.until {@driver.window_handles.size < 2}
        handles = @driver.window_handles
        @driver.switch_to.window(handles[0])
        sleep 2
        a = @driver.switch_to.alert
        begin
                assert a.text == 'You must enter a valid tweet.',"The twitter message alert is displayed"
        rescue
                @driver.save_screenshot("twitterJSPopup.png")
                verify { assert a.text == 'You must enter a valid tweet.',"The twitter message alert is displayed"}
        end
        a.accept
    end    

=begin
    def test_resumeupload 
        #Test Resume Upload
        assert(@driver.find_element(:tag_name => "body").text.include?("Tom Gray"),"The Linkedin user successfully logs in")
        @driver.find_element(:css, "a.resumes > span").click
        @driver.find_element(:link, "Add a Resume").click
        #%x{ C:\\Users\\Amey\\Desktop\\uploadfile.exe }
        @driver.find_element(:id, "resume_resume").send_keys "C:\\Users\\Amey\\Desktop\\Sample_Resume.pdf" 
        @driver.find_element(:css, "button.btn_upload").click   
        @driver.find_element(:id, "nav_jobs").click
        @driver.find_element(:css, "a.resumes > span").click
        @driver.find_element(:xpath, "//div[@id='search_results']/div[3]/div[2]/ul/li/a").click
        @driver.switch_to.alert.accept
        @driver.find_element(:id, "nav_jobs").click
    end 

=end

    def profile_edit(company_id)
        begin
                @wait.until {@driver.find_element(:id, "application_data_email")}
        rescue
                @driver.save_screenshot("profileedit.png")
        end
        @driver.find_element(:id, "application_data_email").clear
        @driver.find_element(:id, "application_data_email").send_keys "jibeqa@gmail.com"
        @driver.find_element(:id, "application_data_street_address").clear
        @driver.find_element(:id, "application_data_street_address").send_keys "Test Street"
        @driver.find_element(:id, "application_data_city").clear
        @driver.find_element(:id, "application_data_city").send_keys "Test City"
        Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "application_data_resume_id")).select_by(:text, "Sample_Resume.pdf")
        Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "application_data_province_id")).select_by(:text, "New York")
        if company_id == 30
                if @driver.execute_script("return document.querySelectorAll(\'input#application_data_job_seeker_information_notice[type=checkbox]\')[0].checked")
                #if !@driver.execute_script("return document.getElementById('application_data_job_seeker_information_notice').checked")
                else
                        @driver.find_element(:xpath, "(//input[@id='application_data_job_seeker_information_notice'])[2]").click
                end    
        end        
        @driver.find_element(:link, "Continue").click
    end
    
    def questions (company_id)
        begin
                @wait.until {@driver.find_element(:tag_name => "body").text.include?("basic employer questions")}
        rescue
                @driver.save_screenshot("questionsfor#{company_id}.png")
                verify{ assert @driver.find_element(:tag_name => "body").text.include?("basic employer questions"),"Questions page does not load" }
        end
        slug = Services.slug_by_id(company_id)
        questions = Services.questions_by_slug(slug)
        question_number = 0
        questions[0]['questions'].each do |i|
            if i =~ /id=\"(.*?)\"/
                id =$1    
                question_number = question_number + 1
                if  i =~ /type=\"text\"/i
                    @driver.find_element(:id, "#{id}").clear
                    @driver.find_element(:id, "#{id}").send_keys "1000"
                elsif i =~ /checkbox/i
                    if !@driver.execute_script("return document.getElementById('#{id}').checked")
                        @driver.find_element(:id, "#{id}").click
                    end    
                elsif i =~ /textarea/i
                    @driver.find_element(:id, "#{id}").clear
                    @driver.find_element(:id, "#{id}").send_keys "1000 - text area"
                elsif i =~ /<\/option>/i
                    if i =~ /id=\"(.*?)\".*>(.*?)<\/option>/
                        label =$2
                        Selenium::WebDriver::Support::Select.new(@driver.find_element(:id, "#{id}")).select_by(:text, "#{label}")
                    end    
                elsif i =~ /type=\"radio\"/i
                    @driver.find_element(:id, "#{id}").click
                else
                    verify{ assert 'false',"Question:#{question_number} did not get detected with an id:#{id}"}
                end
            else
                verify{ assert 'false',"Question:#{question_number} does not have an id"}
            end            
        end
        @driver.find_element(:link, "Continue").click
    end

    def connections
        begin
                @wait.until {@driver.find_element(:tag_name => "body").text.include?("Select connections to include")}
        rescue
                @driver.save_screenshot("connections.png")
                verify { assert @driver.find_element(:tag_name => "body").text.include?("Select connections to include"),"Connections page loads"}
        end
        @wait.until {@driver.find_element(:link, "Continue")}
        @driver.find_element(:link, "Continue").click 
    end

    def final_review
        begin
              @wait.until {@driver.find_element(:xpath,"//div[@id='application_review']/dl/dt[1]/a")}
        rescue
              @driver.save_screenshot("finalreview.png")
              verify { assert @driver.find_element(:xpath,"//div[@id='application_review']/dl/dt[1]/a"), "The final review page is displayed"}  
        end
        @driver.find_element(:xpath,"//div[@id='application_review']/dl/dt[1]/a").click # Click on Edit for profile
    end


    def test_jobapplications
        login()
        @wait.until { @driver.find_element(:tag_name => "body").text.include?("Tom Gray")}
        company_id = [30,26,9] #company_id
        company_id.each do |i|
            @driver.get "http://www.jibe.com/jobs/#{Services.slug_by_id(i)}"
            begin
                @wait.until {@driver.find_element(:link, "Apply")}
            rescue
                if @driver.find_element(:tag_name => "body").text.include?("Sorry, this job is not active anymore.")
                    assert "true" , "The job:#{Services.slug_by_id(i)} is not active"
                elsif @driver.find_element(:tag_name => "body").text.include?("Applied")
                    assert "true" , "The user has already applied to #{Services.slug_by_id(i)}"
                else 
                    verify { assert "false", "For company id:#{i} the #{Services.slug_by_id(i)} had some issue"}
                    @driver.get "http://www.jibe.com/jobs/"
                end    
                next
            end        
            @driver.find_element(:link, "Apply").click
            if @driver.find_element(:tag_name => "body").text.include?("Upload a resume")
                profile_edit(i)
                questions(i)
                connections()
            elsif @driver.find_element(:tag_name => "body").text.include?("basic employer questions")
                questions(i)
                connections()
            elsif @driver.find_element(:tag_name => "body").text.include?("Select connections to include")
                connections()
                final_review()
                profile_edit(i)
                questions(i)
                connections()
            elsif  @driver.find_element(:tag_name => "body").text.include?("Not done yet")
                final_review()
                profile_edit(i)
                questions(i)
                connections()
            else    
                assert "false","Something went terrible wrong"
            end
        sleep 2
        verify { assert @driver.find_element(:xpath,"//div[@id='application_review']/dl/dt[1]/a"),"The Final Submit - Review application loads FAILS HERE!"}
        verify { assert @driver.find_element(:xpath, "//div[@id='review']/div[2]/a[1]"),"The Final Submit xpath is here"}
        verify { assert @driver.find_element(:css, "#review > div.application-actions > a.btn_cancel"),"The Final Submit - Cancel button from old script"}
        @wait.until { @driver.find_element(:css, "#review > div.application-actions > a.btn_cancel").displayed?}
        @driver.find_element(:css, "#review > div.application-actions > a.btn_cancel").click    
        #@driver.find_element(:xpath, "//div[@id='review']/div[2]/a[1]").click   # the xpath alternative for Cancel on Final Review Page
        end        
        @driver.find_element(:css, "span").click
        @driver.find_element(:link, "Logout").click
        assert(@driver.find_element(:tag_name => "body").text.include?("Harness the power of your"),"User can successfully log out") 
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

#sample code for futute reference
=begin
        begin
            assert(@driver.find_element(:tag_name => "body").text.include?("We are heree to"),"The Contact US Page loads")
        rescue Test::Unit::AssertionFailedError
            @verification_errors << $!
        end


test_recruiting = Test::Unit::TestSuite.new("Test Recruiting") << RegressionTesting.new('test_recruiting')
test_pagination = Test::Unit::TestSuite.new("Test Pagination")<< RegressionTesting.new('test_pagination')
test_footerlinks = Test::Unit::TestSuite.new("Test FooterLinks") << RegressionTesting.new('test_footerlinks')
test_facebooklogin = Test::Unit::TestSuite.new("Test Facebook Login") << RegressionTesting.new('test_facebooklogin')
test_profileandapplications = Test::Unit::TestSuite.new("Test Profile Update") << RegressionTesting.new('test_profileandapplications')
test_linkedinlogin = Test::Unit::TestSuite.new("Test Linkedin Login") << RegressionTesting.new('test_linkedinlogin')
test_twitter = Test::Unit::TestSuite.new("Test Twitter") << RegressionTesting.new('test_twitter')
test_jobapplications = Test::Unit::TestSuite.new("Test Job Applications") << RegressionTesting.new('test_jobapplications')



#run the suites
Thread.new{Test::Unit::UI::Console::TestRunner.run(test_recruiting)}
Thread.new{Test::Unit::UI::Console::TestRunner.run(test_pagination)}
Thread.new{Test::Unit::UI::Console::TestRunner.run(test_footerlinks)}
Thread.new{Test::Unit::UI::Console::TestRunner.run(test_profileandapplications)}
Thread.new{Test::Unit::UI::Console::TestRunner.run(test_linkedinlogin)}
Thread.new{Test::Unit::UI::Console::TestRunner.run(test_twitter)}
#One test suite must be called without Thread. 
#Else the complete test will be executed.
Test::Unit::UI::Console::TestRunner.run(test_jobapplications)




=end