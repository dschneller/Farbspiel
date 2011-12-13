//
//  Farbmapping.h
//  Farbspiel
//
//  Created by Daniel Schneller on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Farbmapping : NSObject {
    int farbschema_;
}

+(Farbmapping*) sharedInstance;

@property (nonatomic) int farbschema;

-(UIColor*) farbeMitNummer:(int)farbnummer;
-(UIColor*) shadeFarbeMitNummer:(int)farbnummer;
-(NSString*) imageNameForColor:(NSUInteger)color andSize:(NSUInteger)width;

@end
