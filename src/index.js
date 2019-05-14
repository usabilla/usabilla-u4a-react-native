
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
        console.warn('areNavigationButtonsVisible is not available for iOS');
        return true
    }
}

function setDefaultNavigationButtonsVisibility(visible) {
    if (Platform.OS == 'android') {
        UsabillaBridge.setDefaultNavigationButtonsVisibility(visible)
    } else {
        console.warn('setDefaultNavigationButtonsVisibility is not available for iOS');
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
    UsabillaBridge.removeCachedForms()
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

function dismiss() {
    UsabillaBridge.dismiss()
}

function setDataMasking(masks, character) {
    UsabillaBridge.setDataMasking(masks, character)
}

module.exports = {
    areNavigationButtonsVisible,
    dismiss,
    initialize,
    loadFeedbackForm,
    loadFeedbackFormWithCurrentViewScreenshot,
    removeCachedForms,
    resetCampaignData,
    sendEvent,
    setCustomVariables,
    setDataMasking,
    setDefaultNavigationButtonsVisibility,
    setFormDidClose,
    setFormDidFailLoading,
    setFormDidLoadSuccessfully,
    showLoadedForm
}
