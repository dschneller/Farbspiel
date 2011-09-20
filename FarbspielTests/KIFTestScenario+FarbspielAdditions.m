//
//  KIFTestScenario+FarbspielAdditions.m
//  Farbspiel
//
//  Created by Daniel Schneller on 21.09.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import "KIFTestScenario+FarbspielAdditions.h"
#import "KIF/KIFTestStep.h"

@implementation KIFTestScenario (KIFTestScenario_FarbspielAdditions)

+ (id) scenarioToGotoSettings {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that you can switch to the settings view"];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Settings"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Difficulty"]];
    
    return scenario;
}

@end
