//
//  Pair.h
//  Farbspiel
//
//  Created by Daniel Schneller on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Pair : NSObject {
    int x_;
    int y_;
}


@property (readonly, nonatomic) int x;
@property (readonly, nonatomic) int y;


+(Pair*)pairWithX:(int)x Y:(int)y;


@end
