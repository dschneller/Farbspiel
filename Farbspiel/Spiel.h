//
//  Spiel.h
//  Farbspiel
//
//  Created by Schneller Daniel on 08.08.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Spiel : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * dauer;
@property (nonatomic, retain) NSNumber * gewonnen;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * zuege;
@property (nonatomic, retain) NSNumber * abgebrochen;
@property (nonatomic, retain) NSNumber * undos;
@property (nonatomic, retain) NSDate * datum;

@end
