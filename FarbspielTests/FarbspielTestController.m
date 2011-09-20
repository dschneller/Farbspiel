//
//  FarbspielTestController.m
//  Farbspiel
//
//  Created by Daniel Schneller on 21.09.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import "FarbspielTestController.h"

@implementation FarbspielTestController

- (void)initializeScenarios {
    [self addScenario:[KIFTestScenario scenarioToGotoSettings]];
}

@end
