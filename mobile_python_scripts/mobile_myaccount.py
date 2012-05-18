from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
import unittest, time, re

class myaccount(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Remote(command_executor='http://192.168.1.108:3001/hub', desired_capabilities={'browserName': 'iphone'})
        self.driver.implicitly_wait(30)
        self.base_url = "http://www.jibe.com/"
        self.verificationErrors = []
    
    def test_myaccount(self):
        driver = self.driver
        driver.get("http://www.jibe.com")
        driver.find_element_by_css_selector("img[alt=Linkedin]").click()
        driver.find_element_by_id("session_key-oauthAuthorizeForm").clear()
        driver.find_element_by_id("session_key-oauthAuthorizeForm").send_keys("jibeqa@gmail.com")
        driver.find_element_by_id("session_password-oauthAuthorizeForm").clear()
        driver.find_element_by_id("session_password-oauthAuthorizeForm").send_keys("jibejibe1124")
        driver.find_element_by_name("authorize").click()
        driver.find_element_by_id("btn_menu").click()
        driver.find_element_by_link_text("Stats").click()
        
        element=driver.page_source
        self.assertTrue("Your Network Stats" in  element)
        
        driver.find_element_by_link_text("View All").click()
        driver.find_element_by_link_text("Back").click()
        driver.find_element_by_xpath("//div[@id='content']/div[4]/div[3]/ul/li/a").click()
        driver.find_element_by_link_text("Back").click()
        driver.find_element_by_id("btn_menu").click()
        driver.find_element_by_link_text("Dashboard").click()
        
        element=driver.page_source
        self.assertTrue("Cover Letters" in  element)
        
        driver.find_element_by_link_text("View").click()
        
        element=driver.page_source
        self.assertTrue("Resume.txt" in  element)
        
        driver.find_element_by_link_text("Back").click()
        driver.find_element_by_id("btn_menu").click()
        driver.find_element_by_link_text("Jobs").click()
        
        element=driver.page_source
        self.assertTrue("job results for" in  element)
        
        driver.find_element_by_id("btn_menu").click()
        driver.find_element_by_link_text("Sign Out").click()
    
    def is_element_present(self, how, what):
        try: self.driver.find_element(by=how, value=what)
        except NoSuchElementException, e: return False
        return True
    
    def tearDown(self):
        self.driver.quit()
        self.assertEqual([], self.verificationErrors)

suite = unittest.TestLoader().loadTestsFromTestCase(myaccount)
unittest.TextTestRunner(verbosity=2).run(suite)