package com.rn.tapdaq;

import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.tapdaq.sdk.STATUS;
import com.tapdaq.sdk.Tapdaq;
import com.tapdaq.sdk.TapdaqConfig;
import com.tapdaq.sdk.adnetworks.TDMediatedNativeAd;
import com.tapdaq.sdk.common.TMAdError;

public class RNTapdaqModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private String TAG = this.getName();

    private static final String KEY_USER_SUBJECT_TO_GDPR = "userSubjectToGDPR";
    private static final String KEY_CONSENT_GIVEN = "consentGiven";
    private static final String KEY_IS_AGE_RESTRICTED_USER = "isAgeRestrictedUser";

    public RNTapdaqModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNTapdaq";
    }

    public void log(String message) {
        Log.d(TAG, message);
        getReactApplicationContext()
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("tapdaq", message);
    }

    public void logReward(WritableMap params) {
        Log.d(TAG, String.format("Reward: %s", params.toString()));
        getReactApplicationContext()
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("tapdaqReward", params);
    }

    @ReactMethod
    public void initialize(String applicationId, String clientKey, Promise promise) {
        new RNTapdaqInitializer(getCurrentActivity(), applicationId, clientKey, promise);
    }

    @ReactMethod
    public void initializeWithConfig(String applicationId, String clientKey, ReadableMap config, Promise promise) {
        TapdaqConfig tapdaqConfig = new TapdaqConfig();
        ReadableMapKeySetIterator iterator = config.keySetIterator();
        while (iterator.hasNextKey()) {
            String key = iterator.nextKey();
            Boolean value = config.getBoolean(key);
            switch (key) {
                case KEY_CONSENT_GIVEN:
                    tapdaqConfig.setConsentStatus(value ? STATUS.TRUE : STATUS.FALSE);
                    break;
                case KEY_IS_AGE_RESTRICTED_USER:
                    tapdaqConfig.setAgeRestrictedUserStatus(value ? STATUS.TRUE : STATUS.FALSE);
                    break;
                case KEY_USER_SUBJECT_TO_GDPR:
                    tapdaqConfig.setUserSubjectToGDPR(value ? STATUS.TRUE : STATUS.FALSE);
                    break;
                default:
                    Log.d(TAG, String.format("Unknown config key (%s) passed to initialize()", key));
            }
        }
        new RNTapdaqInitializer(getCurrentActivity(), applicationId, clientKey, tapdaqConfig, promise);
    }

    @ReactMethod
    public void isInitialized(Promise promise) {
        promise.resolve(Tapdaq.getInstance().IsInitialised());
    }

    @ReactMethod
    public void openTestControls() {
        Tapdaq.getInstance().startTestActivity(getCurrentActivity());
    }

    @ReactMethod
    public void setConsentGiven(Boolean value) {
        Tapdaq.getInstance().setContentGiven(getCurrentActivity(), value);
    }

    @ReactMethod
    public void setIsAgeRestrictedUser(Boolean value) {
        Tapdaq.getInstance().setIsAgeRestrictedUser(getCurrentActivity(), value);
    }

    @ReactMethod
    public void setUserSubjectToGDPR(Boolean value) {
        Tapdaq.getInstance().setUserSubjectToGDPR(getCurrentActivity(), value ? STATUS.TRUE : STATUS.FALSE);
    }

    @ReactMethod
    public void setUserId(String userId) {
        Tapdaq.getInstance().setUserId(getCurrentActivity(), userId);
    }

    @ReactMethod
    public void isInterstitialReady(String placement, final Promise promise) {
        try {
            Boolean ready = Tapdaq.getInstance().isInterstitialReady(getCurrentActivity(), placement);
            promise.resolve(ready);
        } catch (Exception err) {
            promise.reject(err.getMessage());
        }
    }

    @ReactMethod
    public void loadInterstitial(String placement, final Promise promise) {
        try {
            Tapdaq.getInstance().loadInterstitial(getCurrentActivity(), placement, new RNTapdaqAdListener(this, placement) {
                @Override
                public void didLoad() {
                    super.didLoad();
                    log("Interstitial loaded: " + this.mPlacement);
                    if (this.getIsFulfilled()) {
                        return;
                    }
                    this.setFulfilled(Boolean.TRUE);
                    promise.resolve(Boolean.TRUE);
                }

                @Override
                public void didLoad(TDMediatedNativeAd ad) {
                    super.didLoad(ad);
                    log("Ad " + this.mPlacement + " loaded");
                    if (this.getIsFulfilled()) {
                        return;
                    }
                    this.setFulfilled(Boolean.TRUE);
                    promise.resolve(Boolean.TRUE);
                }

                @Override
                public void didFailToLoad(TMAdError error) {
                    super.didFailToLoad(error);
                    log("Ad " + this.mPlacement + " did fail to load");
                    if (this.getIsFulfilled()) {
                        return;
                    }
                    this.setFulfilled(Boolean.TRUE);
                    promise.reject(error.getErrorMessage());
                }
            });
        } catch (Exception err) {
            log(err.getMessage());
            promise.reject(err.getMessage());
        }
    }

    @ReactMethod
    public void showInterstitial(final String placement, final Promise promise) {
        try {
            if (Tapdaq.getInstance().isInterstitialReady(getCurrentActivity(), placement)) {
                Tapdaq.getInstance().showInterstitial(getCurrentActivity(), placement, new RNTapdaqAdListener(this, placement) {
                    @Override
                    public void didDisplay() {
                        super.didDisplay();
                        if (this.getIsFulfilled()) {
                            return;
                        }
                        this.setFulfilled(Boolean.TRUE);
                        promise.resolve(Boolean.TRUE);
                    }
                    @Override
                    public void didFailToLoad(TMAdError error) {
                        super.didFailToLoad(error);
                        if (this.getIsFulfilled()) {
                            return;
                        }
                        this.setFulfilled(Boolean.TRUE);
                        promise.reject(error.getErrorMessage());
                    }
                });
            } else {
                promise.reject("Interstitial " + placement + " is not ready");
            }
        } catch (Exception err) {
            log(err.getMessage());
            promise.reject(err.getMessage());
        }
    }

    @ReactMethod
    public void isRewardedVideoReady(final String placement, final Promise promise) {
        try {
            Boolean ready = Tapdaq.getInstance().isRewardedVideoReady(getCurrentActivity(), placement);
            promise.resolve(ready);
        } catch (Exception err) {
            log(err.getMessage());
            promise.reject(err.getMessage());
        }
    }

    @ReactMethod
    public void loadRewardedVideo(final String placement, final Promise promise) {
        try {
            Boolean ready = Tapdaq.getInstance().isRewardedVideoReady(getCurrentActivity(), placement);
            if (ready) {
                promise.resolve(Boolean.TRUE);
                return;
            }
            Tapdaq.getInstance().loadRewardedVideo(getCurrentActivity(), placement, new RNTapdaqAdListener(this, placement) {
                @Override
                public void didLoad() {
                    super.didLoad();
                    if (this.getIsFulfilled()) {
                        return;
                    }
                    this.setFulfilled(Boolean.TRUE);
                    promise.resolve(Boolean.TRUE);
                }

                @Override
                public void didLoad(TDMediatedNativeAd ad) {
                    super.didLoad(ad);
                    if (this.getIsFulfilled()) {
                        return;
                    }
                    this.setFulfilled(Boolean.TRUE);
                    promise.resolve(Boolean.TRUE);
                }

                @Override
                public void didFailToLoad(TMAdError error) {
                    super.didFailToLoad(error);
                    if (this.getIsFulfilled()) {
                        return;
                    }
                    this.setFulfilled(Boolean.TRUE);
                    promise.reject(error.getErrorMessage());
                }
            });
        } catch (Exception err) {
            log(err.getMessage());
            promise.reject(err.getMessage());
        }
    }

    @ReactMethod
    public void showRewardedVideo(final String placement, final Promise promise) {
        try {
            if (Tapdaq.getInstance().isRewardedVideoReady(getCurrentActivity(), placement)) {
                Tapdaq.getInstance().showRewardedVideo(getCurrentActivity(), placement, new RNTapdaqAdListener(this, placement) {
                    @Override
                    public void didDisplay() {
                        super.didDisplay();
                        if (this.getIsFulfilled()) {
                            return;
                        }
                        this.setFulfilled(Boolean.TRUE);
                        promise.resolve(Boolean.TRUE);
                    }
                    @Override
                    public void didFailToLoad(TMAdError error) {
                        super.didFailToLoad(error);
                        if (this.getIsFulfilled()) {
                            return;
                        }
                        this.setFulfilled(Boolean.TRUE);
                        promise.reject(error.getErrorMessage());
                    }
                });
            } else {
                promise.reject("Rewarded video " + placement + " is not ready");
            }
        } catch (Exception err) {
            log(err.getMessage());
            promise.reject(err.getMessage());
        }
    }

}
