import { NativeEventEmitter, Platform, DeviceEventEmitter } from 'react-native';
import NativeUsabillaBridge from './NativeUsabillaBridge';

/**
 * Usabilla React Native JS API
 * @see types in index.d.ts
 */
const rnUsabilla = NativeUsabillaBridge;
const usabillaEventEmitter = Platform.OS === 'android'
    ? DeviceEventEmitter
    : new NativeEventEmitter(rnUsabilla);

const UsabillaReactNative = {
    /**
     * Initialize Usabilla SDK
     * @param {string} appId
     * @returns {Promise<void>|void}
     */
    initialize(appId) {
        if (Platform.OS === 'android') {
            usabillaEventEmitter.addListener(
                'UBFormNotFoundFragmentActivity',
                () => console.log('The Activity does not extend FragmentActivity and cannot call getSupportFragmentManager()')
            );
        }
        return rnUsabilla.initialize(appId);
    },

    setDebugEnabled(debugEnabled) {
        return rnUsabilla.setDebugEnabled(debugEnabled);
    },

    onBackPressed() {
        if (Platform.OS === 'android') {
            return rnUsabilla.onBackPressed();
        } else {
            console.warn('onBackPressed is not available for iOS');
            return true;
        }
    },

    /**
     * Returns a Promise<boolean> on Android.
     * Always use as async/await.
     */
    async areNavigationButtonsVisible() {
        if (Platform.OS === 'android') {
            return await rnUsabilla.areNavigationButtonsVisible();
        } else {
            console.warn('areNavigationButtonsVisible is not available for iOS');
            return true;
        }
    },
    
    setDefaultNavigationButtonsVisibility(visible) {
        if (Platform.OS === 'android') {
            return rnUsabilla.setDefaultNavigationButtonsVisibility(visible);
        } else {
            console.warn('setDefaultNavigationButtonsVisibility is not available for iOS');
        }
    },

    /**
     * This method will load the localisation string file with all the properties
     * @param {String} localizedStringFile : custom string file name
     */
    loadLocalizedStringFile(localizedStringFile) {
        if (Platform.OS === 'ios') {
            return rnUsabilla.loadLocalizedStringFile(localizedStringFile);
        } else {
            console.warn('loadLocalizedStringFile is not available for android');
        }
    },
    
    /**
     * This method will load the feedback with no screenshot attachement
     * @param {String} formId : feedback form Id
     * @param selectedEmoticonImages Array of enabled emoticon images names (optional, nullable).
     * @param unselectedEmoticonImages Array of disabled emoticon images names(optional, nullable).
     */
    loadFeedbackForm(formId, selectedEmoticonImages, unselectedEmoticonImages) {
        return rnUsabilla.loadFeedbackForm(formId, selectedEmoticonImages, unselectedEmoticonImages);
    },
    
    /**
     * This method will load the feedback form and attach 
     * the current view screenshot to it.
     * @param {String} formId : feedback form Id
     * @param selectedEmoticonImages Array of enabled emoticon images names (optional, nullable).
     * @param unselectedEmoticonImages Array of disabled emoticon images names(optional, nullable).
     */
    loadFeedbackFormWithCurrentViewScreenshot(formId, selectedEmoticonImages, unselectedEmoticonImages) {
        return rnUsabilla.loadFeedbackFormWithCurrentViewScreenshot(formId, selectedEmoticonImages, unselectedEmoticonImages);
    },
    
    /**
     * This method will pre load the feedback forms and 
     * with no screenshot attachement
     * @param {Array} formIds : feedback form Ids
     */

    preloadFeedbackForms(formIds) {
        return rnUsabilla.preloadFeedbackForms(formIds);
    },

    removeCachedForms() {
        return rnUsabilla.removeCachedForms();
    },

    sendEvent(event) {
        return rnUsabilla.sendEvent(event);
    },
    
    resetCampaignData(callback) {
        if (Platform.OS === 'android') {
            return rnUsabilla.resetCampaignData();
        } else {
            if (callback) {
                return rnUsabilla.resetCampaignData(callback);
            }
            return rnUsabilla.resetCampaignData(() => {
                console.log('Campaign data is successfully reset!');
            });
        }
    },
    
    setCustomVariables(customVariables) {
        return rnUsabilla.setCustomVariables(customVariables);
    },
    
    setFormDidLoadSuccessfully(callback) {
        return usabillaEventEmitter.addListener('UBFormLoadingSucceeded', callback);
    },
    
    setFormDidFailLoading(callback) {
        return usabillaEventEmitter.addListener('UBFormLoadingFailed', callback);
    },
    
    setFormDidClose(callback) {
        return usabillaEventEmitter.addListener('UBFormDidClose', callback);
    },
    
    setCampaignDidClose(callback) {
        return usabillaEventEmitter.addListener('UBCampaignDidClose', callback);
    },
    
    /**
     * Dismisses the form. Returns a Promise<boolean> on Android.
     * Always use as async/await.
     */
    async dismiss() {
        if (Platform.OS === 'android') {
            return await rnUsabilla.dismiss();
        } else {
            rnUsabilla.dismiss();
        }
    },
    
    setDataMasking(masks, character) {
        rnUsabilla.setDataMasking(masks, character);
    },
    
    getDefaultDataMasks() {
        return rnUsabilla.DEFAULT_DATA_MASKS;
    },
    
    isUBInitialised(callback) {
        if (Platform.OS === 'android') {
            return usabillaEventEmitter.addListener('isUBInitialised', callback);
        } else {
            console.warn('isUBInitialised is not available for iOS');
        }
    }
};

export default UsabillaReactNative;