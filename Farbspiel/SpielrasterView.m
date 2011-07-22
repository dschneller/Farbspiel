//
//  SpielrasterView.m
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpielrasterView.h"
#import "Farbmapping.h"


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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!self.dataSource) {
        return;
    }
    
    
    int numRows = [self.dataSource rasterZeilen];
    int numCols = [self.dataSource rasterSpalten];
    
    CGFloat fieldWidth = rect.size.width / numCols;
    CGFloat fieldHeight = rect.size.height / numRows;
    [[UIColor clearColor] setStroke];
    for (int row=0; row<numRows; row++) {
        for (int col=0; col<numCols; col++) {
            CGFloat x = col * fieldWidth;
            CGFloat y = row * fieldHeight;
            
            int colorNum = [[self.dataSource farbeFuerRasterfeldZeile:row spalte:col] intValue];
            
            CGRect rectangle = CGRectMake(x,y,fieldWidth,fieldHeight);
            UIColor* color = [Farbmapping farbeMitNummer:colorNum]; 
            [color setFill];
            UIRectFill(rectangle);
        }
    }
    
    
    
    //Get the CGContext from this view
	CGContextRef context = UIGraphicsGetCurrentContext();
	//Set the stroke (pen) color
	CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
	//Set the width of the pen mark
	CGContextSetLineWidth(context, 2.0);
    
    for (int row=1; row<numRows; row++) {
        for (int col=1; col<numCols; col++) {
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
