//
//  Farbmapping.m
//  Farbspiel
//
//  Created by Daniel Schneller on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Farbmapping.h"
#import "UIColor+Tools.h"
#import "Datenhaltung.h"

@implementation Farbmapping
static Farbmapping *sharedSingleton;

+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
        sharedSingleton = [[Farbmapping alloc] init];
    }
}
+(Farbmapping*) sharedInstance {
    return sharedSingleton;
}

- (id)init {
    self = [super init];
    if (self) {
        _farbschema = [[Datenhaltung sharedInstance] integerFuerKey:PREFKEY_FARBSCHEMA];
    }
    return self;
}

-(void)setFarbschema:(int)schema {
    _farbschema = schema;
    [[Datenhaltung sharedInstance] setInteger:schema fuerKey:PREFKEY_FARBSCHEMA];
}


-(UIColor*) farbeMitNummer:(int)farbnummer {
    // Graustufen
    switch (self.farbschema) {
        case 2: {
            switch (farbnummer) {
                case 0:
                    return [UIColor colorWithWhite:0.16f alpha:1.0f];
                    
                case 1:
                    return [UIColor colorWithWhite:0.32f alpha:1.0f];
                    
                case 2:
                    return [UIColor colorWithWhite:0.48f alpha:1.0f];
                    
                case 3:
                    return [UIColor colorWithWhite:0.64f alpha:1.0f];
                    
                case 4:
                    return [UIColor colorWithWhite:0.80f alpha:1.0f];
                    
                case 5:
                default:
                    return [UIColor colorWithWhite:0.96f alpha:1.0f];
                    
            }
        }  

        // Pastell
        case 1: {
            switch (farbnummer) {
                case 0:
                    return [UIColor colorWithRed:204.0f/255.0f green:102.0f/255.0f blue:204.0f alpha:1.0f];
                    
                case 1:
                    return [UIColor colorWithRed:204.0f/255.0f green:153.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    
                case 2:
                    return [UIColor colorWithRed:138.0f/255.0f green:46.0f/255.0f blue:138.0f/255.0f alpha:1.0f];
                    
                case 3:
                    return [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    
                case 4:
                    return [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
                    
                case 5:
                default:
                    return [UIColor colorWithRed:102.0f/255.0f green:204.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                    
            }
        }
            
        // Bunt    
        case 0:
        default: {
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
    }
}

-(UIColor*) shadeFarbeMitNummer:(int)farbnummer {
    return [[self farbeMitNummer:farbnummer] colorByDarkeningColor];
}


-(NSString*) imageNameForColor:(NSUInteger)color andSize:(NSUInteger)width {
    NSUInteger schema = self.farbschema + 1;
    
    return [NSString stringWithFormat:@"spielstein%d-CS%d-%d", width, schema, color];
}


@end
