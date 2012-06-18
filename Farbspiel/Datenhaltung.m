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

-(void)resetLevel:(SpielLevel)level {
    FarbspielAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *ctx = app.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Spiel"
                                              inManagedObjectContext:ctx];
    fetchRequest.includesSubentities = NO;
    fetchRequest.entity = entity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"level == %@",
                              @((NSUInteger)level)];
    fetchRequest.predicate = predicate;
    fetchRequest.includesPropertyValues = NO;
    
    NSError *error = nil;
    NSArray *spiele = [ctx executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        LOG_PREFS(0, @"Fehler beim Zuruecksetzen der Statistik fuer Level %d: %@", level, error);
        return;
    }
    
    //error handling goes here
    for (NSManagedObject *spiel in spiele) {
        [ctx deleteObject:spiel];
    }
    

}

-(void)speichereSpielAusgang:(Spielmodel *)model {
    FarbspielAppDelegate *app = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *ctx = app.managedObjectContext;
    Spiel *spielAusgang = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Spiel"
                                    inManagedObjectContext:ctx];

    spielAusgang.level = @(model.level);
    spielAusgang.zuege = @(model.zuege);
    spielAusgang.abgebrochen = @(model.abgebrochen);
    spielAusgang.gewonnen = @(model.siegErreicht);
    spielAusgang.dauer = @(model.spieldauer);
    spielAusgang.datum = [NSDate date];
    

    NSError *error = NULL;
    
    [ctx save:&error];
    if (error) {
        LOG_GAME(0, @"Fehler beim Speichern des Spielausgangs: %@", error.description);
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
                              @((NSUInteger)level)];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    NSUInteger count = [ctx countForFetchRequest:fetchRequest error:&error];
    if (count == NSNotFound) {
        count = 0;
    }
    if (error) {
        LOG_GAME(0, @"Fehler beim Zaehlen der Spiele fuer Level %d: %@", level, error);
    }
    
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
                              @((NSUInteger)level), @(gewonnen)];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger count = [ctx countForFetchRequest:fetchRequest error:&error];
    if (count == NSNotFound) {
        count = 0;
    }
    if (error) {
        LOG_GAME(0, @"Fehler beim Zaehlen der %@ Spiele fuer Level %d: %@", (gewonnen ? @"gewonnenen" : @"verlorenen"), level, error);
    }
    
    return count;

    
}

+(Datenhaltung*) sharedInstance {
    return sharedSingleton;
}


@end