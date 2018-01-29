### Android steps to build a ReactNative bridge
1. Create a folder for your project and go inside it
2. Create a `package.json` file like this:
    ```
    {
        "name": "name-of-your-bridging-package",
        "version": "1.0.0",
        "files": [
            "ios",
            "android"
        ],
        "main": "index.js",
        "scripts": {
            "start": "node node_modules/react-native/local-cli/cli.js start",
            "test": "jest"
        },
        "dependencies": {
            "react": "16.2.0",
            "react-native": "0.52.0"
        },
        "devDependencies": {
            "babel-jest": "22.0.4",
            "babel-preset-react-native": "4.0.0",
            "jest": "22.0.4",
            "react-test-renderer": "16.2.0"
        },
        "jest": {
            "preset": "react-native"
        }
    }
    ```
3. Run the command `npm install` to have the right packages installed in the folder
4. Create a folder named `android` for your Android files and go inside it
5. Create a `build.gradle` file like this:
    ```
    buildscript {
        repositories {
            jcenter()
            google()
        }
        dependencies {
            classpath 'com.android.tools.build:gradle:3.0.1'
        }
    }

    apply plugin: 'com.android.library'

    android {
        compileSdkVersion 26
        buildToolsVersion "26.0.2"

        defaultConfig {
            minSdkVersion 16
            targetSdkVersion 26
            versionCode 1
            versionName "1.0.0"
        }
        lintOptions {
            abortOnError false
        }
    }

    repositories {
        mavenLocal()
        jcenter()
        maven {
            // All of React Native (JS, Obj-C sources, Android binaries) is installed from npm
            url "$rootDir/../node_modules/react-native/android"
        }
        google()
    }

    dependencies {
        implementation 'com.usabilla.sdk:ubform:4.0.0'
        implementation "com.facebook.react:react-native:0.52.0"
    }
    ```
6. Create a path of folders named `src/main` and go inside it
7. Create a `AndroidManifest.xml` file like this:
    ```
    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
        package="com.packagename"
        android:versionCode="1"
        android:versionName="1.0"/>
    ```
8. Create a path of folders named `java/com/packagename` and go inside it
9. Create a class called `MyBridgeModule.java` (which will host all the methods bridging from React Native to Java) like this:
    ```
    public class MyBridgeModule extends ReactContextBaseJavaModule {

        public MyBridge(ReactApplicationContext context) {
            super(context);
        }

        @Override
        public String getName() {
            return "MyBridgeModule";
        }

        @ReactMethod
        public void initialize(@NonNull String appId) {
            final Activity activity = getCurrentActivity();
            if (activity != null) {
                Usabilla.initialize(activity.getBaseContext(), appId);
            }
        }

        // Other methods...
    }
    ```
10. Create a class called `MyBridgePackage.java` (to be able to reference the previous class from React Native) like this:
    ```
    public class MyBridgePackage implements ReactPackage {

        @Override
        public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
            final List<NativeModule> modules = new ArrayList<>();
            modules.add(new MyBridgeModule(reactContext));
            return modules;
        }

        @Override
        public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
            return Collections.emptyList();
        }
    }
    ``` 
11. Go back to the main folder of your project (where the `package.json` file is present) and create an `index.js` file to expose the methods from your Java classes like this:
    ```
    import { NativeModules } from 'react-native';

    function init(appId) {
        NativeModules.MyBridgeModule.initialize(appId)
    }
    
    module.exports = {
        init
    }
    ```
12. [Publish the package to npm](https://docs.npmjs.com/getting-started/publishing-npm-packages)
13. Create a new folder for a testing app with the command `react-native init TestApp` and go inside it
14. Install all packages this app depends on (including your own) with the command `rm -rf node_modules && npm install && npm install name-of-your-bridging-package --save`
15. Link the Android classes with the command `react-native link name-of-your-bridging-package`
16. Double check that the bridging went well checking if the [following modifications](https://github.com/maxs15/react-native-spinkit/wiki/Manual-linking---Android) have been applied to the Android files within the `android` folder of the testing app
17. Add the following to the `App.js` file of the testing app
    ```
    const Usabilla = require('name-of-your-bridging-package');
    ```
    You should be able to call a method in the `MyBridgeModule.java` from the RN app with 
    ```
    Usabilla.initialize('5a37c12145380769f373d71b');
    ```
18. Run the app either opening the project in the `android` folder with AndroidStudio, or via command line typing `react-native run-android` from within the testing app folder to check that all works
19. DONE ;)