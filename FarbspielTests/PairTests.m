//
//  PairTests.m
//  Farbspiel
//
//  Created by Daniel Schneller on 13.06.12.
//  Copyright (c) 2012 codecentric AG. All rights reserved.
//

#import "PairTests.h"
#import "Pair.h"
@implementation PairTests

-(void)testEquality {
    Pair *p1 = [Pair pairWithX:0 Y:0];
    Pair *p2 = [Pair pairWithX:0 Y:0];
    
    STAssertEqualObjects(p1, p2, @"");
    STAssertEqualObjects(p1, p1, @"");
    STAssertEqualObjects(p2, p2, @"");
}


-(void)testInequalityDifferentX {
    Pair *p1 = [Pair pairWithX:1 Y:0];
    Pair *p2 = [Pair pairWithX:0 Y:0];
    
    STAssertFalse([p1 isEqual:p2], @"p1 should have been UNequal to p2");
}

-(void)testInequalityDifferentY {
    Pair *p1 = [Pair pairWithX:0 Y:0];
    Pair *p2 = [Pair pairWithX:0 Y:1];
    
    STAssertFalse([p1 isEqual:p2], @"p1 should have been UNequal to p2");
}

-(void)testDifferentSetMembers {
    Pair *p1 = [Pair pairWithX:0 Y:0];
    Pair *p2 = [Pair pairWithX:0 Y:1];
        
    NSSet* set = [NSSet setWithObjects:p1, p2, nil];
    STAssertNotNil([set member:p1], @"Set should have contained p1");
    STAssertNotNil([set member:p2], @"Set should have contained p2");
                  
}

-(void)testSameSetMembers {
    Pair *p1 = [Pair pairWithX:1 Y:1];
    Pair *p2 = [Pair pairWithX:1 Y:1];
    
    NSSet* set = [NSSet setWithObjects:p1, nil];
    STAssertNotNil([set member:p1], @"Set should have contained p1");
    STAssertNotNil([set member:p2], @"Set should have contained p2");
    
}

@end
