
import { NativeEventEmitter, NativeModules, Platform, DeviceEventEmitter } from 'react-native'
let {UsabillaBridge} = NativeModules
const usabillaEventEmitter = (Platform.OS == 'android') ? DeviceEventEmitter : new NativeEventEmitter(UsabillaBridge)

/* Usabilla SDK Functions */
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

function sendEvent(event) {
    UsabillaBridge.sendEvent(event)
}

function resetCampaignData(callback) {
    if (callback) {
        if (Platform.OS == 'ios') {
            UsabillaBridge.resetCampaignData(callback)
            return
        }

        console.warn("reset callback is only available iOS now")
        return
    }

    UsabillaBridge.resetCampaignData(()=> {
        console.log("campaign data is reset successfully")
    })
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
    showLoadedForm,
    sendEvent,
    resetCampaignData,
    setFormDidLoadSuccessfully,
    setFormDidFailLoading,
    setFormDidClose
}