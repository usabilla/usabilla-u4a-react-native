package com.usabilla.reactnative.ubform;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.usabilla.sdk.ubform.UsabillaFormCallback;
import com.usabilla.sdk.ubform.UbConstants;
import com.usabilla.sdk.ubform.Usabilla;
import com.usabilla.sdk.ubform.sdk.form.FormClient;
import com.usabilla.sdk.ubform.sdk.entity.FeedbackResult;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UsabillaBridge extends ReactContextBaseJavaModule implements UsabillaFormCallback, LifecycleEventListener {

    public static final String FRAGMENT_TAG = "passive form";
    
    private static final String LOG_TAG = "Usabilla React Bridge";
    private static final String DEFAULT_DATA_MASKS = "DEFAULT_DATA_MASKS";
    
    private static final String KEY_RATING = "rating";
    private static final String KEY_ABANDONED_PAGE_INDEX = "abandonedPageIndex";
    private static final String KEY_SENT = "sent";
    private static final String KEY_ERROR_MSG = "error";
    private static final String KEY_SUCCESS_FLAG = "success";

    private Usabilla usabilla = Usabilla.INSTANCE;
    private Fragment form;

    private WritableMap getResult(Intent intent, String feedbackResultType) {
        final FeedbackResult res = intent.getParcelableExtra(feedbackResultType);
        final WritableMap result = Arguments.createMap();
        result.putInt(KEY_RATING, res.getRating());
        result.putInt(KEY_ABANDONED_PAGE_INDEX, res.getAbandonedPageIndex());
        result.putBoolean(KEY_SENT, res.isSent());
        return result;
    }

    private BroadcastReceiver closingFormReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            final WritableMap result = getResult(intent, FeedbackResult.INTENT_FEEDBACK_RESULT);
            final Activity activity = getCurrentActivity();
            if (activity instanceof FragmentActivity) {
                FragmentManager supportFragmentManager = ((FragmentActivity) activity).getSupportFragmentManager();
                Fragment fragment = supportFragmentManager.findFragmentByTag(FRAGMENT_TAG);

                if (fragment != null) {
                    supportFragmentManager.beginTransaction().remove(fragment).commit();
                }
                emitReactEvent(getReactApplicationContext(), "UBFormDidClose", result);
                return;
            }
            Log.e(LOG_TAG, "Android activity null when removing form fragment");
        }
    };

    private BroadcastReceiver closingCampaignReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            final WritableMap result = getResult(intent, FeedbackResult.INTENT_FEEDBACK_RESULT_CAMPAIGN);
            emitReactEvent(getReactApplicationContext(), "UBCampaignDidClose", result);
        }
    };

    @ReactMethod
    public String mainButtonTextArg = "mainButtonText";

    public UsabillaBridge(ReactApplicationContext reactContext) {
        super(reactContext);
        reactContext.addLifecycleEventListener(this);
    }

    @Override
    public String getName() {
        return "UsabillaBridge";
    }

    /**
     * Called via the index.js to initialise the Usabilla SDK
     *
     * @param appId Id of the app linked to campaigns
     */
    @ReactMethod
    public void initialize(@NonNull String appId) {
        final Activity activity = getCurrentActivity();
        if (activity != null) {  
            usabilla.initialize(activity.getBaseContext(), appId);
            usabilla.updateFragmentManager(((FragmentActivity) activity).getSupportFragmentManager());
            return;
        }
        Log.e(LOG_TAG, "Initialisation not possible. Android activity is null");
    }

    /**
     * Called via the index.js to load a passive feedback form
     *
     * @param formId Id of the form desired to be loaded
     */
    @ReactMethod
    public void loadFeedbackForm(@NonNull final String formId) {
        usabilla.loadFeedbackForm(formId, this);
    }

    /**
     * Method called via the index.js to load a passive feedback form with a screenshot attached showing the current screen
     *
     * @param formId Id of the form desired to be loaded
     */
    @ReactMethod
    public void loadFeedbackFormWithCurrentViewScreenshot(@NonNull final String formId) {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            final Bitmap screenshot = usabilla.takeScreenshot(activity);
            usabilla.loadFeedbackForm(formId, screenshot, this);
            return;
        }
        Log.e(LOG_TAG, "Loading feedback form not possible. Android activity is null");
    }

    /**
     * Called via the index.js to set the custom variables in the Usabilla SDK
     */
    @ReactMethod
    public void setCustomVariables(ReadableMap customVariables) {
        usabilla.setCustomVariables(customVariables.toHashMap());
    }

    /**
     * Called via the index.js to see if the navigation buttons are visible
     */
    @ReactMethod
    public boolean areNavigationButtonsVisible() {
        return usabilla.areNavigationButtonsVisible();
    }

    /**
     * Called via the index.js to set the visibility of the standard navigation buttons
     */
    @ReactMethod
    public void setDefaultNavigationButtonsVisibility(@NonNull final boolean visible) {
        usabilla.setDefaultNavigationButtonsVisibility(visible);
    }

    /**
     * Called via the index.js to remove previously cached passive forms
     */
    @ReactMethod
    public void removeCachedForms() {
        usabilla.removeCachedForms();
    }

    /**
     * Called via the index.js to remove previously cached campaigns
     */
    @ReactMethod
    public void resetCampaignData() {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            usabilla.resetCampaignData(activity.getBaseContext());
            return;
        }
        Log.e(LOG_TAG, "Resetting Usabilla campaigns is not possible. Android activity is null");
    }

    /**
     * Called via the index.js to send an evnt to the Usabilla SDK
     */
    @ReactMethod
    public void sendEvent(@NonNull final String eventName) {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            usabilla.sendEvent(activity.getBaseContext(), eventName);
            return;
        }
        Log.e(LOG_TAG, "Sending event to Usabilla is not possible. Android activity is null");
    }

    /**
     * Called via the index.js to remove from the view the Usabilla form
     */
    @ReactMethod
    public boolean dismiss() {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            return usabilla.dismiss(activity.getBaseContext());
        }
        Log.e(LOG_TAG, "Dismissing the Usabilla form is not possible. Android activity is null");
        return false;
    }

    /**
     * Called via the index.js to mask sensitive information from the feedback before sending it
     */
    @ReactMethod
    public void setDataMasking(@NonNull final ReadableArray masks, @NonNull final String character) {
        List<String> listMasks = new ArrayList<>();
        for (int i = 0; i < masks.size(); i++) {
            listMasks.add(masks.getString(i));
        }
        usabilla.setDataMasking(listMasks, character.charAt(0));
    }

    @Override
    public Map<String, Object> getConstants() {
        Map<String, Object> map = new HashMap<>();
        map.put(DEFAULT_DATA_MASKS, UbConstants.getDefaultDataMasks());
        return map;
    }

    @Override
    public void onHostResume() {
        LocalBroadcastManager.getInstance(getReactApplicationContext()).registerReceiver(closingFormReceiver, new IntentFilter(UbConstants.INTENT_CLOSE_FORM));
        LocalBroadcastManager.getInstance(getReactApplicationContext()).registerReceiver(closingCampaignReceiver, new IntentFilter(UbConstants.INTENT_CLOSE_CAMPAIGN));
    }

    @Override
    public void onHostPause() {
        LocalBroadcastManager.getInstance(getReactApplicationContext()).unregisterReceiver(closingFormReceiver);
        LocalBroadcastManager.getInstance(getReactApplicationContext()).unregisterReceiver(closingCampaignReceiver);
    }

    @Override
    public void onHostDestroy() {
        // do nothing
    }

    @Override
    public void formLoadSuccess(FormClient formClient) {
        form = formClient.getFragment();
        final Activity activity = getCurrentActivity();
        if (activity instanceof FragmentActivity && form != null) {
            ((FragmentActivity) activity).getSupportFragmentManager().beginTransaction().replace(android.R.id.content, form, FRAGMENT_TAG).commit();
            form = null;
            final WritableMap result = Arguments.createMap();
            result.putBoolean(KEY_SUCCESS_FLAG, true);
            emitReactEvent(getReactApplicationContext(), "UBFormLoadingSucceeded", result);
            return;
        }
        final WritableMap resultError = Arguments.createMap();
        resultError.putString(KEY_ERROR_MSG, "The form could not be shown because the activity doesn't extend from FragmentActivity");
        emitReactEvent(getReactApplicationContext(), "UBFormLoadingFailed", resultError);
    }

    @Override
    public void formLoadFail() {
        final WritableMap resultError = Arguments.createMap();
        resultError.putString(KEY_ERROR_MSG, "The form could not be loaded");
        emitReactEvent(getReactApplicationContext(), "UBFormLoadingFailed", resultError);
    }

    @Override
    public void mainButtonTextUpdated(String s) {
        final WritableMap args = Arguments.createMap();
        args.putString(mainButtonTextArg, s);
        emitReactEvent(getReactApplicationContext(), "MainButtonTextUpdated", args);
    }

    private void emitReactEvent(@NonNull ReactContext reactContext,
                                String eventName,
                                @Nullable WritableMap params) {
        reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }
}
