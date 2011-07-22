//
//  Spielmodel.m
//  Farbspiel
//
//  Created by Daniel Schneller on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Spielmodel.h"
#import "Pair.h"
#import "NSMutableArray+StackMethods.h"
#import "Farbmapping.h"

@implementation Spielmodel

@synthesize farbfelder = farbfelder_;
@synthesize level = level_;
@synthesize felderProKante = felderProKante_;
@synthesize zuege = zuege_;
@synthesize maximaleZuege = maximaleZuege_;
@synthesize spieldauer = spieldauer_;





-(int) arrayIndexFuerZeile:(int)row spalte:(int)col {
    return row+col*self.felderProKante;
}
-(NSNumber*) farbeAnPositionZeile:(int)row spalte:(int)col {
    return [self.farbfelder objectAtIndex:[self arrayIndexFuerZeile:row spalte:col]];
}

-(void) debugMatrix {
    if (NO) {
    for (int row = 0; row<12; row++) {
       NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@", 
             [self farbeAnPositionZeile:row spalte:0], 
             [self farbeAnPositionZeile:row spalte:1], 
             [self farbeAnPositionZeile:row spalte:2], 
             [self farbeAnPositionZeile:row spalte:3], 
             [self farbeAnPositionZeile:row spalte:4], 
             [self farbeAnPositionZeile:row spalte:5], 
             [self farbeAnPositionZeile:row spalte:6], 
             [self farbeAnPositionZeile:row spalte:7], 
             [self farbeAnPositionZeile:row spalte:8], 
             [self farbeAnPositionZeile:row spalte:9], 
             [self farbeAnPositionZeile:row spalte:10], 
             [self farbeAnPositionZeile:row spalte:11]
             );
    }
    }
}

-(void) faerbePositionZeile:(int)row spalte:(int)col mitFarbe:(int)farbNummer {
    int idx = [self arrayIndexFuerZeile:row spalte:col];
    NSNumber* neueFarbe = [NSNumber numberWithInt:farbNummer];
    [self.farbfelder replaceObjectAtIndex:idx withObject:neueFarbe];
}


-(void) randomizeSpielfeld {
    for (int i=0; i<self.felderProKante * self.felderProKante; i++) {
        int x =  arc4random() % 6;
        [self.farbfelder addObject:[NSNumber numberWithInt:x]];
    }
}

-(void) zaehleZug {
    self.zuege ++;
}

-(void)faerbeVonX:(int)startX Y:(int)startY alteFarbe:(int)alt neueFarbe:(int)neu {
    if (alt == neu) {
        return;
    }
    [self zaehleZug];

    [self debugMatrix];
    
    NSMutableArray* stack = [NSMutableArray array];
    
    [stack push:[Pair pairWithX:startX Y:startY]];
    int x,y;
    while([stack count] > 0) {
        Pair* p = [stack pop];
        x = p.x;
        y = p.y;
        
        int aktuelleFarbe = [[self farbeAnPositionZeile:y spalte:x] intValue];
        
        if (aktuelleFarbe == alt) {
            [self faerbePositionZeile:y spalte:x mitFarbe:neu];
            [self debugMatrix];
            
            if (y+1 < self.felderProKante) {
                [stack push:[Pair pairWithX:x Y:(y + 1)]];
            }
            if (y>0) {
                [stack push:[Pair pairWithX:x Y:(y - 1)]];
            }
            if (x+1 < self.felderProKante) {
                [stack push:[Pair pairWithX:(x+1) Y:y]];
            }
            if (x>0) {
                [stack push:[Pair pairWithX:(x-1) Y:y]];
            }
        }
    }
    return;
}



-(BOOL) siegErreicht {
    NSNumber* first = nil;
    for (NSNumber* color in self.farbfelder) {
        if (!first) {
            first = color;
        } else if ([first intValue] != [color intValue]) {
            return NO;
        }
    }

    return YES;
}



-(void)farbeGewaehlt:(int)colorNum {
    int alt = [[self farbeAnPositionZeile:0 spalte:0] intValue];
    [self faerbeVonX:0 Y:0 alteFarbe:alt neueFarbe:colorNum];
}


-(id)initWithLevel:(SpielLevel)level {
    if ((self = [super init])) {
        self.level = level;
        switch (self.level) {
            case MEDIUM:
                felderProKante_ = SPALTEN_MEDIUM;
                maximaleZuege_  = ZUEGE_MEDIUM;
                break;
                
            case HARD:
                felderProKante_ = SPALTEN_HARD;
                maximaleZuege_  = ZUEGE_HARD;
                break;
                
            case EASY:
            default:
                felderProKante_ = SPALTEN_EASY;
                maximaleZuege_  = ZUEGE_EASY;
                break;
        }

        self.farbfelder = [NSMutableArray arrayWithCapacity:(felderProKante_*felderProKante_)];
        self.zuege = 0;
        
        [self randomizeSpielfeld];
    }
    return self;
}

-(void)dealloc {
    [farbfelder_ release];
    farbfelder_ = nil;
    [super dealloc];
}

@end
