from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException
import unittest, time, re

class Boa(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Remote(command_executor='http://192.168.1.108:3001/hub', desired_capabilities={'browserName': 'iphone'})
        self.driver.implicitly_wait(30)
        self.base_url = "http://www.jibe.com/"
        self.verificationErrors = []
    
    def test_Boa(self):
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
        driver.find_element_by_id("q").send_keys("bank of america")
        driver.find_element_by_xpath("id('search_form')/ol/li[4]/button").click()
        element=driver.page_source
        self.assertFalse("Your search for bank of america returned no results" in  element)
        driver.find_element_by_link_text("Apply").click()
        # ERROR: Caught exception [ERROR: Unsupported command [select]]
        driver.find_element_by_link_text("Email Your Resume").click()
        driver.find_element_by_link_text("Continue").click()
        
        driver.find_element_by_link_text("Continue").click()
        
        driver.find_element_by_id("dialogTemplate-dialogForm-StatementBeforeAuthentificationContent-AcceptCheckbox_1").click()
        
        selectBox = self.driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-candidatePersonalInfoBlock-CSCustomFormSubSection-_id153-dv_cs_candidate_personal_info_UDFCandidatePersonalInfo_Related_Work_Experience")
        options = selectBox.find_elements_by_tag_name("option")
        one = options[4]
        one.click()
        
        selectBox = self.driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-candidatePersonalInfoBlock-CSCustomFormSubSection-_id153-dv_cs_candidate_personal_info_UDFCandidatePersonalInfo_Relocation")
        options = selectBox.find_elements_by_tag_name("option")
        one = options[1]
        one.click()



        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-careerSectionEducationForm-educationFragmentIter-0-_id161-dv_cs_education_Institution").clear()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-careerSectionEducationForm-educationFragmentIter-0-_id161-dv_cs_education_Institution").send_keys("National Test Pilot School (NTPS)")
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-careerSectionWorkExperienceForm-workExperienceFragmentIter-0-_id162-dv_cs_experience_Employer").clear()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-careerSectionWorkExperienceForm-workExperienceFragmentIter-0-_id162-dv_cs_experience_Employer").send_keys("AA")
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-0-questionRadio_art.hr.metaentity.question.PossibleAnswer__5075").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-1-questionRadio_art.hr.metaentity.question.PossibleAnswer__10255").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-2-questionRadio_art.hr.metaentity.question.PossibleAnswer__5087").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-3-questionRadio_art.hr.metaentity.question.PossibleAnswer__10257").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-4-questionRadio_art.hr.metaentity.question.PossibleAnswer__5076").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-5-questionRadio_art.hr.metaentity.question.PossibleAnswer__10934").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-6-questionRadio_art.hr.metaentity.question.PossibleAnswer__5079").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-7-questionRadio_art.hr.metaentity.question.PossibleAnswer__5080").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-8-questionRadio_art.hr.metaentity.question.PossibleAnswer__5083").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-9-questionRadio_art.hr.metaentity.question.PossibleAnswer__5085").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-0-questionRadio_art.hr.metaentity.question.PossibleAnswer__8535").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-knockoutQuestionnaireBlock-_id147-page__1-questionnaire-_id148-1-questionRadio_art.hr.metaentity.question.PossibleAnswer__5088").click()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-eSignatureBlock-CSCustomFormSubSection-_id166-dv_cs_esignature_Initials").clear()
        driver.find_element_by_id("editTemplate-editForm-content-flowTemplateFull-genericPage-_id142-page_0-eSignatureBlock-CSCustomFormSubSection-_id166-dv_cs_esignature_Initials").send_keys("as")
        driver.find_element_by_link_text("Continue").click()
        driver.find_element_by_id("cancel").click()
        driver.find_element_by_id("flash").click()
        driver.find_element_by_id("btn_menu").click()
        driver.find_element_by_link_text("Sign Out").click()
             
            
    
    def is_element_present(self, how, what):
        try: self.driver.find_element(by=how, value=what)
        except NoSuchElementException, e: return False
        return True
    
    def tearDown(self):
        self.driver.quit()
        self.assertEqual([], self.verificationErrors)

suite = unittest.TestLoader().loadTestsFromTestCase(Boa)
unittest.TextTestRunner(verbosity=2).run(suite)
