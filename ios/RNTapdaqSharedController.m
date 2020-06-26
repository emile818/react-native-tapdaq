//
//  RNTapdaqSharedController.m
//  RNTapdaq
//
//  Created by Giedrius Mikoliunas on 2020-01-12.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "RNTapdaqSharedController.h"
#define VERSION @"1.0.27"
#define MY_BANNER_TAG 818818818

@interface RNTapdaqSharedController ()

@end

@implementation RNTapdaqSharedController

static RNTapdaqSharedController *rnTapdaqSharedController = nil;

+ (RNTapdaqSharedController *)sharedController {
    if (rnTapdaqSharedController == nil) {
        rnTapdaqSharedController = [[super alloc] init];
    }
    return rnTapdaqSharedController;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[Tapdaq sharedSession] setDelegate:self];
        self.nativeDelegates = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Note: This view does not load
}


- (NSString*)versionIOS {
    return VERSION;
}

- (void)tapDelegate:(NSString *)message {
    if (_delegate && [_delegate respondsToSelector:@selector(onControllerMessage:)]) {
        [_delegate onControllerMessage:message];
    }
}

- (void)addNativeDelegate:(id<AdNativeDelegate>)delegate ofPlacementTag:(NSString *)placement {
    if ([[_nativeDelegates allKeys] containsObject:placement]) {
        NSMutableArray *target = [_nativeDelegates objectForKey:placement];
        [target addObject:delegate];
        return;
    }
    NSMutableArray *newArr = [NSMutableArray new];
    [newArr addObject:delegate];
    [_nativeDelegates setObject:newArr forKey:placement];
}

- (void)informNativeDelegate:(TDAdRequest *)adRequest {
    TDNativeAdRequest *nativeAdRequest = (TDNativeAdRequest *)adRequest;
    NSMutableArray<id<AdNativeDelegate>> *delegates = [_nativeDelegates objectForKey:adRequest.placement.tag];
    if (!delegates || [delegates count] == 0) {
        NSLog(@"Error! No delegates");
        return;
    }
    id<AdNativeDelegate> delegate = [delegates objectAtIndex:0];
    if (delegate && [delegate respondsToSelector:@selector(onNativeAd:)]) {
        [delegate onNativeAd:nativeAdRequest];
    }
    [delegates removeObjectAtIndex:0];
}

- (void)informNativeDelegate:(TDNativeAdRequest *)adRequest error:(TDError *)error {
    TDNativeAdRequest *nativeAdRequest = (TDNativeAdRequest *)adRequest;
    NSMutableArray<id<AdNativeDelegate>> *delegates = [_nativeDelegates objectForKey:adRequest.placement.tag];
    if (!delegates || [delegates count] == 0) {
        NSLog(@"Error! No delegates");
        return;
    }
    id<AdNativeDelegate> delegate = [delegates objectAtIndex:0];
    if (delegate && [delegate respondsToSelector:@selector(onNativeAd:)]) {
        [delegate onNativeAd:nativeAdRequest didFailToLoadWithError:error];
    }
    [delegates removeObjectAtIndex:0];
}

- (BOOL)isInitialized {
    return [[Tapdaq sharedSession] isInitialised];
}

- (void)initializeWithAppId:(NSString *)appId clientKey:(NSString *)clientKey properties:(TDProperties *)properties promise:(RNPromise *)promise {
    _initializationPromise = promise;
    [[Tapdaq sharedSession] setApplicationId:appId clientKey:clientKey properties:properties];
}

- (void)loadInterstitial:(NSString *)placement withPromise:(RNPromise *)promise {
    _adLoadPromise = promise;
    [[Tapdaq sharedSession] loadInterstitialForPlacementTag:placement delegate:self];
}

- (void)showInterstitial:(NSString *)placement withPromise:(RNPromise *)promise {
    _adDisplayPromise = promise;
    [[Tapdaq sharedSession] showInterstitialForPlacementTag:placement];
}

-(void)hideBanner{
    NSLog(@"hideBanner");

   // if(_isBannerShowed){

        UIView *removeView  =  [[[UIApplication sharedApplication] delegate].window.rootViewController.view viewWithTag:MY_BANNER_TAG];
        if(removeView != nil){
            [removeView removeFromSuperview];
        }

        //_isBannerShowed = false;


   // }
}
- (void)loadBannerForPlacementTag:(NSString *)placement withPromise:(RNPromise *)promise {
    _adDisplayPromise = promise;

    /*
     TDMBannerStandard,  0
    TDMBannerLarge, 1
    TDMBannerMedium, 2
    TDMBannerFull, 3
    TDMBannerLeaderboard, 4
    TDMBannerSmart, 5
    TDMBannerCustom 6
     */
    if(_type == 6){
          [[Tapdaq sharedSession] loadBannerForPlacementTag:placement targetSize:CGSizeMake(_width, _height) delegate:self];
    }else if(_type == 5){
          [[Tapdaq sharedSession] loadBannerForPlacementTag:placement withSize:TDMBannerSmart delegate:self];
    }else if(_type == 4){
          [[Tapdaq sharedSession] loadBannerForPlacementTag:placement withSize:TDMBannerLeaderboard delegate:self];
    }else if(_type == 3){
          [[Tapdaq sharedSession] loadBannerForPlacementTag:placement withSize:TDMBannerFull delegate:self];
    }else if(_type == 2){
          [[Tapdaq sharedSession] loadBannerForPlacementTag:placement withSize:TDMBannerMedium delegate:self];
    }else if(_type == 1){
          [[Tapdaq sharedSession] loadBannerForPlacementTag:placement withSize:TDMBannerLarge delegate:self];
    }else{
          [[Tapdaq sharedSession] loadBannerForPlacementTag:placement withSize:TDMBannerStandard delegate:self];
    }


}


- (void)loadRewardedVideo:(NSString *)placement withPromise:(RNPromise *)promise {
    _adLoadPromise = promise;
    [[Tapdaq sharedSession] loadRewardedVideoForPlacementTag:placement delegate:self];
}

- (void)showRewardedVideo:(NSString *)placement promise:(RNPromise *)promise {
  _adDisplayPromise = promise;
    [[Tapdaq sharedSession] showRewardedVideoForPlacementTag:placement];
}
- (void)loadAndShowStaticVideo:(NSString *)placement promise:(RNPromise *)promise {
_adDisplayPromise = promise;
   [[Tapdaq sharedSession] loadVideoForPlacementTag:placement delegate:self];
  //   [[Tapdaq sharedSession] showVideoForPlacementTag:placement delegate:self atPosition:TDBANER inView:<#(UIView *)#>
}

- (void)loadAndShowNative:(NSString *)placement  promise:(RNPromise *)promise {
 _adDisplayPromise = promise;
    [[Tapdaq sharedSession] loadNativeAdInViewController:self placementTag:placement options:TDMediatedNativeAdOptionsAdChoicesTopLeft delegate:self];


}
- (void)didLoadNativeAdRequest:(TDNativeAdRequest *)adRequest {
   // if ([adRequest.placement.tag isEqualToString:@"my_native_tag"]) {

    NSLog(@"ddd %@",adRequest.nativeAd.title);
       // self.titleLabel.text = adRequest.nativeAd.title;
       // self.subtitleLabel.text = adRequest.nativeAd.subtitle;
       // self.bodyLabel.text = adRequest.nativeAd.body;
    //}
      [adRequest.nativeAd trackImpression];
}

- (void)presentDebugViewController {
    [[Tapdaq sharedSession] presentDebugViewController];
}



- (BOOL)isInterstitialReadyForPlacementTag:(NSString *)placementTag {
    return [[Tapdaq sharedSession] isInterstitialReadyForPlacementTag:placementTag];
}

- (BOOL)isRewardedVideoReadyForPlacementTag:(NSString *)placementTag {
    return [[Tapdaq sharedSession] isRewardedVideoReadyForPlacementTag:placementTag];
}

- (void)setConsentGiven:(BOOL)value {
    [[Tapdaq sharedSession] setIsConsentGiven:value];
}

- (void)setIsAgeRestrictedUser:(BOOL)value {
    [[Tapdaq sharedSession] setIsAgeRestrictedUser:value];
}

- (void)setUserSubjectToGDPR:(BOOL)value {
    [[Tapdaq sharedSession] setUserSubjectToGDPR:value ? TDSubjectToGDPRYes : TDSubjectToGDPRNo];
}

- (void)setUserId:(NSString *)userId {
    [[Tapdaq sharedSession] setUserId:userId];
}

- (void)didLoadConfig {
    [self tapDelegate:@"Tapdaq initialized"];
    [_initializationPromise resolve];
}

- (void)didFailToLoadConfigWithError:(NSError *)error {
    [self tapDelegate:error.localizedDescription];
    [_initializationPromise reject:error];
}

- (void)didLoadAdRequest:(TDAdRequest *)adRequest {
    [self tapDelegate:@"Ad did load"];
    if ([adRequest isKindOfClass:[TDBannerAdRequest class]]) {
        UIView* bannerView = [(TDBannerAdRequest *)adRequest bannerView];
        // Place it at the bottom
        [bannerView setFrame:CGRectMake(
            (self.view.frame.size.width-bannerView.frame.size.width)/2,
            self.view.frame.size.height-bannerView.frame.size.height,
            bannerView.frame.size.width,
            bannerView.frame.size.height
        )];




        if(_xPosition>-1){
          bannerView.frame= CGRectMake(_xPosition,_yPosition, _width,_height);
        }

        //bannerView.frame= CGRectMake(bannerView.frame.origin.x,bannerView.frame.origin.y-100, bannerView.frame.size.width,bannerView.frame.size.height);

        bannerView.tag=MY_BANNER_TAG;

        _isBannerShowed = true;
        [[[UIApplication sharedApplication] delegate].window.rootViewController.view addSubview:bannerView];

    }else
    if (adRequest.placement.adUnit == TDMediatedNativeAdViewTypeUnknown) {
        [self informNativeDelegate:adRequest];
        return;
    }
    if (adRequest.placement.adUnit == TDUnitMediatedNative) {
        [self informNativeDelegate:adRequest];
        return;
    }
    [_adLoadPromise resolve];
}

- (void)adRequest:(TDAdRequest *)adRequest didFailToLoadWithError:(TDError *)error {
    if (adRequest.placement.adUnit == TDMediatedNativeAdViewTypeUnknown) {
        [self informNativeDelegate:adRequest error:error];
        return;
    }
    [self tapDelegate:error.localizedDescription];
    [_adLoadPromise reject:error];
}

- (void)didDisplayAdRequest:(TDAdRequest *)adRequest {
    [self tapDelegate:@"Ad did display"];
    if (adRequest.placement.adUnit == TDMediatedNativeAdViewTypeUnknown) return;
    [_adDisplayPromise resolve];
}

- (void)adRequest:(TDAdRequest *)adRequest didFailToDisplayWithError:(TDError *)error {
    [self tapDelegate:error.localizedDescription];
    [_adDisplayPromise reject:error];
}

- (void)didCloseAdRequest:(TDAdRequest *)adRequest {
    [self tapDelegate:@"Ad Closed"];
}

- (void)didClickAdRequest:(TDAdRequest *)adRequest {
    [self tapDelegate:@"Ad Clicked"];
}

- (void)adRequest:(TDAdRequest *)adRequest didValidateReward:(TDReward *)reward {
    if (_delegate && [_delegate respondsToSelector:@selector(onRedeem:reward:)]) {
        [_delegate onRedeem:adRequest reward:reward];
    }
}

- (void)adRequest:(TDAdRequest *)adRequest didFailToValidateReward:(TDReward *)reward {
    if (_delegate && [_delegate respondsToSelector:@selector(onRedeemFailed:didFailToValidateReward:)]) {
        [_delegate onRedeemFailed:adRequest didFailToValidateReward:reward];
    }
}

@end
