//
//  RNTapdaqSharedController.h
//  RNTapdaq
//
//  Created by Giedrius Mikoliunas on 2020-01-12.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Tapdaq/Tapdaq.h>
#import "RNPromise.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RNTapdaqSharedControllerDelegate <NSObject>

@required
- (void)onControllerMessage:(NSString *)message;

@optional
- (void)onRedeem:(TDAdRequest * _Nonnull)adRequest reward:(TDReward * _Nonnull)reward;
- (void)onRedeemFailed:(TDAdRequest * _Nonnull)adRequest didFailToValidateReward:(TDReward * _Nonnull)reward;

@end

@protocol AdNativeDelegate <NSObject>

@required
- (void)onNativeAd:(TDNativeAdRequest * _Nonnull)adRequest;
- (void)onNativeAd:(TDAdRequest *)adRequest didFailToLoadWithError:(TDError *)error;

@end

@interface RNTapdaqSharedController : UIViewController <TapdaqDelegate, TDAdRequestDelegate, TDClickableAdRequestDelegate, TDDisplayableAdRequestDelegate, TDRewardedVideoAdRequestDelegate>

@property (strong, nonatomic) RNPromise *initializationPromise;
@property (strong, nonatomic) RNPromise *adLoadPromise;
@property (strong, nonatomic) RNPromise *adDisplayPromise;
@property (strong, nonatomic) id<RNTapdaqSharedControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableDictionary<NSString *, id> *nativeDelegates;

+ (RNTapdaqSharedController *)sharedController;

- (BOOL)isInitialized;

- (void)initializeWithAppId:(NSString *)appId clientKey:(NSString *)clientKey properties:(TDProperties *)properties promise:(RNPromise *)promise;

- (void)loadInterstitial:(NSString *)placement withPromise:(RNPromise *)promise;

- (void)showInterstitial:(NSString *)placement withPromise:(RNPromise *)promise;

- (void)loadRewardedVideo:(NSString *)placement withPromise:(RNPromise *)promise;

- (void)showRewardedVideo:(NSString *)placement promise:(RNPromise *)promise;

- (void)loadNativeAd:(NSString *)placement;

- (void)tapDelegate:(NSString *)message;

- (void)addNativeDelegate:(id<AdNativeDelegate>)delegate ofPlacementTag:(NSString *)placement;

- (void)informNativeDelegate:(TDAdRequest *)adRequest;

- (void)informNativeDelegate:(TDAdRequest *)adRequest error:(TDError *)error;

- (void)presentDebugViewController;

- (BOOL)isInterstitialReadyForPlacementTag:(NSString *)placementTag;

- (BOOL)isRewardedVideoReadyForPlacementTag:(NSString *)placementTag;

- (void)setConsentGiven:(BOOL)value;

- (void)setIsAgeRestrictedUser:(BOOL)value;

- (void)setUserSubjectToGDPR:(BOOL)value;

- (void)setUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
