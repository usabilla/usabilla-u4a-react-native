import { NativeModules, Platform } from 'react-native';

function initialize(appId) {
    console.log("initialize")
    if (Platform.OS == 'ios') {
        NativeModules.RNUsabilla.initialize(appId)
    }
}

function loadFeedbackForm(formId) {
    if (Platform.OS == 'ios') {
        NativeModules.RNUsabilla.loadFeedbackForm(formId)
    }
}

function updateFragmentManager() {
    console.log("updateFragmentManager")
    if (Platform.OS == 'android') {
        NativeModules.RNUsabilla.updateFragmentManager()
    }
}

function reset() {
    console.log("reset")
    if (Platform.OS == 'android') {
        NativeModules.RNUsabilla.resetCampaignData()
    }
}

function sendEvent(event) {
    console.log("sendEvent")
    if (Platform.OS == 'android') {
        NativeModules.RNUsabilla.sendEvent(event)
    }
}

module.exports = {
    initialize,
    loadFeedbackForm,
    updateFragmentManager,
    reset,
    sendEvent
}