from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
import unittest, time, re

class MobileStatic(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Remote(command_executor='http://192.168.1.108:3001/hub', desired_capabilities={'browserName': 'iphone'})
        self.driver.implicitly_wait(30)
        self.base_url = "http://www.jibe.com/"
        self.verificationErrors = []
    
    def test_mobile_static(self):
        driver = self.driver
        driver.get("http://www.jibe.com")
        driver.find_element_by_link_text("FAQ").click()
        element=driver.page_source
        self.assertTrue("When I login with my Facebook" in  element)
        driver.back()
        driver.find_element_by_link_text("Privacy Policy").click()
        element=driver.page_source
        self.assertTrue("This Privacy Policy was last revised on" in  element)
        driver.back()
        driver.find_element_by_link_text("Terms of Use").click()
        element=driver.page_source
        self.assertTrue("This Agreement was last revised on" in  element)
        driver.back()
        driver.find_element_by_link_text("Contact Us").click()
        element=driver.page_source
        self.assertTrue("What do you need help with" in  element)
        
    
    def is_element_present(self, how, what):
        try: self.driver.find_element(by=how, value=what)
        except NoSuchElementException, e: return False
        return True
    
    def tearDown(self):
        self.driver.quit()
        self.assertEqual([], self.verificationErrors)

suite = unittest.TestLoader().loadTestsFromTestCase(MobileStatic)
unittest.TextTestRunner(verbosity=2).run(suite)
