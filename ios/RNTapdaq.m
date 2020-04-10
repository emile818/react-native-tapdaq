//
//  RNTapdaq.m
//  RNTapdaq
//
//  Created by Giedrius Mikoliunas on 2020-01-12.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "RNTapdaq.h"

@interface RNTapdaq()
    @property (nonatomic) BOOL hasListeners;
    @property (nonatomic) NSString *eventName;
    @property (nonatomic) NSString *keyUserSubjectToGDPR;
    @property (nonatomic) NSString *keyConsentGiven;
    @property (nonatomic) NSString *keyIsAgeRestrictedUser;
@end

@implementation RNTapdaq

RCT_EXPORT_MODULE()

-(id)init {
    self = [super init];
    if (self) {
        _eventName = @"tapdaq";
        _hasListeners = NO;
        _keyUserSubjectToGDPR = @"userSubjectToGDPR";
        _keyConsentGiven = @"consentGiven";
        _keyIsAgeRestrictedUser = @"isAgeRestrictedUser";
        [[RNTapdaqSharedController sharedController] setDelegate:self];
    }
    return self;
}

RCT_EXPORT_METHOD(initialize:(NSString *)applicationId
                  clientKey:(NSString *)clientKey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RNPromise *promise = [[RNPromise alloc] initWithResolver:resolve andRejector:reject];
    [[RNTapdaqSharedController sharedController] initializeWithAppId:applicationId clientKey:clientKey properties:TDProperties.defaultProperties promise:promise];
}

RCT_EXPORT_METHOD(initializeWithConfig:(NSString *)applicationId
                  clientKey:(NSString *)clientKey
                  config:(NSDictionary *)config
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    TDProperties *properties = [self getTDPropertiesFromDict:config];
    RNPromise *promise = [[RNPromise alloc] initWithResolver:resolve andRejector:reject];
    [[RNTapdaqSharedController sharedController] initializeWithAppId:applicationId clientKey:clientKey properties:properties promise:promise];
}

RCT_REMAP_METHOD(isInitialized,
                 findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject){
    BOOL isLoaded = [[RNTapdaqSharedController sharedController] isInitialized];
    resolve(@(isLoaded));
}

RCT_EXPORT_METHOD(openTestControls:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    [[RNTapdaqSharedController sharedController] presentDebugViewController];
    resolve(@(YES));
}

RCT_EXPORT_METHOD(setConsentGiven:(BOOL)value) {
    [[RNTapdaqSharedController sharedController] setConsentGiven:value];
}

RCT_EXPORT_METHOD(setIsAgeRestrictedUser:(BOOL)value) {
    [[RNTapdaqSharedController sharedController] setIsAgeRestrictedUser:value];
}

RCT_EXPORT_METHOD(setUserSubjectToGDPR:(BOOL)value) {
    [[RNTapdaqSharedController sharedController] setUserSubjectToGDPR:value];
}

RCT_EXPORT_METHOD(setUserId:(BOOL)value) {
    [[RNTapdaqSharedController sharedController] setUserSubjectToGDPR:value];
}

RCT_EXPORT_METHOD(isInterstitialReady:(NSString *)placement
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    BOOL isLoadEnabled = [[RNTapdaqSharedController sharedController] isInterstitialReadyForPlacementTag:placement];
    [self sendEvent:[NSString stringWithFormat:@"Interstitial %@ is ready:%d", placement, isLoadEnabled]];
    resolve(@(isLoadEnabled));
}

RCT_EXPORT_METHOD(loadInterstitial:(NSString *)placement
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RNPromise *promise = [[RNPromise alloc] initWithResolver:resolve andRejector:reject];
    [[RNTapdaqSharedController sharedController] loadInterstitial:placement withPromise:promise];
}



RCT_EXPORT_METHOD(showInterstitial:(NSString *)placement
                  findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RNPromise *promise = [[RNPromise alloc] initWithResolver:resolve andRejector:reject];
    [[RNTapdaqSharedController sharedController] showInterstitial:placement withPromise:promise];
}



RCT_EXPORT_METHOD(hideBanner:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    [[RNTapdaqSharedController sharedController] hideBanner];
    resolve(@(YES));
}



RCT_EXPORT_METHOD(versionIOS:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    [[RNTapdaqSharedController sharedController] versionIOS];
    resolve(@(YES));
}



RCT_EXPORT_METHOD(loadBannerForPlacementTag:(NSString *)placement
                  findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)  {
    RNPromise *promise = [[RNPromise alloc] initWithResolver:resolve andRejector:reject];
    [[RNTapdaqSharedController sharedController] setType:0];
    [[RNTapdaqSharedController sharedController] setXPosition:-1];
    [[RNTapdaqSharedController sharedController] loadBannerForPlacementTag:placement withPromise:promise];
}

RCT_EXPORT_METHOD(loadBannerForPlacementTagSize:(NSString *)placement type:(int)type x:(int) x y:(int) y width:(int) width height:(int) height
                  findEventsWithResolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)  {
    RNPromise *promise = [[RNPromise alloc] initWithResolver:resolve andRejector:reject];

    [[RNTapdaqSharedController sharedController] setType:type];
    [[RNTapdaqSharedController sharedController] setWidth:width];
    [[RNTapdaqSharedController sharedController] setHeight:height];
    [[RNTapdaqSharedController sharedController] setXPosition:x];
    [[RNTapdaqSharedController sharedController] setYPosition:y];
    [[RNTapdaqSharedController sharedController] loadBannerForPlacementTag:placement withPromise:promise];
}

// RCT_EXPORT_METHOD(showMessage:(NSString *)message color:(UIColor *)color backgroundColor:(UIColor *)backgroundColor)
RCT_EXPORT_METHOD(isRewardedVideoReady:(NSString *)placement
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    BOOL isLoadEnabled = [[RNTapdaqSharedController sharedController] isRewardedVideoReadyForPlacementTag:placement];
    [self sendEvent:[NSString stringWithFormat:@"Rewarded video %@ is ready:%d", placement, isLoadEnabled]];
    resolve(@(isLoadEnabled));
}

RCT_EXPORT_METHOD(loadRewardedVideo:(NSString *)placement
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){
    RNPromise *promise = [[RNPromise alloc] initWithResolver:resolve andRejector:reject];
    [[RNTapdaqSharedController sharedController] loadRewardedVideo:placement withPromise:promise];
}

RCT_EXPORT_METHOD(showRewardedVideo:(NSString *)placement
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    RNPromise *promise = [[RNPromise alloc] initWithResolver:resolve andRejector:reject];
    [[RNTapdaqSharedController sharedController] showRewardedVideo:placement promise:promise];
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}

- (TDProperties *)getTDPropertiesFromDict:(NSDictionary *)dict {
    TDProperties *properties = TDProperties.defaultProperties;
    NSArray *keys = @[_keyConsentGiven, _keyUserSubjectToGDPR, _keyIsAgeRestrictedUser];
    for (NSString *key in dict) {
        NSUInteger item = [keys indexOfObject:key];
        switch (item) {
            case 0:
                properties.isConsentGiven = dict[_keyConsentGiven];
                break;
            case 1:
                properties.userSubjectToGDPR = dict[_keyUserSubjectToGDPR] ? TDSubjectToGDPRYes : TDSubjectToGDPRNo;
                break;
            case 2:
                properties.isAgeRestrictedUser = dict[_keyIsAgeRestrictedUser];
            default:
                break;
        }
        [self sendEvent:[NSString stringWithFormat:@"properties: %@", properties]];
    }
    return properties;
}

- (NSString *)stringFromAdType:(TDAdUnit)adType {
    switch (adType) {
        case TDMediatedNativeAdViewTypeBody:
            return @"Static Interstitial";
        case TDMediatedNativeAdViewTypeMedia:
            return @"Rewarded Video";
        default:
            return @"Unknown";
    }
}

- (void)startObserving {
    _hasListeners = YES;
}

- (void)stopObserving {
    _hasListeners = NO;
}

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

- (NSArray<NSString *> *) supportedEvents {
    return @[_eventName];
}

- (void)sendEvent:(NSString*)body {
    if (_hasListeners) {
        [self sendEventWithName:_eventName body:body];
    }
}

-(void)onControllerMessage:(NSString *)message {
    [self sendEvent:message];
}

- (void)onRedeem:(TDAdRequest * _Nonnull)adRequest reward:(TDReward *)reward {
    [self sendEvent:[NSString stringWithFormat:@"Award|{\"source\": \"tapdaq\", \"eventId\": \"%@\", \"type\": \"%@\", \"name\": \"%@\", \"tag\": \"%@\", \"isValid\": %@, \"value\": %d, \"hashedUserId\": \"%@\"}", reward.eventId, [self stringFromAdType:adRequest.placement.adUnit], reward.name, adRequest.placement.tag, reward.isValid ? @"true" : @"false", reward.value, reward.hashedUserId]];
}

- (void)onRedeemFailed:(TDAdRequest * _Nonnull)adRequest didFailToValidateReward:(TDReward * _Nonnull)reward {
    [self sendEvent:[NSString stringWithFormat:@"Failed to validate reward for ad unit - %@ for tag - %@\nReward:\n    ID: %@\n    Name: %@\n    Amount: %i\n    Is valid: %@\n    Hashed user ID: %@\n    Custom JSON:\n%@", [self stringFromAdType:adRequest.placement.adUnit], adRequest.placement.tag, reward.rewardId, reward.name, reward.value, reward.isValid ? @"true" : @"false", reward.hashedUserId, reward.customJson]];
}

@end
