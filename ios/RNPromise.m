//
//  RNPromise.h
//  RNTapdaq
//
//  Created by Giedrius Mikoliunas on 2020-01-12.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "RNPromise.h"

@interface RNPromise()
@property (nonatomic) BOOL fullfilled;
@end

@implementation RNPromise

-(id)initWithResolver:(RCTPromiseResolveBlock)resolve andRejector:(RCTPromiseRejectBlock)reject {
    self = [super init];
    if (self) {
        _resolver = resolve;
        _rejecter = reject;
        _fullfilled = NO;
    }
    return self;
}

-(void)resolve {
    if (_fullfilled) return;
    _resolver(@(YES));
    _fullfilled = YES;
}

-(void)resolve:(id)result {
    if (_fullfilled) return;
    _resolver(result);
    _fullfilled = YES;
}

-(void)reject:(NSError *)error {
    if (_fullfilled) return;
    _rejecter([@(error.code) stringValue] , @"Error", error);
    _fullfilled = YES;
}

@end
