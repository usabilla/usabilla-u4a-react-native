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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UsabillaBridge extends ReactContextBaseJavaModule implements UsabillaFormCallback, LifecycleEventListener {

    public static final String FRAGMENT_TAG = "passive form";

    private static final String LOG_TAG = "Usabilla React Bridge";
    private static final String DEFAULT_DATA_MASKS = "DEFAULT_DATA_MASKS";

    private Usabilla usabilla = Usabilla.INSTANCE;
    private Fragment form;

    private BroadcastReceiver closingFormReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            final Activity activity = getCurrentActivity();
            if (activity instanceof FragmentActivity) {
                FragmentManager supportFragmentManager = ((FragmentActivity) activity).getSupportFragmentManager();
                if (supportFragmentManager.findFragmentByTag(FRAGMENT_TAG) != null) {
                    supportFragmentManager.popBackStack(FRAGMENT_TAG, FragmentManager.POP_BACK_STACK_INCLUSIVE);
                }
                return;
            }
            Log.e(LOG_TAG, "Android activity null when removing form fragment");
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
     * Hook from the App.js file calling index.js to show the form previously downloaded
     */
    @ReactMethod
    public void showLoadedFrom() {
        final Activity activity = getCurrentActivity();
        if (activity instanceof FragmentActivity && form != null) {
            ((FragmentActivity) activity).getSupportFragmentManager().beginTransaction().replace(android.R.id.content, form, FRAGMENT_TAG)
                    .addToBackStack(FRAGMENT_TAG).commit();
            form = null;
            return;
        }
        emitReactEvent(getReactApplicationContext(), "UBFormNotFoundFragmentActivity", Arguments.createMap());
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
    }

    @Override
    public void onHostPause() {
        LocalBroadcastManager.getInstance(getReactApplicationContext()).unregisterReceiver(closingFormReceiver);
    }

    @Override
    public void onHostDestroy() {
        // do nothing
    }

    @Override
    public void formLoadSuccess(FormClient formClient) {
        form = formClient.getFragment();
        emitReactEvent(getReactApplicationContext(), "UBFormLoadingSucceeded", Arguments.createMap());
    }

    @Override
    public void formLoadFail() {
        emitReactEvent(getReactApplicationContext(), "UBFormLoadingFailed", Arguments.createMap());
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
