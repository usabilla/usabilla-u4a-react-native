
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

function areNavigationButtonsVisible() {
    if (Platform.OS == 'android') {
        return UsabillaBridge.areNavigationButtonsVisible()
    } else {
        // iOS implementation
        return true
    }
}

function setDefaultNavigationButtonsVisibility(visible) {
    if (Platform.OS == 'android') {
        UsabillaBridge.setDefaultNavigationButtonsVisibility(visible)
    } else {
        // iOS implementation
    }
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

function sendEvent(event) {
    UsabillaBridge.sendEvent(event)
}

function removeCachedForms() {
    if (Platform.OS == 'android') {
        UsabillaBridge.removeCachedForms()
    } else {
        // iOS implementation
    }
}

function resetCampaignData(callback) {
    if (Platform.OS == 'android') {
        UsabillaBridge.resetCampaignData()
    } else {
        if (callback) {
            UsabillaBridge.resetCampaignData(callback)
            return
        }
        UsabillaBridge.resetCampaignData(()=> {
            console.log("Campaign data is successfully reset!")
        })
    }
}

function showLoadedForm() {
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
    areNavigationButtonsVisible,
    initialize,
    loadFeedbackForm,
    loadFeedbackFormWithCurrentViewScreenshot,
    removeCachedForms,
    resetCampaignData,
    sendEvent,
    setCustomVariables,
    setDefaultNavigationButtonsVisibility,
    setFormDidClose,
    setFormDidFailLoading,
    setFormDidLoadSuccessfully,
    showLoadedForm
}
