//
//  Pair.m
//  Farbspiel
//
//  Created by Daniel Schneller on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Pair.h"


@implementation Pair
@synthesize x = x_;
@synthesize y = y_;


-(id)initWithX:(NSUInteger)x Y:(NSUInteger)y {
    if ((self = [super init])) {
        x_ = x;
        y_ = y;
    }
    return self;
}

+(Pair*)pairWithX:(NSUInteger )x Y:(NSUInteger )y {
    Pair* p = [[Pair alloc] initWithX:x Y:y];
    return p;
}


@end
