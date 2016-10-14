//
//  RACBlockTrampoline.m
//  ReactiveCocoa
//
//  Created by Josh Abernathy on 10/21/12.
//  Copyright (c) 2012 GitHub, Inc. All rights reserved.
//

#import "RACBlockTrampoline.h"
#import "RACTuple.h"

@implementation RACBlockTrampoline

#pragma mark API

+ (id)invokeBlock:(id)block withArguments:(RACTuple *)args {
	NSCParameterAssert(block != NULL && args.count > 0);

	switch (args.count) {
		case 0:
			return nil;
		case 1:
			return ((id(^)(id))block)(args[0]);
		case 2:
			return ((id(^)(id, id))block)(args[0], args[1]);
		case 3:
			return ((id(^)(id, id, id))block)(args[0], args[1], args[2]);
		case 4:
			return ((id(^)(id, id, id, id))block)(args[0], args[1], args[2], args[3]);
		case 5:
			return ((id(^)(id, id, id, id, id))block)(args[0], args[1], args[2], args[3], args[4]);
		case 6:
			return ((id(^)(id, id, id, id, id, id))block)(args[0], args[1], args[2], args[3], args[4], args[5]);
		case 7:
			return ((id(^)(id, id, id, id, id, id, id))block)(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
		case 8:
			return ((id(^)(id, id, id, id, id, id, id, id))block)(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
		case 9:
			return ((id(^)(id, id, id, id, id, id, id, id, id))block)(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
		case 10:
			return ((id(^)(id, id, id, id, id, id, id, id, id, id))block)(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
		case 11:
			return ((id(^)(id, id, id, id, id, id, id, id, id, id, id))block)(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
		case 12:
			return ((id(^)(id, id, id, id, id, id, id, id, id, id, id, id))block)(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]);
		case 13:
			return ((id(^)(id, id, id, id, id, id, id, id, id, id, id, id, id))block)(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12]);
		case 14:
			return ((id(^)(id, id, id, id, id, id, id, id, id, id, id, id, id, id))block)(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]);
		case 15:
			return ((id(^)(id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))block)(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14]);
	}

	NSCAssert(NO, @"The argument count is too damn high! Only blocks of up to 15 arguments are currently supported.");
	return nil;
}

@end
