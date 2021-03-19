import unittest
from os import getcwd
from appium.webdriver import Remote
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By

Cities = ["Istanbul", "Ankara", "Izmir"]
Genders = ["Male", "Female"]
Vaccines = ['Biontech', 'Moderna', 'Pfizer', 'Sinovac', 'Sputnik V']

page_title_xpath = '//android.view.View[@content-desc="Vaccine Survey"]'
name_label_xpath = '//android.view.View[@content-desc="Full Name "]'
name_input_xpath = '/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.widget.EditText[1]'
name_error_xpath = '(//android.view.View[@content-desc="{error}}"])'
date_label_xpath = '//android.view.View[@content-desc="Date of Birth: "]'
city_label_xpath = '//android.view.View[@content-desc="City "]'
city_button_generic_xpath = '//android.widget.Button[@content-desc="{city}"]'
city_generic_xpath = '//android.view.View[@content-desc="{city}"]'
gender_label_xpath = '//android.view.View[@content-desc="Gender "]'
gender_button_generic_xpath = '//android.widget.Button[@content-desc="{gender}"]'
gender_generic_xpath = '//android.view.View[@content-desc="{gender}"]'
vaccine_label_xpath = '//android.view.View[@content-desc="Vaccine "]'
vaccine_button_generic_xpath = '//android.widget.Button[@content-desc="{vaccine}"]'
vaccine_generic_xpath = '//android.view.View[@content-desc="{vaccine}"]'
sidefx_label_xpath = '//android.view.View[@content-desc="Side Effects "]'
sidefx_input_xpath = '/hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.widget.FrameLayout/android.view.View/android.view.View/android.view.View/android.view.View/android.widget.EditText[2]'
sidefx_error_xpath = '//android.view.View[@content-desc="Please enter the side effects you have faced"]'
submit_button_xpath = '//android.widget.Button[@content-desc="Submit"]'
submit_result_xpath = '//android.view.View[@content-desc="{message}"]'


def name_input_check():
    driver.find_element_by_xpath(name_input_xpath).click()

    (Mo)driver.find_element_by_xpath(name_input_xpath)
    driver.find_element_by_xpath(submit_button_xpath).click()
    print(driver.find_element_by_xpath(name_error_xpath.format(message="Please enter your name")).is_displayed())


appium_url = "http://localhost:4723/wd/hub"
dc = {'platformName': "Android", 'deviceName': "Android Emulator", 'appPackage': "com.example.vaccine_survey", 'appActivity': "MainActivity"}
driver = Remote(appium_url, dc)
WebDriverWait(driver, 20).until(EC.element_to_be_clickable((By.XPATH, submit_button_xpath)))

current_city = Cities[0]
current_gender = Genders[0]
current_vaccine = Vaccines[0]
name_input_check()
