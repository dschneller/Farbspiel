//
//  NSMutableArray+StackMethods.h
//  Farbspiel
//
//  Created by Daniel Schneller on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSMutableArray (NSMutableArray_StackMethods)
-(void) push:(id) item;
-(id) pop;

@end
