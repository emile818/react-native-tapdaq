//
//  RNTapdaq.h
//  RNTapdaq
//
//  Created by Giedrius Mikoliunas on 2020-01-12.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import "RNTapdaqSharedController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RNTapdaq : RCTEventEmitter <RCTBridgeModule, RNTapdaqSharedControllerDelegate>

@property(strong, nonatomic) RNTapdaqSharedController *tapdaqController;

@end

NS_ASSUME_NONNULL_END
