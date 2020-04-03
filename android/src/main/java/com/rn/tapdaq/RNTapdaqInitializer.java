package com.rn.tapdaq;

import android.app.Activity;
import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.tapdaq.sdk.Tapdaq;
import com.tapdaq.sdk.TapdaqConfig;
import com.tapdaq.sdk.common.TMAdError;
import com.tapdaq.sdk.listeners.TMInitListener;

public class RNTapdaqInitializer {
    private Promise promise;

    RNTapdaqInitializer(Activity activity, String applicationId, String clientKey, Promise promise) {
        this.promise = promise;
        Tapdaq.getInstance().initialize(activity, applicationId, clientKey, null, new TapdaqInitListener());
    }

    RNTapdaqInitializer(Activity activity, String applicationId, String clientKey, TapdaqConfig config,
                        Promise promise) {
        this.promise = promise;
        Tapdaq.getInstance().initialize(activity, applicationId, clientKey, config, new TapdaqInitListener());
    }

    private class TapdaqInitListener extends TMInitListener {
        public void didInitialise() {
            super.didInitialise();
            promise.resolve(Boolean.TRUE);
        }

        @Override
        public void didFailToInitialise(TMAdError error) {
            super.didFailToInitialise(error);
            promise.reject(String.valueOf(error.getErrorCode()), error.getErrorMessage());
        }
    }
}
