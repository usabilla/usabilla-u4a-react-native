package com.rnusabilla;

import android.content.Intent;
import android.support.v4.app.Fragment;

import com.facebook.react.ReactFragmentActivity;
import com.usabilla.reactnative.ubform.UsabillaBridge;

public class MainActivity extends ReactFragmentActivity {

    /**
     * Returns the name of the main component registered from JavaScript.
     * This is used to schedule rendering of the component.
     */
    @Override
    protected String getMainComponentName() {
        return "RNUsabilla";
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        final Fragment fragment = getSupportFragmentManager().findFragmentByTag(UsabillaBridge.FRAGMENT_TAG);
        // value 2 is REQUEST_CODE_PHOTO_PICK constant currently private in BaseForm.kt
        fragment.onActivityResult(2, resultCode, data);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        final Fragment fragment = getSupportFragmentManager().findFragmentByTag(UsabillaBridge.FRAGMENT_TAG);
        // value 1 is REQUEST_CODE_PERMISSION constant currently private in BaseForm.kt
        fragment.onRequestPermissionsResult(1, permissions, grantResults);
    }
}
