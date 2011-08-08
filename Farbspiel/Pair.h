//
//  Pair.h
//  Farbspiel
//
//  Created by Daniel Schneller on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Pair : NSObject {
    NSUInteger x_;
    NSUInteger y_;
}


@property (readonly, nonatomic) NSUInteger x;
@property (readonly, nonatomic) NSUInteger y;


+(Pair*)pairWithX:(NSUInteger )x Y:(NSUInteger )y;


@end
