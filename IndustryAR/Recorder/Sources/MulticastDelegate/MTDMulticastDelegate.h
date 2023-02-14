//
//  MTDMulticastDelegate.h
//  SCNRecorder
//
//  Created by 吴熠 on 8/29/22.
//  Copyright © 2022 GORA Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MulticastDelegate)
@interface MTDMulticastDelegate<__covariant Delegate> : NSProxy

@property (nonatomic, strong, readonly) NSArray<Delegate> *delegates;

- (instancetype)init;

- (void)addDelegate:(Delegate)delegate;

- (void)removeDelegate:(Delegate)delegate;

@end

NS_ASSUME_NONNULL_END
