//
//  RACPassthroughSubscriberSpec.m
//  ReactiveCocoa
//
//  Created by Yaron Inger on 2016-05-30.
//  Copyright (c) 2016 Lightricks, Ltd. All rights reserved.
//

@import Quick;
@import Nimble;

#import "RACSubscriberExamples.h"

#import "RACCompoundDisposable.h"
#import "RACPassthroughSubscriber.h"
#import "RACSubscriber+Private.h"
#import <libkern/OSAtomic.h>

QuickSpecBegin(RACPassthroughSubscriberSpec)

__block RACPassthroughSubscriber *subscriber;
__block NSMutableArray *values;

__block volatile int32_t nextsAfterDisposal;
__block volatile int32_t completedAfterDisposal;
__block volatile int32_t erredAfterDisposal;

__block BOOL success;
__block NSError *error;
__block BOOL finished;

__block RACCompoundDisposable *disposable;
__block RACSubscriber *innerSubscriber;

__block dispatch_queue_t queue;

qck_beforeEach(^{
	values = [NSMutableArray array];

	nextsAfterDisposal = 0;
  completedAfterDisposal = 0;
  erredAfterDisposal = 0;

	success = YES;
	error = nil;
  finished = NO;

	innerSubscriber = [RACSubscriber subscriberWithNext:^(id value) {
		if (disposable.disposed) OSAtomicIncrement32Barrier(&nextsAfterDisposal);

		[values addObject:value];
	} error:^(NSError *e) {
    if (disposable.disposed) OSAtomicIncrement32Barrier(&erredAfterDisposal);

		error = e;
		success = NO;
	} completed:^{
    if (disposable.disposed) OSAtomicIncrement32Barrier(&completedAfterDisposal);

		success = YES;
	}];

  disposable = [RACCompoundDisposable compoundDisposable];
  subscriber = [[RACPassthroughSubscriber alloc] initWithSubscriber:innerSubscriber signal:nil
                                                         disposable:disposable];

  queue = dispatch_queue_create("org.reactivecocoa.ReactiveCocoa.RACPassthroughSubscriberSpec", DISPATCH_QUEUE_CONCURRENT);
});

void (^resetPassthroughSubscriber)() = ^{
  nextsAfterDisposal = 0;
  completedAfterDisposal = 0;
  erredAfterDisposal = 0;

  disposable = [RACCompoundDisposable compoundDisposable];
  subscriber = [[RACPassthroughSubscriber alloc] initWithSubscriber:innerSubscriber signal:nil
                                                         disposable:disposable];
};

qck_fit(@"should not invoke next on inner subscriber after disposal", ^{
  for (NSUInteger i = 0; i < 1000; ++i) {
    @autoreleasepool {
      resetPassthroughSubscriber();

      __block BOOL done = NO;
      dispatch_async(queue, ^{
        for (NSUInteger i = 0; i < 15; i++) {
          [subscriber sendNext:@(i)];
        }
        done = YES;
      });

      [disposable dispose];

      expect(@(done)).toEventually(beTruthy());
      expect(@(nextsAfterDisposal)).to(equal(@0));
    }
  }
});

qck_fit(@"should not invoke error on inner subscriber after disposal", ^{
  for (NSUInteger i = 0; i < 1000; ++i) {
    @autoreleasepool {
      resetPassthroughSubscriber();

      __block BOOL done = NO;
      dispatch_async(queue, ^{
        [subscriber sendError:nil];
        done = YES;
      });

      [disposable dispose];

      expect(@(done)).toEventually(beTruthy());
      expect(@(erredAfterDisposal)).to(equal(@0));
    }
  }
});

qck_fit(@"should not invoke complete on inner subscriber after disposal", ^{
  for (NSUInteger i = 0; i < 1000; ++i) {
    @autoreleasepool {
      resetPassthroughSubscriber();
      
      __block BOOL done = NO;
      dispatch_async(queue, ^{
        [subscriber sendCompleted];
        done = YES;
      });

      [disposable dispose];

      expect(@(done)).toEventually(beTruthy());
      expect(@(completedAfterDisposal)).to(equal(@0));
    }
  }
});

QuickSpecEnd
