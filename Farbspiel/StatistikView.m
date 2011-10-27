//
//  StatistikView.m
//  Farbspiel
//
//  Created by Daniel Schneller on 19.09.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import "StatistikView.h"

@implementation StatistikView
@synthesize anzahlSpiele = _anzahlSpiele;
@synthesize anzahlGewonnen = _anzahlGewonnen;
@synthesize anzahlVerloren = _anzahlVerloren;
@synthesize prozentGewonnen = _prozentGewonnen;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
