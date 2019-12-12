import { NativeEventEmitter, NativeModules, Platform, DeviceEventEmitter } from 'react-native';
const rnUsabilla = NativeModules.UsabillaBridge;
const usabillaEventEmitter = (Platform.OS == 'android') ? DeviceEventEmitter : new NativeEventEmitter(rnUsabilla);

export default {
    
    initialize(appId) {
        if (Platform.OS == 'android') {
            usabillaEventEmitter.addListener(
                'UBFormNotFoundFragmentActivity',
                () => console.log("The Activity does not extend FragmentActivity and cannot call getSupportFragmentManager()")
            )
        }
        return rnUsabilla.initialize(appId)
    },
    
    areNavigationButtonsVisible() {
        if (Platform.OS == 'android') {
            return rnUsabilla.areNavigationButtonsVisible()
        } else {
            console.warn('areNavigationButtonsVisible is not available for iOS');
            return true
        }
    },
    
    setDefaultNavigationButtonsVisibility(visible) {
        if (Platform.OS == 'android') {
            return rnUsabilla.setDefaultNavigationButtonsVisibility(visible)
        } else {
            console.warn('setDefaultNavigationButtonsVisibility is not available for iOS');
        }
    },
    
    /**
     * This method will load the feedback with no screenshot attachement
     * @param {String} formId : feedback form Id
     */
    loadFeedbackForm(formId) {
        return rnUsabilla.loadFeedbackForm(formId)
    },
    
    /**
     * This method will load the feedback form and attach 
     * the current view screenshot to it.
     * @param {String} formId : feedback form Id
     */
    loadFeedbackFormWithCurrentViewScreenshot(formId) {
        return rnUsabilla.loadFeedbackFormWithCurrentViewScreenshot(formId)
    },
    
    sendEvent(event) {
        return rnUsabilla.sendEvent(event)
    },
    
    removeCachedForms() {
        return rnUsabilla.removeCachedForms()
    },
    
    resetCampaignData(callback) {
        if (Platform.OS == 'android') {
            return rnUsabilla.resetCampaignData()
        } else {
            if (callback) {
            return rnUsabilla.resetCampaignData(callback)
                
            }
            return rnUsabilla.resetCampaignData(()=> {
                console.log("Campaign data is successfully reset!")
            })
        }
    },
    
    setCustomVariables(customVariables) {
        return rnUsabilla.setCustomVariables(customVariables)
    },
    
    setFormDidLoadSuccessfully(callback) {
        return usabillaEventEmitter.addListener('UBFormLoadingSucceeded', callback)
    },
    
    setFormDidFailLoading(callback) {
        usabillaEventEmitter.addListener('UBFormLoadingFailed', callback)
    },
    
    setFormDidClose(callback) {
        usabillaEventEmitter.addListener('UBFormDidClose', callback)
    },
    
    setCampaignDidClose(callback) {
        usabillaEventEmitter.addListener('UBCampaignDidClose', callback)
    },
    
    dismiss() {
        rnUsabilla.dismiss()
    },
    
    setDataMasking(masks, character) {
        rnUsabilla.setDataMasking(masks, character)
    },
    
    getDefaultDataMasks() {
        return rnUsabilla.DEFAULT_DATA_MASKS
    }

  };