//
//  RNTapdaqMediatedNativeAdView.m
//  RNTapdaq
//
//  Created by Giedrius Mikoliunas on 2020-01-12.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "RNTapdaqMediatedNativeAdView.h"

@implementation RNTapdaqMediatedNativeAdView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initAdView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initAdView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initAdView];
    }
    return self;
}

- (void)initAdView {
    _contentView = [[UIView alloc] init];
    _iconView = [[UIView alloc] init];
    _margin = 10;
    _topHeight = 40;
    _middleHeight = 200;
    _bottomHeight = 60;
    _buttonWidth = 150;
    _buttonHeight = 50;
}

- (void)setPlacement:(NSString *)placement {
    _loaded = NO;
    [[RNTapdaqSharedController sharedController] addNativeDelegate:self ofPlacementTag:placement];
    [[RNTapdaqSharedController sharedController] loadNativeAd:placement];
    [self clearAdView];
    if (self.onCustomLoadStart) {
        self.onCustomLoadStart(@{
            @"message": @"started"
        });
    }
}

- (void)setCustomLayout:(NSDictionary<NSString *,NSNumber *> *)customLayout {
    _customLayout = customLayout;
    NSNumber *margin = [_customLayout objectForKey:@"margin"];
    NSNumber *topHeight = [_customLayout objectForKey:@"topHeight"];
    NSNumber *middleHeight = [_customLayout objectForKey:@"middleHeight"];
    NSNumber *bottomHeight = [_customLayout objectForKey:@"bottomHeight"];
    NSNumber *buttonWidth = [_customLayout objectForKey:@"buttonWidth"];
    NSNumber *buttonHeight = [_customLayout objectForKey:@"buttonHeight"];
    if (margin) {
        _margin = [margin floatValue];
    }
    if (topHeight) {
        _topHeight = [topHeight floatValue];
    }
    if (middleHeight) {
        _middleHeight = [middleHeight floatValue];
    }
    if (bottomHeight) {
        _bottomHeight = [bottomHeight floatValue];
    }
    if (buttonWidth) {
        _buttonWidth = [buttonWidth floatValue];
    }
    if (buttonHeight) {
        _buttonHeight = [buttonHeight floatValue];
    }
    [self populateAdView];
}

- (void)onNativeAd:(TDNativeAdRequest *)adRequest {
    if (_loaded == YES) {
        if (self.onCustomError) {
            self.onCustomError(@{
            @"message": @"Ad is already loaded"
            });
        }
        return;
    }
    _loaded = YES;
    _ad = adRequest;
    [self populateAdView];
    TDMediatedNativeAd *ad = _ad.nativeAd;
    if (self.onCustomLoad) {
        self.onCustomLoad(@{
            @"title": ad.title,
            @"advertiser": ad.advertiser ? ad.advertiser : @(NO),
            @"body": ad.body,
            @"callToAction": ad.callToAction,
            @"caption": ad.caption ? ad.caption : @(NO),
            @"price": ad.price ? ad.price : @(NO),
            @"store": ad.store ? ad.store : @(NO),
            @"subtitle": ad.subtitle ? ad.subtitle : @(NO),
            @"videoUrl": @(NO),
            @"hasImages": ad.images.count > 0 ? @(YES) : @(NO),
            @"hasVideoContent": ad.mediaView ? @(YES) : @(NO),
            @"hasAdView": @(NO),
            @"hasMediaView": ad.mediaView ? @(YES) : @(NO),
            @"image": @{
              @"width": @(0),
              @"height": @(0),
              @"url": @(NO),
              @"type": @(NO)
            }
        });
    }
}

- (void)onNativeAd:(TDAdRequest *)adRequest didFailToLoadWithError:(TDError *)error {
    if (self.onCustomError) {
        self.onCustomError(@{ @"message": error.description });
    }
}

- (void)populateAdView {
    if (!_ad || !_loaded) {
        if (self.onCustomError) {
            self.onCustomError(@{ @"message": @"Ad is null" });
        }
        return;
    }

    [self clearAdView];

    // Title
    _title = [[UILabel alloc] initWithFrame:CGRectMake(_topHeight + _margin, 0, _width - (_topHeight + _margin), _topHeight)];
    _title.text = [_ad.nativeAd.title uppercaseString];
    [_title setFont:[UIFont fontWithName:@"GothamSSm-Bold" size:16]];
    _title.textColor = [UIColor whiteColor];

    [_contentView addSubview:_title];

    // Icon View
    if (_ad.nativeAd.iconView != nil) {
        UIView *iconView = _ad.nativeAd.iconView;
        CGRect frm = CGRectMake(0, 0, _topHeight, _topHeight);
        iconView.frame = frm;
        [_iconView addSubview:iconView];
        _iconView.frame = frm;
        _iconView.layer.masksToBounds = YES;
        _iconView.clipsToBounds = YES;
        _iconView.backgroundColor = [UIColor redColor];
        [_contentView addSubview:_iconView];
    }

    // Button
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button addTarget:self action:@selector(clickAd) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:[_ad.nativeAd.callToAction uppercaseString] forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor colorWithRed:1.00 green:0.12 blue:0.33 alpha:1.0];;
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont fontWithName:@"GothamSSm-Bold" size:16];
    _button.layer.cornerRadius = _buttonHeight / 2;

    // Image View
    TDNativeAdImage *image = [_ad.nativeAd.images objectAtIndex:0];
    if (image) {
        [image getAsyncImage:^(UIImage *adImage) {
          _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _topHeight + _margin, _width, _middleHeight)];
          [_imageView setImage:adImage];
          [_imageView setContentMode:UIViewContentModeScaleAspectFit];
          [_button setFrame:CGRectMake(_width - (_buttonWidth + _margin), _middleHeight - (_margin + _buttonHeight), _buttonWidth, _buttonHeight)];
          [_imageView addSubview:_button];
          [_contentView addSubview:_imageView];
        }];
    } else {
        if (self.onCustomError) {
            self.onCustomError(@{ @"message": @"Ad has no image" });
        }
        return;
    }

    // Body
    _body = [[UILabel alloc] initWithFrame:CGRectMake(0, _topHeight + (_margin * 2) + _middleHeight, _width, _bottomHeight)];
    _body.text = _ad.nativeAd.body;
    _body.lineBreakMode = NSLineBreakByWordWrapping;
    _body.numberOfLines = 0;
    [_body sizeToFit];
    _body.textColor = [UIColor whiteColor];
    [_body setFont:[UIFont fontWithName:@"GothamSSm-Book" size:14]];
    [_contentView addSubview:_body];

    // Redraw Content View
    [_contentView setNeedsDisplay];

    // Register views for Tapdaq
    [_ad.nativeAd setAdView:_contentView];
    [_ad.nativeAd registerView:_title type:TDMediatedNativeAdViewTypeHeadline];
    [_ad.nativeAd registerView:_body type:TDMediatedNativeAdViewTypeBody];
    [_ad.nativeAd registerView:_iconView type:TDMediatedNativeAdViewTypeLogo];
    [_ad.nativeAd registerView:_imageView type:TDMediatedNativeAdViewTypeImageView];
    [_ad.nativeAd registerView:_button type:TDMediatedNativeAdViewTypeCallToAction];
    if (_ad.nativeAd.mediaView && _mediaView) {
        [_ad.nativeAd registerView:_mediaView type:TDMediatedNativeAdViewTypeMedia];
    }
    [_ad.nativeAd trackImpression];
}

- (void)clickAd {
    if (self.onClick) {
        self.onClick(@{
            @"message": @"clicked"
        });
    }
}

- (void)clearAdView {
    [[_contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setNeedsDisplay];
}

- (void)destroyAd {
    [self clearAdView];
    _ad = nil;
    if (self.onDestroy) {
        self.onDestroy(@{
            @"message": @"destroyed"
        });
    }
}

- (void)playAd {
    NSLog(@"playAd");
//  if (_ad.nativeAd.mediaView) {
//    _mediaView = _ad.nativeAd.mediaView;
//    _mediaView.frame = CGRectMake(0, 0, _imageView.bounds.size.width, _imageView.bounds.size.height);
//    [_imageView insertSubview:_mediaView belowSubview:_button];
//    [self setNeedsDisplay];
//  }
}

- (void)pauseAd {
    NSLog(@"pauseAd");
//  [_mediaView removeFromSuperview];
//  [_imageView setNeedsDisplay];
//  [self setNeedsDisplay];
}

    - (void)layoutSubviews {
    _width = self.bounds.size.width;
    _height = self.bounds.size.height;
    _contentView.frame = CGRectMake(0, 0, _width, _height);
    [self addSubview:_contentView];
    [self setNeedsDisplay];
}

@end

