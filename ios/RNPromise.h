//
//  RNPromise.h
//  RNTapdaq
//
//  Created by Giedrius Mikoliunas on 2020-01-12.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface RNPromise : NSObject

@property(nonatomic) RCTPromiseResolveBlock resolver;
@property(nonatomic) RCTPromiseRejectBlock rejecter;

- (id)initWithResolver:(RCTPromiseResolveBlock)resolve andRejector:(RCTPromiseRejectBlock)reject;

- (void)resolve;

- (void)resolve:(id)result;

- (void)reject:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
