//
//  MTDMulticastDelegate.m
//  SCNRecorder
//
//  Created by 吴熠 on 8/29/22.
//  Copyright © 2022 GORA Studio. All rights reserved.
//

#import "MTDMulticastDelegate.h"

@interface MTDMulticastDelegate ()

@property (nonatomic, strong) NSPointerArray *mutableDelegates;

@end

@implementation MTDMulticastDelegate

- (instancetype)init
{
  _mutableDelegates = [NSPointerArray weakObjectsPointerArray];
  return self;
}

#pragma mark - Public interface

- (NSArray *)delegates
{
  [self.mutableDelegates compact];
  return [self.mutableDelegates allObjects];
}

- (void)addDelegate:(id)delegate
{
  [self.mutableDelegates addPointer:(__bridge void * _Nullable)(delegate)];
}

- (void)removeDelegate:(id)delegate
{
  for (NSUInteger i = [self.mutableDelegates count] - 1; i >= 0; i--)
  {
    if ([self.mutableDelegates pointerAtIndex:i] == (__bridge void * _Nullable)(delegate))
    {
      [self.mutableDelegates removePointerAtIndex:i];
    }
  }
}

#pragma mark - NSProxy

- (void)forwardInvocation:(NSInvocation *)invocation
{
  for (id delegate in self.mutableDelegates) {
      if ([delegate respondsToSelector:invocation.selector]) {
          [invocation invokeWithTarget:delegate];
      }
  }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    id firstResponder = [self firstResponderToSelector:selector];
    return [firstResponder methodSignatureForSelector:selector];
}

- (BOOL)respondsToSelector:(SEL)selector
{
    return [self firstResponderToSelector:selector];
}

- (BOOL)conformsToProtocol:(Protocol *)protocol
{
    return [self firstConformedToProtocol:protocol];
}

#pragma mark - Private

- (id)firstResponderToSelector:(SEL)selector
{
    for (id delegate in self.mutableDelegates) {
        if ([delegate respondsToSelector:selector]) {
            return delegate;
        }
    }
    return nil;
}

- (id)firstConformedToProtocol:(Protocol *)protocol
{
    for (id delegate in self.mutableDelegates) {
        if ([delegate conformsToProtocol:protocol]) {
            return delegate;
        }
    }
    return nil;
}

@end
