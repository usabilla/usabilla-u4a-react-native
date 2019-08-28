[![license](https://img.shields.io/badge/license-MIT-brightgreen.svg)](https://github.com/usabilla/usabilla-u4a-react-native/blob/develop/LICENSE)


# Usabilla for React Native

Usabilla for Apps allows you to collect feedback from your users with great ease and flexibility.
This React Native bridge to the Native Usabilla SDK allows you to load passive feedback forms and submit results from a React Native app.

## Installation

To install the Usabilla SDK into your React Native Application:
1. In a terminal window, navigate to the root directory of your project and run :

```
npm install usabilla-react-native
```
or 

```
yarn add usabilla-react-native
```

2. To link the bridge to your project:

```
react-native link usabilla-react-native
```

### Additional setup
#### iOS
This release uses the Usabilla SDK v6.4.0.

1. The native Usabilla SDK is written in Swift, So make sure that your iOS Project contains a Bridging-Header file or add one.
   The default project created by react-native will not create this. 
   To have XCode create the bridge-header automatically, open the ios-project in XCode:
   - select "New File"
   - select "Swift file"
   - save it with any name, as its not being used
   - choose "Create Bridging Header"
   
   ![](./images/AddNewFile.png)
   ![](./images/AddNewFile2.png)
   ![](./images/AddNewFile3.png)
2. In your iOS project go to `Build Settings` -> `Framework Search Paths` and add :
`$(SRCROOT)/../node_modules/usabilla-react-native/ios`
   ![](./images/AddPath.png)
3. In `Build Phases` create a `New Copy Files Phase`
- Setup Destination to Frameworks.
- Drag and drop the `Usabilla.framework` from `ReactNativeUsabilla/Frameworks` and check the `code sign on copy`.
- Make sure that You set Destination to "Frameworks"
   ![](./images/AddCopyPhase.png)
   ![](./images/AddCopyPhase2.png)
   
 - Make sure to add :
   ```
   Privacy - Camera Usage Description
   ```
   and
   ```
   Privacy - Photo Library Usage Description
   ```
   with a meaning full explanation to the end-user.
   
 The project can now be compiled without any errors related to Usabilla SDK   

#### Android

1. Make sure that your `MainActivity.java` extends `ReactFragmentActivity`
2. In case of compilation problems in Android Studio, set the `compileSdkVersion` in the app module `build.gradle` to `26`

### Requirements

This version of the react native bridge works with the latest release of `XCode 9.3`. In order to use this bridge with older XCode versions please use the package version `@0.5.3` or less.

## Features

You can start using the Usabilla for React Native module in your app by requiring:

`const usabilla = require('usabilla-react-native')`

### Load a Passive Feedback form

In order to load a Passive Feedback form with the Usabilla library you need to call:

`usabilla.loadFeedbackForm("YOUR_FORM_ID_HERE")`

This method only performs the call to fetch the Passive Feedback form and in order to handle its response there are two methods available:

- `usabilla.setFormDidLoadSuccessfully(usabilla.showLoadedForm())`: Sets the callback to execute when the form is fetched successfully
- `usabilla.setFormDidFailLoading((error) => console.log(error))`: Sets the callback to execute when the form fails to be fetched. This callback has a parameter `error` containing a text explaining what happened

**NOTE**: Usabilla provides a standard callback for showing a successfully fetched form with the method `usabilla.showLoadedForm()`

**[iOS ONLY]**: When a user submits or closes the form, it is possible to get a callback containing information about the submission using the method:

`usabilla.setFormDidClose((reminder) => console.log(reminder))`

This callback has a parameter containing the information:
  - formId (string)
  - isRedirectToAppStoreEnabled (boolean)

### Pre-fill a Passive Feedback form with a custom screenshot

Usabilla for React Native allows you to attach a screenshot to a form before sending it by calling:

`usabilla.loadFeedbackFormWithCurrentViewScreenshot("YOUR_FORM_ID_HERE")`

This method will take a screenshot of the current visible view and pre-fill the form with it.

### Submit the results of the form

This functionality is embedded in the native Usabilla library and there is no need to perform any specific action from the React Native environment.

### Support for custom variables

In order to set custom variables in the Usabilla native library it's necessary to call the method:

`usabilla.setCustomVariables(customVars)`

This method accepts as parameter a valid JSON object with two limitations:

- Arrays should only contain same type components.
- Objects can be nested up to one level (currently undergoing work to enable deeper nesting).

**NOTE**: Feedback sent without respecting those limitations will still be received and saved, but the values of the customer input context won't be displayed nor exported.

### Campaigns

In order to be able to run campaigns in your app, you should first start by initializing the SDK:

`usabilla.initialize("YOUR_APP_ID")`

This call loads and updates all your campaigns locally and you can start targeting them by sending events from your app using the method:

`usabilla.sendEvent("YOUR_EVENT_NAME")`

The Usabilla SDK allows you to reset all the campaign data by calling:

Android: `usabilla.resetCampaignData()`

iOS: `usabilla.resetCampaignData(callback)` , the `callback` here lets you know when the reset is done.

## Support

Usabilla For React Native is maintained by the Usabilla Development Team. Everyone is encouraged to file bug reports, feature requests, and pull requests through GitHub. This input is critical and will be carefully considered, but we cannot promise a specific resolution or time frame for your request. For more information please email our Support Team at support@usabilla.com
