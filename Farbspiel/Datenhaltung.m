//
//  Datenhaltung.m
//  Farbspiel
//
//  Created by Daniel Schneller on 22.07.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import "Datenhaltung.h"
#import "FarbspielAppDelegate.h"
#import "Spiel.h"

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

-(void)setInteger:(NSInteger)value fuerKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)integerFuerKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

-(void)setBool:(BOOL)newBool forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:newBool forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL)boolFuerKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}


-(void)speichereSpielAusgang:(Spielmodel *)model {
    FarbspielAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *ctx = app.managedObjectContext;
    Spiel *spielAusgang = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Spiel"
                                    inManagedObjectContext:ctx];

    spielAusgang.level = [NSNumber numberWithUnsignedInteger:model.level];
    spielAusgang.zuege = [NSNumber numberWithUnsignedInteger:model.zuege];
    spielAusgang.abgebrochen = [NSNumber numberWithBool:model.abgebrochen];
    spielAusgang.gewonnen = [NSNumber numberWithBool:model.siegErreicht];
    spielAusgang.dauer = [NSNumber numberWithLong:model.spieldauer];
    spielAusgang.datum = [NSDate date];
    

    NSError *error = NULL;
    
    [ctx save:&error];
    if (error) {
        NSLog(@"Fehler beim Speichern des Spielausgangs: %@", error.description);
    }
}

-(NSUInteger) anzahlSpieleGesamtFuerLevel:(SpielLevel)level {
    FarbspielAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *ctx = app.managedObjectContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Spiel"
                                              inManagedObjectContext:ctx];
    fetchRequest.includesSubentities = NO;
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"level == %@",
                              [NSNumber numberWithUnsignedInteger:(NSUInteger)level]];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    NSUInteger count = [ctx countForFetchRequest:fetchRequest error:&error];
    if (count == NSNotFound) {
        count = 0;
    }
    if (error) {
        NSLog(@"Fehler beim Zaehlen der Spiele fuer Level %d: %@", level, error);
    }
    [fetchRequest release];
    
    return count;
}

-(NSUInteger) anzahlSpieleGewonnen:(BOOL)gewonnen fuerLevel:(SpielLevel)level {
    FarbspielAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *ctx = app.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Spiel"
                                              inManagedObjectContext:ctx];
    fetchRequest.includesSubentities = NO;
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"level == %@ && gewonnen = %@",
                              [NSNumber numberWithUnsignedInteger:(NSUInteger)level], [NSNumber numberWithBool:gewonnen]];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger count = [ctx countForFetchRequest:fetchRequest error:&error];
    if (count == NSNotFound) {
        count = 0;
    }
    if (error) {
        NSLog(@"Fehler beim Zaehlen der %@ Spiele fuer Level %d: %@", (gewonnen ? @"gewonnenen" : @"verlorenen"), level, error);
    }
    [fetchRequest release];
    
    return count;

    
}

+(Datenhaltung*) sharedInstance {
    return sharedSingleton;
}


@end