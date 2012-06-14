//
//  SpielModelTests.m
//  Farbspiel
//
//  Created by Daniel Schneller on 13.06.12.
//  Copyright (c) 2012 codecentric AG. All rights reserved.
//

#import "SpielModelTestsModus1.h"
#import "Spielmodel.h"


@implementation SpielModelTestsModus1

Spielmodel* _model;

-(void)setUp {
    _model = [[Spielmodel alloc] initWithLevel:EASY];
    for (int i=0; i<144; i++) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];        
    }
}

-(void)testFuellen {

    [_model farbeGewaehlt:1];
    for (int i=0; i<144; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 1, @"");
    }
}

-(void)testFuellenXY {
    for (int i=0; i<12; i++) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
    }
    
    [_model farbeGewaehlt:2 fuerPositionX:1 Y:0];
    for (int i=0; i<12; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 1, @"");
    }
    for (int i=12; i<144; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 2, @"");        
    }
}

-(void)testFuellenXY2 {
    [_model farbeGewaehlt:2 fuerPositionX:5 Y:5];
    for (int i=0; i<144; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 2, @"");
    }
}




@end
