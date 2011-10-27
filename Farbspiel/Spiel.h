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
@property (nonatomic, strong) NSNumber * dauer;
@property (nonatomic, strong) NSNumber * gewonnen;
@property (nonatomic, strong) NSNumber * level;
@property (nonatomic, strong) NSNumber * zuege;
@property (nonatomic, strong) NSNumber * abgebrochen;
@property (nonatomic, strong) NSNumber * undos;
@property (nonatomic, strong) NSDate * datum;

@end
