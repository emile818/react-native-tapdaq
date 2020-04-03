//
//  RNTapdaqMediatedNativeAdManager.m
//  RNTapdaq
//
//  Created by Giedrius Mikoliunas on 2020-01-12.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNTapdaqMediatedNativeAdManager.h"
#import <React/RCTViewManager.h>
#import <React/RCTConvert.h>
#import <React/RCTComponent.h>
#import <React/RCTUIManager.h>
#import <React/RCTLog.h>

@implementation RNTapdaqNativeAdManager

RCT_EXPORT_MODULE(TapdaqNativeAdView)

- (UIView *)view {
    RNTapdaqMediatedNativeAdView *adView = [[RNTapdaqMediatedNativeAdView alloc] init];
    return adView;
}

RCT_CUSTOM_VIEW_PROPERTY(layout, NSDictionary, RNTapdaqMediatedNativeAdView) {
    view.customLayout = [RCTConvert NSDictionary:json];
}

RCT_EXPORT_VIEW_PROPERTY(placement, NSString *);

RCT_EXPORT_VIEW_PROPERTY(onCustomLoadStart, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onClick, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onCustomError, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onCustomLoad, RCTBubblingEventBlock);

RCT_EXPORT_VIEW_PROPERTY(onDestroy, RCTBubblingEventBlock);

RCT_EXPORT_METHOD(destroyAd:(nonnull NSNumber*) reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,RNTapdaqMediatedNativeAdView *> *viewRegistry) {
        RNTapdaqMediatedNativeAdView *view = viewRegistry[reactTag];
        if (view && [view isKindOfClass:[RNTapdaqMediatedNativeAdView class]]) {
            [view destroyAd];
            return;
        }
        RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
    }];
}

RCT_EXPORT_METHOD(playAd:(nonnull NSNumber*) reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,RNTapdaqMediatedNativeAdView *> *viewRegistry) {
        RNTapdaqMediatedNativeAdView *view = viewRegistry[reactTag];
        if (view && [view isKindOfClass:[RNTapdaqMediatedNativeAdView class]]) {
            [view playAd];
            return;
        }
        RCTLogError(@"Cannot find NativeView with tag #%@", reactTag);
    }];
}

RCT_EXPORT_METHOD(pauseAd:(nonnull NSNumber*) reactTag) {
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,RNTapdaqMediatedNativeAdView *> *viewRegistry) {
        RNTapdaqMediatedNativeAdView *view = viewRegistry[reactTag];
        if (view && [view isKindOfClass:[RNTapdaqMediatedNativeAdView class]]) {
            [view pauseAd];
            return;
        }
    }];
}

@end
