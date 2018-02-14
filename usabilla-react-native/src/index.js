
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

function loadFeedbackForm(formId) {
    UsabillaBridge.loadFeedbackForm(formId)
}

function showLoadedForm(event) {
    UsabillaBridge.showLoadedFrom()
}

function setCustomVariables(customVariables) {
    UsabillaBridge.setCustomVariables(customVariables)
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
    showLoadedForm,
    setCustomVariables,
    setFormDidClose,
    setFormDidFailLoading,
    setFormDidLoadSuccessfully,
}
