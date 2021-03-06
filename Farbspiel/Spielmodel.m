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
#import "Datenhaltung.h"

@implementation Spielmodel


-(NSUInteger) arrayIndexFuerZeile:(NSUInteger)row spalte:(NSUInteger)col {
    return row+col*self.felderProKante;
}
-(NSNumber *) farbeAnPositionZeile:(NSUInteger)row spalte:(NSUInteger)col {
    return (self.farbfelder)[[self arrayIndexFuerZeile:row spalte:col]];
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
    (self.farbfelder)[idx] = neueFarbe;
}


-(void) randomizeSpielfeld {
    for (int i=0; i<self.felderProKante * self.felderProKante; i++) {
        int x; 
        switch (self.level) {
            case MEDIUM:
                if (i % 3 != 0) { x = arc4random() % 5; }
                else { x = arc4random() % 6; }
                break;
            case HARD:
                if (i % 4 != 0) { x = arc4random() % 5; }
                else { x = arc4random() % 6; }
                break;
            case EASY:
            default:
                x = arc4random() % 6;
                break;
        }
        [self.farbfelder addObject:@(x)];
    }
}

-(void)zaehleSpielzug {
    self.zuege ++;
}

-(NSSet*)findeAngrenzendeVonX:(NSUInteger)startX Y:(NSUInteger)startY inFarbe:(int)farbe {
    NSMutableArray* stack = [NSMutableArray array];
    NSMutableSet* zuFaerben = [NSMutableSet set];
    NSMutableSet* schonBetrachtet = [NSMutableSet set];
    int ausgangsFarbe = [[self farbeAnPositionZeile:startY spalte:startX] intValue];
    [stack push:[Pair pairWithX:startX Y:startY]];
    NSUInteger x,y;
    while([stack count] > 0) {
        Pair* p = [stack pop];
        x = p.x;
        y = p.y;
        int aktuelleFarbe = [[self farbeAnPositionZeile:y spalte:x] intValue];
        
        if (aktuelleFarbe == farbe) {
            // dieses feld gehoert geaendert
            [zuFaerben addObject:p];
  
            // von hier aus in dieser Farbe erreichbare suchen
            //NSSet* erreichbare = [self findeErreichbareFelderVonX:p.x Y:p.y];
            //[zuFaerben addObjectsFromArray:[erreichbare allObjects]];
        } else if (aktuelleFarbe == ausgangsFarbe && ![schonBetrachtet member:p]) {
            // weitersuchen in angrenzenden, betrachtete merken
            [schonBetrachtet addObject:p];
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
    return [NSSet setWithSet:zuFaerben];
}


-(BOOL)faerbeVonX:(NSUInteger)startX Y:(NSUInteger)startY alteFarbe:(NSUInteger)alt neueFarbe:(NSUInteger)neu {
    if (alt == neu) {
        return NO;
    }
    
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
    return YES;
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
    NSUInteger neu = [[self farbeAnPositionZeile:0 spalte:0] unsignedIntValue];
    NSSet* zuFaerben = [self findeAngrenzendeVonX:0 Y:0 inFarbe:colorNum];
    
    for (Pair* p in zuFaerben) {
        [self faerbeVonX:p.x Y:p.y alteFarbe:colorNum neueFarbe:neu];
    }
    if (zuFaerben.count > 0) {
        [self zaehleSpielzug];
    }
}

-(void)farbeGewaehlt:(NSUInteger)colorNum fuerPositionX:(NSUInteger)x Y:(NSUInteger)y {
    NSUInteger alt = [[self farbeAnPositionZeile:y spalte:x] unsignedIntValue];
    [self faerbeVonX:x Y:y alteFarbe:alt neueFarbe:colorNum];
}


-(id)initWithLevel:(SpielLevel)level {
    if ((self = [super init])) {
        self.level = level;
        switch (self.level) {
            case MEDIUM:
                _felderProKante = SPALTEN_MEDIUM;
                _maximaleZuege  = ZUEGE_MEDIUM;
                break;
                
            case HARD:
                _felderProKante = SPALTEN_HARD;
                _maximaleZuege  = ZUEGE_HARD;
                break;
                
            case EASY:
            default:
                _felderProKante = SPALTEN_EASY;
                _maximaleZuege  = ZUEGE_EASY;
                break;
        }
        
        self.farbfelder = [NSMutableArray arrayWithCapacity:(NSUInteger) (_felderProKante*_felderProKante)];
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
        _felderProKante = templateModel.felderProKante;
        _maximaleZuege = templateModel.maximaleZuege;
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


+(NSString*) levelNameFor:(SpielLevel)level {
    NSString* levelName;
    switch (level) {
        case HARD:
            levelName = NSLocalizedString(@"L_SCHWER", @"Level name for -hard-");
            break;
            
        case MEDIUM:
            levelName = NSLocalizedString(@"L_MITTEL", @"Level name for -medium-");
            break;
            
        case EASY:
        default:
            levelName = NSLocalizedString(@"L_EASY", @"Level name for -easy-");
            break;
    }
    return levelName;
}

-(NSSet*)unterschiedeZuModel:(Spielmodel*)other {
    NSMutableSet* result = [NSMutableSet set];
    for (NSUInteger row = 0; row < self.felderProKante; row ++) {
        for (NSUInteger col = 0; col < self.felderProKante; col ++) {
            NSNumber* mine = [self farbeAnPositionZeile:row spalte:col];
            NSNumber* others = [other farbeAnPositionZeile:row spalte:col];
            
            if (![mine isEqualToNumber:others]) {
                [result addObject:[Pair pairWithX:col Y:row]];
            }
        }
    }
    return [NSSet setWithSet:result];
}

@end
