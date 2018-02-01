package com.reactnativepoc;

import android.app.Activity;
import android.support.annotation.NonNull;
import android.support.v4.app.FragmentActivity;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.usabilla.sdk.ubform.Usabilla;

public class BridgeModule extends ReactContextBaseJavaModule {

    public BridgeModule(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return "BridgeModule";
    }

    @ReactMethod
    public void updateFragmentManager() {
        final Activity activity = getCurrentActivity();
        if (activity != null && activity instanceof FragmentActivity) {
            Usabilla.updateFragmentManager(((FragmentActivity) activity).getSupportFragmentManager());
        }
    }

    @ReactMethod
    public void initialize(@NonNull String appId) {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            Usabilla.initialize(activity.getBaseContext(), appId);
        }
    }

    @ReactMethod
    public void resetCampaignData() {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            Usabilla.resetCampaignData(activity.getBaseContext());
        }
    }

    @ReactMethod
    public void sendEvent(@NonNull String event) {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            Usabilla.sendEvent(activity.getBaseContext(), event);
        }
    }
}
