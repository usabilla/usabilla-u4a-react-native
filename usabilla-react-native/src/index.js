import { NativeEventEmitter, NativeModules, Platform } from 'react-native';
let {UsabillaBridge} = NativeModules;
const UsabillaEventEmitter = new NativeEventEmitter(UsabillaBridge);

function sum(a, b) {
    return a + b;
}

/* Usabilla Sdk Functions */
function initialize(appId) {
    console.log("initialize")
    if (Platform.OS == 'ios') {
        console.log(NativeModules);
        UsabillaBridge.initialize(appId)
    }
}

function loadFeedbackForm(formId) {
    if (Platform.OS == 'ios') {
        UsabillaBridge.loadFeedbackForm(formId)
    }
}

function showLoadedForm(event) {
    console.log("showLoadedForm")
    UsabillaBridge.showLoadedFrom()
}

/* Delegate functions */
function setFormDidLoadSuccessfully(callback) {
    UsabillaEventEmitter.addListener(
        'UBFormLoadedSuccessfully',
        callback
    );
}

function setFormDidFailLoading(callback) {
    UsabillaEventEmitter.addListener(
        'UBFormFailedLoading',
        callback
    );
}

function setFormDidClose(callback) {
    UsabillaEventEmitter.addListener(
        'UBFormDidClose',
        callback    
    );
}

module.exports = {
    initialize,
    loadFeedbackForm,
    showLoadedForm,
    setFormDidLoadSuccessfully,
    setFormDidFailLoading,
    setFormDidClose,
    sum
}