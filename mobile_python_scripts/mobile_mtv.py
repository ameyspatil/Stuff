from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
import unittest, time, re

class Mtv(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Remote(command_executor='http://192.168.1.108:3001/hub', desired_capabilities={'browserName': 'iphone'})
        self.driver.implicitly_wait(30)
        self.base_url = "http://www.jibe.com/"
        self.verificationErrors = []
    
    def test_Mtv(self):
        driver = self.driver
        driver.get("http://www.jibe.com")
        driver.find_element_by_css_selector("img[alt=Linkedin]").click()
        driver.find_element_by_id("session_key-oauthAuthorizeForm").clear()
        driver.find_element_by_id("session_key-oauthAuthorizeForm").send_keys("jibeqa@gmail.com")
        driver.find_element_by_id("session_password-oauthAuthorizeForm").clear()
        driver.find_element_by_id("session_password-oauthAuthorizeForm").send_keys("jibejibe1124")
        driver.find_element_by_name("authorize").click()
        driver.find_element_by_link_text("Clear Search").click()
        driver.find_element_by_id("q").clear()
        driver.find_element_by_id("q").send_keys("mtv")
        driver.find_element_by_css_selector("button.mobile_button.highlight").click()
        driver.find_element_by_link_text("Apply").click()
        driver.find_element_by_link_text("Email Your Resume").click()
        driver.find_element_by_link_text("Continue").click()
        
        driver.find_element_by_link_text("Continue").click()
        
        selectBox = self.driver.find_element_by_id("CUSTOM_831")
        options = selectBox.find_elements_by_tag_name("option")
        one = options[2]
        one.click()
        
        selectBox = self.driver.find_element_by_id("legalStatus")
        options = selectBox.find_elements_by_tag_name("option")
        one = options[2]
        one.click()
        
        
        
        driver.find_element_by_id("CUSTOM_293").clear()
        driver.find_element_by_id("CUSTOM_293").send_keys("100,000")
        driver.find_element_by_id("CUSTOM_655").clear()
        driver.find_element_by_id("CUSTOM_655").send_keys("QA")
        driver.find_element_by_id("CUSTOM_645").clear()
        driver.find_element_by_id("CUSTOM_645").send_keys("JIBE")
        driver.find_element_by_link_text("Continue").click()
        driver.find_element_by_id("cancel").click()
        driver.find_element_by_id("btn_menu").click()
        driver.find_element_by_link_text("Sign Out").click()
    
    def is_element_present(self, how, what):
        try: self.driver.find_element(by=how, value=what)
        except NoSuchElementException, e: return False
        return True
    
    def tearDown(self):
        self.driver.quit()
        self.assertEqual([], self.verificationErrors)

suite = unittest.TestLoader().loadTestsFromTestCase(Mtv)
unittest.TextTestRunner(verbosity=2).run(suite)
