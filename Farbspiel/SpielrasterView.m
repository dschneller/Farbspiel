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


@implementation SpielrasterView

@synthesize raster = raster_;
@synthesize dataSource = dataSource_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)zeichneGitter:(CGFloat)fieldHeight fieldWidth:(CGFloat)fieldWidth numCols:(int)numCols numRows:(int)numRows
{
    // Gitter zeichnen
    if ([[Datenhaltung sharedInstance] boolFuerKey:PREFKEY_GITTER_AN]) {
        
        //Get the CGContext from this view
        CGContextRef context = UIGraphicsGetCurrentContext();
        //Set the stroke (pen) color
        CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
        //Set the width of the pen mark
        CGContextSetLineWidth(context, 2.0);
        
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
}


- (void)drawTileWithColor:(NSUInteger)colorNum inRect:(CGRect)rectangle {
    NSString* imgName = [[Farbmapping sharedInstance] imageNameForColor:colorNum andSize:[[NSNumber numberWithFloat:rectangle.size.width] unsignedIntegerValue]];
    
    UIImage *img = [UIImage imageNamed:imgName];
    if (!img) {
        LOG_UI(1, @"Cannot find image named %@", imgName);
        UIColor* color = [[Farbmapping sharedInstance] farbeMitNummer:colorNum]; 
        [color setFill];
        [color setStroke];
        UIRectFill(rectangle);
    } else {
        
        if (rectangle.size.width != img.size.width) {
            LOG_UI(2, @"Tile width %g not matching image file width %f for image %@", rectangle.size.width, img.size.width, imgName);
        }
        
        if (rectangle.size.height != img.size.height) {
            LOG_UI(2, @"Tile height %g not matching image file width %f for image %@", rectangle.size.height, img.size.height, imgName);
        }
        LOG_UI(3, @"Using image %@ for tile (%g,%g/%g,%g)", imgName, rectangle.origin.x, rectangle.origin.y, rectangle.size.width, rectangle.size.height);
        [img drawInRect:rectangle];
    }

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.duration = 0.1f;
    [self.layer addAnimation:animation forKey:@"contents"];
    
    if (!self.dataSource) {
        return;
    }
    int numRows = [self.dataSource rasterZeilen];
    int numCols = [self.dataSource rasterSpalten];
    
    CGFloat fieldWidthF = rect.size.width / numCols;
    NSUInteger fieldWidth = [[NSNumber numberWithFloat:fieldWidthF] intValue];
    
    CGFloat fieldHeightF = rect.size.height / numRows;
    NSUInteger fieldHeight = [[NSNumber numberWithFloat:fieldHeightF] intValue];

    
    for (NSUInteger row=0; row<numRows; row++) {
        for (NSUInteger col=0; col<numCols; col++) {
            CGFloat x = col * fieldWidth;
            CGFloat y = row * fieldHeight;
            
            NSUInteger colorNum = [[self.dataSource farbeFuerRasterfeldZeile:row spalte:col] intValue];
            
            CGRect rectangle = CGRectMake(x,y,fieldWidth,fieldHeight);
            [self drawTileWithColor:colorNum inRect:rectangle];

        }
    }
    
    [self zeichneGitter:fieldHeight fieldWidth:fieldWidth numCols:numCols numRows:numRows];
}




@end
