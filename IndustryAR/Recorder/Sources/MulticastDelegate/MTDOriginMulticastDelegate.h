//
//  MTDOriginMulticastDelegate.h
//  SCNRecorder
//
//  Created by 吴熠 on 8/29/22.
//  Copyright © 2022 GORA Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTDMulticastDelegate.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(OriginMulticastDelegate)
@interface MTDOriginMulticastDelegate<__covariant Delegate> : MTDMulticastDelegate<Delegate>

@property (nonatomic, weak, nullable) Delegate origin;

@end

NS_ASSUME_NONNULL_END
