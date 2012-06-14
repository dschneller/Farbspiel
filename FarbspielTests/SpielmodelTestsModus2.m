//
//  SpielmodelTestsModus2.m
//  Farbspiel
//
//  Created by Daniel Schneller on 14.06.12.
//  Copyright (c) 2012 codecentric AG. All rights reserved.
//

#import "SpielmodelTestsModus2.h"
#import "Spielmodel.h"

@implementation SpielmodelTestsModus2

Spielmodel* _model;

-(void)setUp {
    _model = [[Spielmodel alloc] initWithLevel:EASY];
    for (int i=0; i<144; i++) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];        
    }
}

-(void)testFuellen2KeineAngrenzenden {
    [_model farbeGewaehlt2:2];
    for (int i=0; i<144; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 0, @"");
    }
}

-(void)testFuellen2KeineAngrenzenden2 {
    for (int i=0; i<12; i++) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
    }
    [_model farbeGewaehlt2:1];
    for (int i=0; i<12; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 1, @"%d", i);
    }
    for (int i=12; i<144; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 0, @"%d", i);
    }
}


-(void)testFuellen2Angrenzende2 {
    for (int i=0; i<12; i++) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:2]];
    }
    for (int i=12; i<24; i++) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
    }
    
    [_model farbeGewaehlt2:1];
    for (int i=0; i<24; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 2, @"%d", i);
    }
    for (int i=24; i<144; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 0, @"%d", i);
    }
}


-(void)testFuellen2Angrenzende3 {
    for (int i=0; i<12; i++) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:2]];
    }
    for (int i=12; i<24; i+=2) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
    }
    
    [_model farbeGewaehlt2:1];
    for (int i=0; i<12; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 2, @"%d", i);
    }
    for (int i=12; i<24; i+=2) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 2, @"%d", i);
        STAssertEquals([[_model.farbfelder objectAtIndex:i+1] intValue], 0, @"%d", i+1);
    }
    for (int i=24; i<144; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 0, @"%d", i);
    }
}


-(void)testFuellen2Angrenzende4 {
    for (int i=0; i<12; i+=2) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:2]];
    }
    for (int i=12; i<24; i++) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
    }
    [_model farbeGewaehlt2:1];
    for (int i=0; i<12; i+=2) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 2, @"%d", i);
        STAssertEquals([[_model.farbfelder objectAtIndex:i+1] intValue], 0, @"%d", i+1);
    }
    for (int i=12; i<24; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 2, @"%d", i);
    }
    for (int i=24; i<144; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 0, @"%d", i);
    }
}

-(void)testFuellen2Angrenzende5 {
    for (int i=0; i<12; i+=2) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:2]];
    }
    for (int i=12; i<24; i+=2) {
        [_model.farbfelder replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
    }
    [_model farbeGewaehlt2:1];
    for (int i=0; i<12; i+=2) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 2, @"%d", i);
        STAssertEquals([[_model.farbfelder objectAtIndex:i+1] intValue], 0, @"%d", i);
    }
    STAssertEquals([[_model.farbfelder objectAtIndex:12] intValue], 2, @"%d", 12);
    STAssertEquals([[_model.farbfelder objectAtIndex:13] intValue], 0, @"%d", 13);
    for (int i=14; i<24; i+=2) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 1, @"%d", i);
        STAssertEquals([[_model.farbfelder objectAtIndex:i+1] intValue], 0, @"%d", i+1);
    }
    for (int i=24; i<144; i++) {
        STAssertEquals([[_model.farbfelder objectAtIndex:i] intValue], 0, @"%d", i);
    }
}

@end
