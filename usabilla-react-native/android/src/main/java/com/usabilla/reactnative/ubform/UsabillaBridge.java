package com.usabilla.reactnative.ubform;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.LifecycleEventListener;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.usabilla.sdk.ubform.UBFeedbackForm;
import com.usabilla.sdk.ubform.Usabilla;
import com.usabilla.sdk.ubform.sdk.form.FormClient;

public class UsabillaBridge extends ReactContextBaseJavaModule implements UBFeedbackForm, LifecycleEventListener {

    private static final String LOG_TAG = "Usabilla React Bridge";
    private static final String FRAGMENT_TAG = "passive form";

    private Fragment form;

    private BroadcastReceiver closingFormReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            final Activity activity = getCurrentActivity();
            if (activity instanceof FragmentActivity) {
                ((FragmentActivity) activity).getSupportFragmentManager().beginTransaction().remove(form).commit();
                form = null;
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
        LocalBroadcastManager.getInstance(reactContext).registerReceiver(closingFormReceiver, new IntentFilter("com.usabilla.closeForm"));
    }

    @Override
    public String getName() {
        return "UsabillaBridge";
    }

    /**
     * Method called via the index.js to initialise the Usabilla SDK
     *
     * @param appId Id of the app linked to campaigns
     */
    @ReactMethod
    public void initialize(@NonNull String appId) {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            Usabilla.initialize(activity.getBaseContext(), appId);
            return;
        }
        Log.e(LOG_TAG, "Usabilla initialisation not possible. Android activity is null");
    }

    /**
     * Method called via the index.js to load a passive feedback form
     *
     * @param formId Id of the form desired to be loaded
     */
    @ReactMethod
    public void loadFeedbackForm(@NonNull String formId) {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            Usabilla.loadFeedbackForm(activity.getBaseContext(), formId, this);
            return;
        }
        Log.e(LOG_TAG, "Usabilla loading feedback form not possible. Android activity is null");
    }

    /**
     * Method used as hook from the App.js file, calling index.js to show the form previously downloaded
     */
    @ReactMethod
    public void showLoadedFrom() {
        final Activity activity = getCurrentActivity();
        if (activity instanceof FragmentActivity && form != null) {
            ((FragmentActivity) activity).getSupportFragmentManager().beginTransaction().replace(android.R.id.content, form, FRAGMENT_TAG).commit();
            return;
        }
        emitReactEvent(getReactApplicationContext(), "UBFormNotFoundFragmentActivity", Arguments.createMap());
    }

    @ReactMethod
    public void sendEvent(@NonNull final String eventName) {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            Usabilla.sendEvent(activity.getBaseContext(), eventName);
            return;
        }
        Log.e(LOG_TAG, "Sending event to Usabilla is not possible. Android activity is null");
    }

    @ReactMethod
    public void resetCampaignData() {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            Usabilla.resetCampaignData(activity.getBaseContext());
            return;
        }
        Log.e(LOG_TAG, "Resetting Usabilla campaigns is not possible. Android activity is null");
    }

    @Override
    public void onHostResume() {
        final Activity activity = getCurrentActivity();
        if (activity instanceof FragmentActivity) {
            Usabilla.updateFragmentManager(((FragmentActivity) activity).getSupportFragmentManager());
            return;
        }
        Log.e(LOG_TAG, "Usabilla could not set support fragment manager. Android activity is not a FragmentActivity");
    }

    @Override
    public void onHostPause() {
        // do nothing
    }

    @Override
    public void onHostDestroy() {
        LocalBroadcastManager.getInstance(getReactApplicationContext()).unregisterReceiver(closingFormReceiver);
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
