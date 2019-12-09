import { NativeEventEmitter, NativeModules, Platform, DeviceEventEmitter } from 'react-native';
const UsabillaBridge = NativeModules.UsabillaInterface;
const usabillaEventEmitter = (Platform.OS == 'android') ? DeviceEventEmitter : new NativeEventEmitter(UsabillaBridge);

export default {
    
    initialize(appId) {
        if (Platform.OS == 'android') {
            usabillaEventEmitter.addListener(
                'UBFormNotFoundFragmentActivity',
                () => console.log("The Activity does not extend FragmentActivity and cannot call getSupportFragmentManager()")
            )
        }
        return UsabillaBridge.initialize(appId)
    },
    
    areNavigationButtonsVisible() {
        if (Platform.OS == 'android') {
            return UsabillaBridge.areNavigationButtonsVisible()
        } else {
            console.warn('areNavigationButtonsVisible is not available for iOS');
            return true
        }
    },
    
    setDefaultNavigationButtonsVisibility(visible) {
        if (Platform.OS == 'android') {
            return UsabillaBridge.setDefaultNavigationButtonsVisibility(visible)
        } else {
            console.warn('setDefaultNavigationButtonsVisibility is not available for iOS');
        }
    },
    
    /**
     * This method will load the feedback with no screenshot attachement
     * @param {String} formId : feedback form Id
     */
    loadFeedbackForm(formId) {
        return UsabillaBridge.loadFeedbackForm(formId)
    },
    
    /**
     * This method will load the feedback form and attach 
     * the current view screenshot to it.
     * @param {String} formId : feedback form Id
     */
    loadFeedbackFormWithCurrentViewScreenshot(formId) {
        return UsabillaBridge.loadFeedbackFormWithCurrentViewScreenshot(formId)
    },
    
    sendEvent(event) {
        return UsabillaBridge.sendEvent(event)
    },
    
    removeCachedForms() {
        return UsabillaBridge.removeCachedForms()
    },
    
    resetCampaignData(callback) {
        if (Platform.OS == 'android') {
            return UsabillaBridge.resetCampaignData()
        } else {
            if (callback) {
            return UsabillaBridge.resetCampaignData(callback)
                
            }
            return UsabillaBridge.resetCampaignData(()=> {
                console.log("Campaign data is successfully reset!")
            })
        }
    },
    
    showLoadedForm() {
        return UsabillaBridge.showLoadedFrom()
    },
    
    setCustomVariables(customVariables) {
        return UsabillaBridge.setCustomVariables(customVariables)
    },
    
    setFormDidLoadSuccessfully(callback) {
        return usabillaEventEmitter.addListener('UBFormLoadingSucceeded', callback)
    },
    
    setFormDidFailLoading(callback) {
        usabillaEventEmitter.addListener('UBFormLoadingFailed', callback)
    },
    
    setFormDidClose(callback) {
        if (Platform.OS == 'ios') {
            usabillaEventEmitter.addListener('UBFormDidClose', callback)
        }
    },
    
    setCampaignDidClose(callback) {
        if (Platform.OS == 'ios') {
            usabillaEventEmitter.addListener('UBCampaignDidClose', callback)
        }
    },
    
    dismiss() {
        UsabillaBridge.dismiss()
    },
    
    setDataMasking(masks, character) {
        UsabillaBridge.setDataMasking(masks, character)
    },
    
    getDefaultDataMasks() {
        return UsabillaBridge.DEFAULT_DATA_MASKS
    }
  };