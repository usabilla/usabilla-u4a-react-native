import { NativeModules, Platform } from 'react-native';
let {UsabillaBridge} = NativeModules;

function sum(a, b) {
    return a + b;
}

function initialize(appId) {
    console.log("initialize")
    if (Platform.OS == 'ios') {
        console.log(NativeModules);
        NativeModules.UsabillaBridge.initialize(appId)
    }
}

function loadFeedbackForm(formId) {
    if (Platform.OS == 'ios') {
        NativeModules.UsabillaBridge.loadFeedbackForm(formId)
    }
}

function showLoadedForm(event) {
    console.log("showLoadedForm")
    NativeModules.UsabillaBridge.showLoadedFrom()
}

module.exports = {
    initialize,
    loadFeedbackForm,
    showLoadedForm,
    sum
}