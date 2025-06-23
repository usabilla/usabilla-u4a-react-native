package com.usabilla.reactnative.ubform;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.fragment.app.FragmentManager;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.Observer;
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
import com.usabilla.sdk.ubform.UsabillaReadyCallback;
import com.usabilla.sdk.ubform.UbConstants;
import com.usabilla.sdk.ubform.Usabilla;
import com.usabilla.sdk.ubform.sdk.form.FormClient;
import com.usabilla.sdk.ubform.sdk.entity.FeedbackResult;
import com.usabilla.sdk.ubform.sdk.form.FormType;
import com.usabilla.sdk.ubform.utils.ClosingFormData;
import android.graphics.drawable.Drawable;
import androidx.core.content.ContextCompat;
import com.usabilla.sdk.ubform.sdk.form.model.UbImages;
import com.usabilla.sdk.ubform.sdk.form.model.UsabillaTheme;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UsabillaBridge extends ReactContextBaseJavaModule implements UsabillaFormCallback, UsabillaReadyCallback, LifecycleEventListener {

    public static final String FRAGMENT_TAG = "passive form";

    private static final String LOG_TAG = "Usabilla React Bridge";
    private static final String DEFAULT_DATA_MASKS = "DEFAULT_DATA_MASKS";
    private static final String DEFAULT_MASK_CHARACTER = "X";
    private static final String KEY_RATING = "rating";
    private static final String KEY_ABANDONED_PAGE_INDEX = "abandonedPageIndex";
    private static final String KEY_SENT = "sent";
    private static final String KEY_ERROR_MSG = "error";
    private static final String KEY_SUCCESS_FLAG = "success";

    private Usabilla usabilla = Usabilla.INSTANCE;
    private Fragment form;


    private WritableMap getResult(FeedbackResult res) {
        final WritableMap result = Arguments.createMap();
        result.putInt(KEY_RATING, res.getRating());
        result.putInt(KEY_ABANDONED_PAGE_INDEX, res.getAbandonedPageIndex());
        result.putBoolean(KEY_SENT, res.isSent());
        return result;
    }

    private final Observer<ClosingFormData> closingObserver = closingFormData -> {
        if (closingFormData.getFormType().equals(FormType.PASSIVE_FEEDBACK)) {
            // The passive feedback form needs to be closed and the feedback result is returned
            final WritableMap result = getResult(closingFormData.getFeedbackResult());
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
        } else if (closingFormData.getFormType().equals(FormType.CAMPAIGN)) {
            // The campaign feedback form has been closed and the feedback result is returned
            final WritableMap result = getResult(closingFormData.getFeedbackResult());
            emitReactEvent(getReactApplicationContext(), "UBCampaignDidClose", result);
        }
    };


    /**
     * Called via the index.js to handle back press
     */
    @ReactMethod
    public void onBackPressed() {
        final Activity activity = getCurrentActivity();
        if (activity instanceof FragmentActivity) {
            FragmentManager supportFragmentManager = ((FragmentActivity) activity).getSupportFragmentManager();
            Fragment fragment = supportFragmentManager.findFragmentByTag(FRAGMENT_TAG);

            if (fragment != null) {
                supportFragmentManager.beginTransaction().remove(fragment).commit();
                final WritableMap result = Arguments.createMap();
                result.putInt(KEY_RATING, -1);
                result.putInt(KEY_ABANDONED_PAGE_INDEX, -1);
                result.putBoolean(KEY_SENT, false);
                emitReactEvent(getReactApplicationContext(), "UBFormDidClose", result);
            }
        }
    }

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
            usabilla.initialize(activity.getBaseContext(), appId, null, this::onUsabillaInitialized);
            usabilla.updateFragmentManager(((FragmentActivity) activity).getSupportFragmentManager());
            return;
        }
        Log.e(LOG_TAG, "Initialisation not possible. Android activity is null");
    }

    /**
     * Called via the index.js to set the debug mode
     */
    @ReactMethod
    public void setDebugEnabled(@NonNull final boolean debugEnabled) {
        usabilla.setDebugEnabled(debugEnabled);
    }

    /**
     * Called via the index.js to load a passive feedback form
     *
     * @param formId Id of the form desired to be loaded
     * @param selectedEmoticonImages Array of enabled emoticon images (optional, nullable ).
     * @param unselectedEmoticonImages Array of disabled emoticon images (optional, nullable).
     */
    @ReactMethod
    public void loadFeedbackForm(
        @NonNull final String formId,
        @Nullable final ReadableArray selectedEmoticonImages,
        @Nullable final ReadableArray unselectedEmoticonImages 
        ) {
        usabilla.loadFeedbackForm(formId, null, 
        createTheme(selectedEmoticonImages, unselectedEmoticonImages), this);
    }

    /**
     * Method called via the index.js to load a passive feedback form with a screenshot attached showing the current screen
     *
     * @param formId Id of the form desired to be loaded
     * @param selectedEmoticonImages Array of enabled emoticon images (optional, nullable ).
     * @param unselectedEmoticonImages Array of disabled emoticon images (optional, nullable).

     */
    @ReactMethod
    public void loadFeedbackFormWithCurrentViewScreenshot(
        @NonNull final String formId,
        @Nullable final ReadableArray selectedEmoticonImages,
        @Nullable final ReadableArray unselectedEmoticonImages
        ) {
        final Activity activity = getCurrentActivity();
        if (activity != null) {
            final Bitmap screenshot = usabilla.takeScreenshot(activity);
            usabilla.loadFeedbackForm(formId, screenshot, createTheme(selectedEmoticonImages, unselectedEmoticonImages), this);
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
        return usabilla.getDefaultNavigationButtonsVisibility();
    }

    /**
     * Called via the index.js to set the visibility of the standard navigation buttons
     */
    @ReactMethod
    public void setDefaultNavigationButtonsVisibility(@NonNull final boolean visible) {
        usabilla.setDefaultNavigationButtonsVisibility(visible);
    }

    /**
     * Called via the index.js to download passive forms and cache them
     */
    @ReactMethod
    public void preloadFeedbackForms(@NonNull final ReadableArray formIDs) {
        List<String> listformIDs = new ArrayList<>();
        for (int i = 0; i < formIDs.size(); i++) {
            listformIDs.add(formIDs.getString(i));
        }
        usabilla.preloadFeedbackForms(listformIDs);
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
    public void setDataMasking(final @Nullable ReadableArray masks, final @Nullable String character) {
        List<String> listMasks = null;
        if (masks == null) {
            listMasks = UbConstants.getDefaultDataMasks();
        } else {
            listMasks = new ArrayList<>(masks.size());
            for (int i = 0; i < masks.size(); i++) {
                listMasks.add(masks.getString(i));
            }
        }
        String maskChar = (character != null) ? character : DEFAULT_MASK_CHARACTER;
        usabilla.setDataMasking(listMasks, maskChar.charAt(0));
    }

    @Override
    public Map<String, Object> getConstants() {
        Map<String, Object> map = new HashMap<>();
        map.put(DEFAULT_DATA_MASKS, UbConstants.getDefaultDataMasks());
        return map;
    }

    @Override
    public void onHostResume() {
        final AppCompatActivity activity = (AppCompatActivity) getCurrentActivity();
        Usabilla.INSTANCE.getClosingData().observe((LifecycleOwner) activity, closingObserver);
    }

    @Override
    public void onHostPause() {
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

    @Override
    public void onUsabillaInitialized() {
        final WritableMap result = Arguments.createMap();
        result.putBoolean(KEY_SUCCESS_FLAG, true);
        emitReactEvent(getReactApplicationContext(), "isUBInitialised", result);
    }

    /**
     * Creates a UsabillaTheme with custom enabled and disabled emoticon images.
     *
     * @param selectedEmoticonImages Array of enabled emoticon image names (optional, nullable).
     * @param unselectedEmoticonImages Array of disabled emoticon image names (optional, nullable).
     * @return UsabillaTheme instance with custom emoticons
     */
    private UsabillaTheme createTheme( @Nullable final ReadableArray selectedEmoticonImages, 
    @Nullable final ReadableArray unselectedEmoticonImages) 
    {
        if ((selectedEmoticonImages == null || selectedEmoticonImages.size() == 0) 
        && (unselectedEmoticonImages == null || unselectedEmoticonImages.size() == 0) ) {
            return null;
            }
        // Convert ReadableArray to List<Integer>
        final Activity activity = getCurrentActivity();
        if (activity == null) {
            Log.e(LOG_TAG, "Loading feedback form with custom emoticons not possible. Android activity is null");
            return null;
        }
        Context context = getReactApplicationContext();
        List<Integer> selectedResIds = new ArrayList<>(); ;
        List<Integer> unselectedResIds = new ArrayList<>(); ;
        if (selectedEmoticonImages != null && selectedEmoticonImages.size() != 0)
        {  
            try {
                for (int i = 0; i < selectedEmoticonImages.size(); i++) {
                    String imageName = selectedEmoticonImages.getString(i);
                    int resId = context.getResources().getIdentifier(imageName, "drawable", context.getPackageName());
                    if (resId != 0) {
                        selectedResIds.add(resId);
                    }
                }
            } catch (Exception e) {
                Log.e(LOG_TAG, "Error while processing enabled emoticon images: " + e.getMessage());
            }
        }

        if (unselectedEmoticonImages != null && unselectedEmoticonImages.size() != 0) 
        {
            try {              
                for (int i = 0; i < unselectedEmoticonImages.size(); i++) {
                    String imageName = unselectedEmoticonImages.getString(i);
                    int resId = context.getResources().getIdentifier(imageName, "drawable", context.getPackageName());
                    if (resId != 0) {
                        unselectedResIds.add(resId);
                    }
                }
            } catch (Exception e) {
                Log.e(LOG_TAG, "Error while processing disabled emoticon images: " + e.getMessage());
            }
        }

        UbImages ubimages = new UbImages(selectedResIds, unselectedResIds, null, null);
        UsabillaTheme theme = new UsabillaTheme(null, ubimages);
        return theme;
    }
}
