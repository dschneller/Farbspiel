//
//  SpielrasterView.m
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpielrasterView.h"
#import "Farbmapping.h"
#import "Datenhaltung.h"
#import "Pair.h"


@implementation SpielrasterView

- (void) prepareSublayers {
    if (_layerDict) {
        for (id p in _layerDict) {
            [_layerDict[p] removeFromSuperlayer];
        }
    }
    _layerDict = [NSMutableDictionary dictionary];

    NSUInteger rows = [self.dataSource rasterZeilen];
    NSUInteger cols = [self.dataSource rasterSpalten];
    CGFloat w = self.bounds.size.width / cols;
    CGFloat h = self.bounds.size.height / rows;

    for (NSUInteger row = 0; row < rows; row ++) {
        for (NSUInteger col = 0; col < cols ; col ++) {
            Pair *p = [Pair pairWithX:col Y:row];
            CALayer *tileLayer = [[CALayer alloc] init];
            CGRect f = CGRectMake(col * w, row * h, w, h);
            tileLayer.frame = f;
            LOG_UI(1, @"x,y,w,h: %f,%f,%f,%f", f.origin.x, f.origin.y, f.size.width, f.size.height);
            NSNumber* farbe = [self.dataSource farbeFuerRasterfeldZeile:row spalte:col];
            NSString* imgName = [[Farbmapping sharedInstance] imageNameForColor:[farbe intValue] andSize:w];
            
            UIImage *img = [UIImage imageNamed:imgName];
            tileLayer.contents = (id)[img CGImage];
            tileLayer.opaque=YES;
            
            [self.layer addSublayer:tileLayer];
            (self.layerDict)[p] = tileLayer;
        }
    }

    // Gitterlayer
    self.gridLayer = [CALayer layer];
    CGRect gridLayerFrame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
    self.gridLayer.frame = gridLayerFrame;
    UIGraphicsBeginImageContextWithOptions(gridLayerFrame.size, NO, [UIScreen mainScreen].scale);
    [self zeichneGitter:h fieldWidth:w numCols:cols numRows:rows];
    UIImage *gitter = UIGraphicsGetImageFromCurrentImageContext();
    self.gridLayer.contents=(id)[gitter CGImage];
    UIGraphicsEndImageContext();

    if ([[Datenhaltung sharedInstance] boolFuerKey:PREFKEY_GITTER_AN]) {
        [self.layer addSublayer:self.gridLayer];
    }
}

- (UIImage*) snapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, [[UIScreen mainScreen] scale]);
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void) neuenSnapshotInstallieren {
    
}


- (void)zeichneGitter:(CGFloat)fieldHeight fieldWidth:(CGFloat)fieldWidth numCols:(int)numCols numRows:(int)numRows
{
        //Get the CGContext from this view
        CGContextRef context = UIGraphicsGetCurrentContext();
        //Set the stroke (pen) color
        CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
        //Set the width of the pen mark
        CGContextSetLineWidth(context, 1.0f);
        
        for (NSUInteger row=1; row<numRows; row++) {
            for (NSUInteger col=1; col<numCols; col++) {
                CGFloat x = col * fieldWidth;
                
                // Draw a line
                //Start at this point
                CGContextMoveToPoint(context, x, 0);
                
                //Give instructions to the CGContext
                //(move "pen" around the screen)
                CGContextAddLineToPoint(context, x, self.bounds.size.height);
                
                //Draw it
                CGContextStrokePath(context);
            }
            CGFloat y = row * fieldHeight;
            
            // Draw a line
            //Start at this point
            CGContextMoveToPoint(context, 0, y);
            
            //Give instructions to the CGContext
            //(move "pen" around the screen)
            CGContextAddLineToPoint(context, self.bounds.size.width, y);
            
            //Draw it
            CGContextStrokePath(context);
            
        }
}

@end
