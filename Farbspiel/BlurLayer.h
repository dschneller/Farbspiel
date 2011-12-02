//
//  BlurLayer.h
//  Farbspiel
//
//  Created by Daniel Schneller on 02.12.11.
//  Copyright (c) 2011 codecentric AG. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface BlurLayer : CAGradientLayer

+(CAGradientLayer*) layerForParentView:(UIView*)view;

@end

