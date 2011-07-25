//
//  Datenhaltung.m
//  Farbspiel
//
//  Created by Daniel Schneller on 22.07.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import "Datenhaltung.h"


@implementation Datenhaltung



static Datenhaltung *sharedSingleton;

+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
        sharedSingleton = [[Datenhaltung alloc] init];
    }
}

-(NSInteger)erhoeheIntegerFuerKey:(NSString*)key {
    NSInteger oldCount = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    
    [[NSUserDefaults standardUserDefaults] setInteger:oldCount+1 forKey:key];
    BOOL success = [[NSUserDefaults standardUserDefaults] synchronize];
    if (success) {
        return oldCount + 1;
    } else {
        return oldCount;
    }
}

-(NSInteger)integerFuerKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

-(void)setBool:(BOOL)newBool forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:newBool forKey:key];
    BOOL success = [[NSUserDefaults standardUserDefaults] synchronize];
    if (success) {
        NSLog(@"Konnte BOOL Wert nicht persistieren fuer Key %@", key);
    }

}

-(BOOL)boolFuerKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}




+(Datenhaltung*) sharedInstance {
    return sharedSingleton;
}


@end