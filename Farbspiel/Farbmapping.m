//
//  Farbmapping.m
//  Farbspiel
//
//  Created by Daniel Schneller on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Farbmapping.h"
#import "UIColor+Tools.h"


@implementation Farbmapping

+(UIColor*) farbeMitNummer:(int)farbnummer {
    switch (farbnummer) {
        case 0:
            return [UIColor redColor];
            
        case 1:
            return [UIColor greenColor];
            
        case 2:
            return [UIColor cyanColor];
            
        case 3:
            return [UIColor purpleColor];
            
        case 4:
            return [UIColor magentaColor];
            
        case 5:
        default:
            return [UIColor yellowColor];
            
    }
}

+(UIColor*) shadeFarbeMitNummer:(int)farbnummer {
    return [[self farbeMitNummer:farbnummer] colorByDarkeningColor];
}

@end
