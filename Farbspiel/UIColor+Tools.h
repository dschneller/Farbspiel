//
//  UIColor+Tools.h
//  Farbspiel
//
//  Created by Daniel Schneller on 11.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (Tools)
- (UIColor *)colorByDarkeningColor;
- (UIColor *)colorByChangingAlphaTo:(CGFloat)newAlpha;
@end

