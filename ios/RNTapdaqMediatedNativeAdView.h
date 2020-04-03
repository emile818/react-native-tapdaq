//
//  RNTapdaqMediatedNativeAdView.h
//  RNTapdaq
//
//  Created by Giedrius Mikoliunas on 2020-01-12.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import <React/RCTConvert.h>
#import "RNTapdaqSharedController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RNTapdaqMediatedNativeAdView : UIView <AdNativeDelegate>
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *body;
@property (strong, nonatomic) IBOutlet UIView *iconView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UIView *mediaView;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat margin;
@property (nonatomic) CGFloat topHeight;
@property (nonatomic) CGFloat middleHeight;
@property (nonatomic) CGFloat bottomHeight;
@property (nonatomic) CGFloat buttonWidth;
@property (nonatomic) CGFloat buttonHeight;
@property (strong, nonatomic) NSDictionary<NSString *, NSNumber *> *customLayout;

@property (nonatomic) BOOL loaded;
@property (strong, nonatomic) NSString *placement;
@property (nonatomic, copy) RCTBubblingEventBlock onCustomLoadStart;
@property (nonatomic, copy) RCTBubblingEventBlock onClick;
@property (nonatomic, copy) RCTBubblingEventBlock onCustomError;
@property (nonatomic, copy) RCTBubblingEventBlock onCustomLoad;
@property (nonatomic, copy) RCTBubblingEventBlock onDestroy;
@property (strong, nonatomic) TDNativeAdRequest *ad;

- (void)destroyAd;

- (void)playAd;

- (void)pauseAd;

- (void)populateAdView;

- (void)clearAdView;

@end

NS_ASSUME_NONNULL_END
