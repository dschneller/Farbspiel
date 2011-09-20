//
//  Datenhaltung.h
//  Farbspiel
//
//  Created by Daniel Schneller on 22.07.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spielmodel.h"
#import "Prefkeys.h"


@interface Datenhaltung : NSObject {
    
}

+(Datenhaltung*) sharedInstance;

-(NSInteger)erhoeheIntegerFuerKey:(NSString*)key;
-(NSInteger)integerFuerKey:(NSString*)key;
-(void)setInteger:(NSInteger)value fuerKey:(NSString*)key;
-(void)setBool:(BOOL)newBool forKey:(NSString *)key;
-(BOOL)boolFuerKey:(NSString*)key;

-(void)speichereSpielAusgang:(Spielmodel*)model;
-(void)resetLevel:(SpielLevel)level;
-(NSUInteger) anzahlSpieleGesamtFuerLevel:(SpielLevel)level;
-(NSUInteger) anzahlSpieleGewonnen:(BOOL)gewonnen fuerLevel:(SpielLevel)level;

@end
