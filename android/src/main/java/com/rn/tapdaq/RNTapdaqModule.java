package com.rn.tapdaq;

import android.os.Handler;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.Button;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.tapdaq.sdk.STATUS;
import com.tapdaq.sdk.TMBannerAdView;
import com.tapdaq.sdk.Tapdaq;
import com.tapdaq.sdk.TapdaqConfig;
import com.tapdaq.sdk.*;
import com.tapdaq.sdk.adnetworks.TDMediatedNativeAd;
import com.tapdaq.sdk.common.TMAdError;
import com.tapdaq.sdk.common.TMBannerAdSizes;
import com.tapdaq.sdk.listeners.TMAdListener;


import static com.facebook.react.bridge.UiThreadUtil.runOnUiThread;



public class RNTapdaqModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private String TAG = this.getName();

    private String VERSION = "1.0.27";
    private String MY_BANNER_TAG = "818818818";



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
    public void  hideBanner(){


        // get banner by tag and destory
    }

    @ReactMethod
    public void loadAndShowInterstitial(String placement, final Promise promise) {
        try {
            final RNTapdaqModule self = this;
            Tapdaq.getInstance().loadInterstitial(getCurrentActivity(), placement, new RNTapdaqAdListener(this, placement) {
                @Override
                public void didLoad() {
                    super.didLoad();
                    log("Interstitial loaded: " + this.mPlacement);
                    if (this.getIsFulfilled()) {
                        return;
                    }
                    this.setFulfilled(Boolean.TRUE);
                    self.showInterstitial(this.mPlacement,promise);
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
    public void loadBannerForPlacementTagSize(String placement, int type,int x, int y, int width, int height,final Promise promise) {
        try {

            //TMBannerAdView ad = (TMBannerAdView) getCurrentActivity().findViewById(R.id.banner_ad);

            runOnUiThread(new Runnable() {

                @Override
                public void run() {

                    //  try{

                    ViewGroup layout = (ViewGroup) getReactApplicationContext().getCurrentActivity().findViewById(android.R.id.content);
                    final TMBannerAdView ad = new TMBannerAdView(getReactApplicationContext()); // Create ad view
                    //  ad.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
                    ad.setTag(MY_BANNER_TAG);

                    layout.addView(ad);
                    // Stuff that updates the UI


                    Button b = new Button(getReactApplicationContext());
                    b.setText("Button added dynamically!");
                    b.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
                    //b.setId(MY_BUTTON);
                    //b.setOnClickListener(getReactApplicationContext());
                    //  layout.addView(b);



                    //int bannerWidth = options.optInt(CDV_OPTS_BANNER_WIDTH);
                    // int bannerHeight = options.optInt(CDV_OPTS_BANNER_HEIGHT);
                    //   TDBanner.Load(getCurrentActivity(), "default", 99, 99, new TMAdListener());
                    // Tapdaq.getInstance().

                    ad.load(getReactApplicationContext().getCurrentActivity(), TMBannerAdSizes.STANDARD, new TMAdListener());


                    promise.resolve(Boolean.TRUE);


                    //  }catch (Exception err) {
                    //    log(err.getMessage());
                    //     promise.reject(err.getMessage());
                    //   }

                }
            });


            promise.resolve(Boolean.TRUE);
        } catch (Exception err) {
            log(err.getMessage());
            promise.reject(err.getMessage());
        }
    }
    @ReactMethod
    public void loadBannerForPlacementTag(String placement, final Promise promise) {
        try {



            //TMBannerAdView ad = (TMBannerAdView) getCurrentActivity().findViewById(R.id.banner_ad);

            runOnUiThread(new Runnable() {

                @Override
                public void run() {

                  //  try{

                        ViewGroup layout = (ViewGroup) getReactApplicationContext().getCurrentActivity().findViewById(android.R.id.content);
                        final TMBannerAdView ad = new TMBannerAdView(getReactApplicationContext()); // Create ad view
                      //  ad.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
                        ad.setTag(MY_BANNER_TAG);
                        layout.addView(ad);
                        // Stuff that updates the UI


                        Button b = new Button(getReactApplicationContext());
                        b.setText("Button added dynamically!");
                        b.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
                        //b.setId(MY_BUTTON);
                        //b.setOnClickListener(getReactApplicationContext());
                      //  layout.addView(b);



                        //int bannerWidth = options.optInt(CDV_OPTS_BANNER_WIDTH);
                       // int bannerHeight = options.optInt(CDV_OPTS_BANNER_HEIGHT);
                     //   TDBanner.Load(getCurrentActivity(), "default", 99, 99, new TMAdListener());
                       // Tapdaq.getInstance().

                           ad.load(getReactApplicationContext().getCurrentActivity(), TMBannerAdSizes.STANDARD, new TMAdListener());


                        promise.resolve(Boolean.TRUE);


                  //  }catch (Exception err) {
                    //    log(err.getMessage());
                   //     promise.reject(err.getMessage());
                 //   }

                }
            });


            promise.resolve(Boolean.TRUE);
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
    public void loadAndShowRewarded(final String placement, final Promise promise) {
        try {
            Boolean ready = Tapdaq.getInstance().isRewardedVideoReady(getCurrentActivity(), placement);
            if (ready) {
                promise.resolve(Boolean.TRUE);
                return;
            }
            final RNTapdaqModule self = this;
            Tapdaq.getInstance().loadRewardedVideo(getCurrentActivity(), placement, new RNTapdaqAdListener(this, placement) {
                @Override
                public void didLoad() {
                    super.didLoad();
                    if (this.getIsFulfilled()) {
                        return;
                    }
                    this.setFulfilled(Boolean.TRUE);
                    self.showRewardedVideo(this.mPlacement,promise);
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
