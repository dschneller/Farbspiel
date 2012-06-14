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

-(BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if ([object class] != [self class]) {
        return NO;
    }

    Pair* other = (Pair*)object;
    return other.x == self.x && other.y == self.y;
}

-(NSUInteger)hash {
    return self.x * 41 + self.y * 7;
}

-(id)copyWithZone:(NSZone *)zone {
    Pair* copy = [Pair pairWithX:self.x Y:self.y];
    return copy;
}

+(Pair*)pairWithX:(NSUInteger )x Y:(NSUInteger )y {
    Pair* p = [[Pair alloc] initWithX:x Y:y];
    return p;
}


@end
