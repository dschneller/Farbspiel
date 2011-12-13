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

@implementation Spielmodel

@synthesize farbfelder = farbfelder_;
@synthesize level = level_;
@synthesize felderProKante = felderProKante_;
@synthesize zuege = zuege_;
@synthesize maximaleZuege = maximaleZuege_;
@synthesize spieldauer = spieldauer_;
@synthesize abgebrochen = abgebrochen_;
#if DEBUG
@synthesize debugErzwungenerSieg = debugErzwungenerSieg_;
#endif




-(NSUInteger) arrayIndexFuerZeile:(NSUInteger)row spalte:(NSUInteger)col {
    return row+col*self.felderProKante;
}
-(NSNumber *) farbeAnPositionZeile:(NSUInteger)row spalte:(NSUInteger)col {
    return [self.farbfelder objectAtIndex:[self arrayIndexFuerZeile:row spalte:col]];
}

-(void) debugMatrix {
    if (NO) {
        for (NSUInteger row = 0; row<12; row++) {
            LOG_GAME(2, @"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@", 
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

-(void) faerbePositionZeile:(NSUInteger)row spalte:(NSUInteger)col mitFarbe:(NSUInteger)farbNummer {
    NSUInteger idx = [self arrayIndexFuerZeile:row spalte:col];
    NSNumber* neueFarbe = [NSNumber numberWithInt:farbNummer];
    [self.farbfelder replaceObjectAtIndex:idx withObject:neueFarbe];
}


-(void) randomizeSpielfeld {
    for (int i=0; i<self.felderProKante * self.felderProKante; i++) {
        int x =  arc4random() % 6;
        [self.farbfelder addObject:[NSNumber numberWithInt:x]];
    }
}

-(void)zaehleSpielzug {
    self.zuege ++;
}

-(void)faerbeVonX:(NSUInteger)startX Y:(NSUInteger)startY alteFarbe:(NSUInteger)alt neueFarbe:(NSUInteger)neu {
    if (alt == neu) {
        return;
    }
    
    [self zaehleSpielzug];
    [self debugMatrix];
    
    NSMutableArray* stack = [NSMutableArray array];
    
    [stack push:[Pair pairWithX:startX Y:startY]];
    NSUInteger x,y;
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
#if DEBUG
    if (self.debugErzwungenerSieg) {
        return YES;
    }
#endif
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

-(BOOL) verloren {
    return (self.zuege == [self maximaleZuegeFuerLevel:self.level] &&
            !self.siegErreicht);
}

-(BOOL)spielLaeuft {
    return self.zuege > 0;
}

-(int) spaltenFuerLevel:(SpielLevel)level {
    switch (level) {
        case HARD:
            return SPALTEN_HARD;
        case MEDIUM:
            return SPALTEN_MEDIUM;
            
        case EASY:
        default:
            return SPALTEN_EASY;
    }
}

-(int) maximaleZuegeFuerLevel:(SpielLevel)level {
    switch (level) {
        case HARD:
            return ZUEGE_HARD;
        case MEDIUM:
            return ZUEGE_MEDIUM;
            
        case EASY:
        default:
            return ZUEGE_EASY;
    }
}


-(void)farbeGewaehlt:(NSUInteger)colorNum {
    NSUInteger alt = [[self farbeAnPositionZeile:0 spalte:0] unsignedIntValue];
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
        
        self.farbfelder = [NSMutableArray arrayWithCapacity:(NSUInteger) (felderProKante_*felderProKante_)];
        self.zuege = 0;
        self.abgebrochen = NO;
#if DEBUG
        self.debugErzwungenerSieg = NO;
#endif
        
        [self randomizeSpielfeld];
    }
    return self;
}

-(id)initWithModel:(Spielmodel*)templateModel {
    if ((self = [super init])) {
        felderProKante_ = templateModel.felderProKante;
        maximaleZuege_ = templateModel.maximaleZuege;
        self.level = templateModel.level;
        self.zuege = templateModel.zuege;
        self.abgebrochen = templateModel.abgebrochen;
#if DEBUG
        self.debugErzwungenerSieg = templateModel.debugErzwungenerSieg;
#endif
        self.farbfelder = [templateModel.farbfelder copy];
    }
    return self;
}


@end
