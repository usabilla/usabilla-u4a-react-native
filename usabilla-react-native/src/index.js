
import { NativeEventEmitter, NativeModules, Platform, DeviceEventEmitter } from 'react-native'
let {UsabillaBridge} = NativeModules
const usabillaEventEmitter = (Platform.OS == 'android') ? DeviceEventEmitter : new NativeEventEmitter(UsabillaBridge)

/* Usabilla Sdk Functions */
function initialize(appId) {
    if (Platform.OS == 'android') {
        usabillaEventEmitter.addListener(
            'UBFormNotFoundFragmentActivity', 
            () => console.log("The Activity does not extend FragmentActivity and cannot call getSupportFragmentManager()")
        )
    }
    UsabillaBridge.initialize(appId)
}

/**
 * This method will load the feedback with no screenshot attachement
 * @param {String} formId : feedback form Id
 */
function loadFeedbackForm(formId) {
    UsabillaBridge.loadFeedbackForm(formId)
}

/**
 * This method will load the feedback form and attach 
 * the current view screenshot to it.
 * @param {String} formId : feedback form Id
 */
function loadFeedbackFormWithCurrentViewScreenshot(formId) {
    UsabillaBridge.loadFeedbackFormWithCurrentViewScreenshot(formId)
}

function showLoadedForm(event) {
    UsabillaBridge.showLoadedFrom()
}

function setFormDidLoadSuccessfully(callback) {
    usabillaEventEmitter.addListener('UBFormLoadingSucceeded', callback)
}

function setFormDidFailLoading(callback) {
    usabillaEventEmitter.addListener('UBFormLoadingFailed', callback)
}

function setFormDidClose(callback) {
    if (Platform.OS == 'ios') {
        usabillaEventEmitter.addListener('UBFormDidClose', callback)
    }
}

module.exports = {
    initialize,
    loadFeedbackForm,
    loadFeedbackFormWithCurrentViewScreenshot,
    showLoadedForm,
    setFormDidLoadSuccessfully,
    setFormDidFailLoading,
    setFormDidClose
}
