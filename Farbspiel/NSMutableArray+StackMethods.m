//
//  NSMutableArray+StackMethods.m
//  Farbspiel
//
//  Created by Daniel Schneller on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+StackMethods.h"


@implementation NSMutableArray (NSMutableArray_StackMethods)


-(void) push:(id) item {
    [self addObject:item]; // where list is the actual array in your stack
}

-(id) pop {
    id r = [self lastObject];
    [self removeLastObject];
    return r;
}

@end
