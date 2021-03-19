const wdio = require('webdriverio');
const assert = require('assert');
const { byValueKey } = require('appium-flutter-finder');
const { byText } = require('appium-flutter-finder');

const platform = process.argv[2]
const device = process.argv[3]
const osSpecificOps = platform === 'android' ? 
{
    platformName: 'Android',
    deviceName: device === 'smartphone' ? 'Android Emulator' : 'Android Tablet Emulator',
    appPackage: 'com.example.vaccine_survey',
    appActivity: 'MainActivity'
}
: platform === 'ios' ? 
{
    platformName: 'iOS',
    platformVersion: '12.2',
    deviceName: 'iPhone X',
    noReset: true,
    app: __dirname +  '/../apps/Runner.zip',

} : {};

const opts = 
{
    port: 4723,
    capabilities: {
        ...osSpecificOps,
        automationName: 'Flutter',
        retryBackoffTime: 500
    }
};

(async () => 
{
    const driver = await wdio.remote(opts);

    //Application Constants
    const cities = ['Ankara', 'Istanbul', 'Izmir', 'Konya']
    const genders = ['Male', 'Female']
    const vaccines = ['Biontech', 'Moderna', 'Pfizer', 'Sinovac', 'Sputnik V']

    //Default Interaction Elements 
    const nameInput = byValueKey('NameInput')
    const datePickerButton = byValueKey('DatePickerButton')
    const cityPickerButton = byValueKey('CityPickerButton')
    const genderPickerButton = byValueKey('GenderPickerButton')
    const vaccinePickerButton = byValueKey('VaccinePickerButton')
    const sidefxInput = byValueKey('SideEffectsInput')
    const submitButton = byValueKey('SubmitButton')

    //Default Label Elements
    const titleLabel = byValueKey('Title')
    const nameLabel = byValueKey('NameLabel')
    const dateLabel = byValueKey('DateLabel')
    const cityLabel = byValueKey('CityLabel')
    const genderLabel = byValueKey('GenderLabel')
    const vaccineLabel = byValueKey('VaccineLabel')
    const sidefxLabel = byValueKey('SideEffectsLabel')

    //Default Sign Elements
    const submitResult = byValueKey('SubmitResult')

    //Check Routines
    async function checkUIComponents() 
    {
        //assert.strictEqual(await driver.getElementText(titleLabel), 'Vaccine Survey') //Currently, appium-fluuter-driver cannot get_text for AppBar components
        assert.strictEqual(await driver.getElementText(nameLabel), 'Full Name ')
        assert.strictEqual(await driver.getElementText(dateLabel), 'Date of Birth: ')
        assert.strictEqual(await driver.getElementText(cityLabel), 'City ')
        assert.strictEqual(await driver.getElementText(genderLabel), 'Gender ')
        assert.strictEqual(await driver.getElementText(vaccineLabel), 'Vaccine ')
        assert.strictEqual(await driver.getElementText(sidefxLabel), 'Side Effects ')
        //assert.strictEqual(await driver.getElementText(datePickerButton), 'Select date')  //Currently, appium-fluuter-driver cannot get_text for ElevatedButton components
        //assert.strictEqual(await driver.getElementText(submitButton), 'Submit')  //Currently, appium-fluuter-driver cannot get_text for ElevatedButton components
    }

    async function checkInputFunctionalities() 
    {
        await driver.elementClick(submitButton)
        assert.strictEqual(await driver.getElementText(submitResult), 'Please enter your name')

        await driver.elementSendKeys(nameInput, 'Burak')
        await driver.elementClick(submitButton)
        assert.strictEqual(await driver.getElementText(submitResult), 'Please enter your full name')

        await driver.elementSendKeys(nameInput, '@Burak1 Mutlu')
        await driver.elementClick(submitButton)
        assert.strictEqual(await driver.getElementText(submitResult), 'Please enter only letters')

        await driver.elementSendKeys(nameInput, 'Burak Mutlu')
        await driver.elementClick(submitButton)
        assert.strictEqual(await driver.getElementText(submitResult), 'Invalid Date! Please enter a valid date')

        await driver.elementClick(datePickerButton)
        await driver.elementClick(byText('17'))
        await driver.elementClick(byText('OK'))
        await driver.elementClick(submitButton)
        assert.strictEqual(await driver.getElementText(submitResult), 'Please enter the side effects you have faced')

        for(const city of cities) 
        {
            await driver.elementClick(cityPickerButton)
            await driver.elementClick(byText(city))
            await driver.elementClick(submitButton)
            assert.strictEqual(await driver.getElementText(submitResult), 'Please enter the side effects you have faced')
        }

        for(const gender of genders) 
        {
            await driver.elementClick(genderPickerButton)
            await driver.elementClick(byText(gender))
            await driver.elementClick(submitButton)
            assert.strictEqual(await driver.getElementText(submitResult), 'Please enter the side effects you have faced')
        }

        for(const vaccine of vaccines) 
        {
            await driver.elementClick(vaccinePickerButton)
            await driver.elementClick(byText(vaccine))
            await driver.elementClick(submitButton)
            assert.strictEqual(await driver.getElementText(submitResult), 'Please enter the side effects you have faced')
        }
    
        await driver.elementSendKeys(sidefxInput, 'None')
        await driver.elementClick(submitButton)
        assert.strictEqual(await driver.getElementText(submitResult), 'Survey Saved, Thank You!')
    }

    async function checkScreenshotFunctionality() 
    {
        await driver.takeScreenshot()
    }

    //Wait for the page load
    await driver.execute('flutter:waitFor', titleLabel)
    await checkUIComponents()
    await checkInputFunctionalities()
    await checkScreenshotFunctionality()

    driver.deleteSession();
})();