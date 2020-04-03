package com.rn.tapdaq;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.tapdaq.sdk.adnetworks.TDMediatedNativeAd;
import com.tapdaq.sdk.common.TMAdError;
import com.tapdaq.sdk.listeners.TMAdListener;
import com.tapdaq.sdk.model.rewards.TDReward;

public class RNTapdaqAdListener extends TMAdListener {
    private RNTapdaqModule mModule;
    public String mPlacement;
    private Boolean fulfilled = Boolean.FALSE;

    public Boolean getIsFulfilled() {
        return this.fulfilled;
    }

    public void setFulfilled(Boolean value) {
        this.fulfilled = value;
    }

    public RNTapdaqAdListener(RNTapdaqModule module, String placement) {
        mModule = module;
        mPlacement = placement;
    }

    @Override
    public void didLoad() {
        mModule.log("Ad " + mPlacement + " loaded");
    }

    @Override
    public void didLoad(TDMediatedNativeAd ad) {
        mModule.log("Ad " + mPlacement + " loaded 2");
        mModule.log(ad.toString());
    }

    @Override
    public void didRefresh() {
        mModule.log("Ad " + mPlacement + " refreshed");
    }

    @Override
    public void willDisplay() {
        mModule.log("Ad " + mPlacement + " will display");
    }

    @Override
    public void didDisplay() {
        mModule.log("Ad " + mPlacement + " did display");
    }

    @Override
    public void didFailToDisplay(TMAdError error) {
        mModule.log("Ad " + mPlacement + " did fail to display: " + error.getErrorMessage());
    }

    @Override
    public void didClick() {
        mModule.log("Ad " + mPlacement + " did click");
    }

    public void didClose() {
        mModule.log("Ad " + mPlacement + " did close");
    }

    @Override
    public void didFailToLoad(TMAdError error) {
        mModule.log("Ad " + mPlacement + " did fail to display");
        mModule.log(error.toString());
        mModule.log(error.getErrorMessage());
    }

    @Override
    public void didComplete() {
        mModule.log("Ad " + mPlacement + "did complete");
    }

    @Override
    public void didEngagement() {
        mModule.log("Ad " + mPlacement + "did engagement");
    }

    @Override
    public void didRewardFail(TMAdError error) {
        mModule.log("Ad " + mPlacement + "did reward fail");
        mModule.log(error.getErrorMessage());
        mModule.log(error.toString());
    }

    @Override
    public void onUserDeclined() {
        mModule.log("Ad " + mPlacement + " on User Declined");
    }

    @Override
    public void didVerify(TDReward reward) {
        String eventId = reward.getEventId();
        String name = reward.getName();
        String tag = reward.getTag();
        Object customJson = reward.getCustom_json();
        int value = reward.getValue();
        Boolean isValid = reward.isValid();
        String message = String.format(
            "Award|{\"source\": \"tapdaq\", \"eventId\": \"%1$s\", \"placement\": \"%2$s\", \"name\": \"%3$s\", \"tag\": \"%4$s\", \"isValid\": %5$s, \"value\": %6$s}",
            eventId,
            mPlacement,
            name,
            tag,
            isValid,
            value
        );
        mModule.log(message);
        WritableMap params = Arguments.createMap();
        params.putString("eventId", eventId);
        params.putString("name", name);
        params.putString("tag", tag);
        params.putInt("value", value);
        params.putString("customJson", customJson.toString());
        params.putBoolean("isValid", isValid);
        mModule.logReward(params);
    }

}
