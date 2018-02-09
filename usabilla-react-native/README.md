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
1. The native Usabilla SDK is written in Swift, So make sure that your iOS Project contains a Bridging-Header file or add one.
2. In your iOS project go to `Build Settings` -> `Framework Search Paths` and add :
`$(SRCROOT)/../node_modules/usabilla-react-native/ios`
3. In `Build Phases` create a `New Copy Files Phase`
- Setup Destination to Frameworks.
- Drag and drop the `Usabilla.framework` from `ReactNativeUsabilla/Frameworks` and check the `code sign on copy`.

#### Android
1. To make sure that the linking happened properly, check that the following modifications took place:
- In `android/app/build.gradle` the line `compile project(':usabilla-react-native')` is added
- In `android/settings.gradle` the lines `include ':usabilla-react-native'` and `project(':usabilla-react-native').projectDir = new File(rootProject.projectDir, '../node_modules/usabilla-react-native/android')` are added
- In your `MainApplication.java` the `UsabillaBridgePackage` has been added to the list of packages returned by the method `getPackages()` 

### Requirements
To use this Bridge, please make sure you are using XCode 9.1 or above.

## Features
The first version of Usabilla for React Native `0.1.0` allows you to :
- Load and show a Passive Feedback form.
- Submit the results of the form.

### Upcoming features
- Pre-fill a Passive Feedback form with a custom screenshot.
- Add support for custom variables.
- Add support for Campaigns (active surveys).

## Support

The Usabilla For React Native is maintained by the Usabilla Development Team. Everyone is encouraged to file bug reports, feature requests, and pull requests through GitHub. This input is critical and will be carefully considered, but we cannot promise a specific resolution or time frame for your request. For more information please email our Support Team at support@usabilla.com
