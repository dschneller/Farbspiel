//
//  BlurLayer.m
//  Farbspiel
//
//  Created by Daniel Schneller on 02.12.11.
//  Copyright (c) 2011 codecentric AG. All rights reserved.
//

#import "BlurLayer.h"
#import "UIColor+Tools.h"

@implementation BlurLayer
    
+(CAGradientLayer*) layerForParentView:(UIView*)view {
    CAGradientLayer* blurLayer = [CAGradientLayer layer];
    blurLayer.frame = view.bounds;
    blurLayer.colors = [NSArray arrayWithObjects:(id)[[[UIColor darkGrayColor] colorByChangingAlphaTo:0.7f] CGColor], (id)[[[[UIColor darkGrayColor] colorByDarkeningColor] colorByChangingAlphaTo:0.7f] CGColor], nil];
    
    return blurLayer;
}

@end
