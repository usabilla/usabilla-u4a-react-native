import { NativeModules, Platform } from 'react-native';

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

function updateFragmentManager() {
    console.log("updateFragmentManager")
    if (Platform.OS == 'android') {
        NativeModules.UsabillaBridge.updateFragmentManager()
    }
}

function reset() {
    console.log("reset")
    if (Platform.OS == 'android') {
        NativeModules.UsabillaBridge.resetCampaignData()
    }
}

function sendEvent(event) {
    console.log("sendEvent")
    if (Platform.OS == 'android') {
        NativeModules.UsabillaBridge.sendEvent(event)
    }
}

module.exports = {
    initialize,
    loadFeedbackForm,
    updateFragmentManager,
    reset,
    sendEvent,
    sum
}