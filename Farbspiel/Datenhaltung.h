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


@end
