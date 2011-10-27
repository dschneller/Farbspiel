//
//  StatistikViewController.m
//  Farbspiel
//
//  Created by Daniel Schneller on 19.09.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import "StatistikViewController.h"


@implementation StatistikViewController

@synthesize anzahlSpiele = anzahlSpiele_;
@synthesize anzahlGewonnen = anzahlGewonnen_;
@synthesize statistikView = statistikView_;

- (id)init
{
    self = [super init];
    if (self) {
        self.anzahlSpiele = 0;
        self.anzahlGewonnen = 0;
    }
    
    return self;
}


-(NSUInteger) anzahlVerloren {
    return self.anzahlSpiele - self.anzahlGewonnen;
}

-(float)prozentGewonnen {
    if (self.anzahlSpiele>0) {
        return (float)self.anzahlGewonnen / (float)self.anzahlSpiele* 100.0f;
    } else {
        return NAN;
    }
}

- (void) updateStatsDisplay {
    lAnzahlSpiele_.text = [NSString stringWithFormat:@"%d", self.anzahlSpiele];
    lAnzahlGewonnen_.text = [NSString stringWithFormat:@"%d", self.anzahlGewonnen];
    lAnzahlVerloren_.text = [NSString stringWithFormat:@"%d",self.anzahlVerloren];
    lProzentGewonnen_.text = [NSString stringWithFormat:@"(%2.1f%%)", self.prozentGewonnen];
    
    if (self.anzahlSpiele>0) {
        lProzentGewonnen_.hidden = NO;
    } else {
        lProzentGewonnen_.hidden = YES;
    }
//    [self.statistikView setNeedsDisplay];

}

-(void) setAnzahlSpiele:(NSUInteger)anzahl {
    anzahlSpiele_ = anzahl;
    [self updateStatsDisplay];
}

-(void) setAnzahlGewonnen:(NSUInteger)anzahl {
    anzahlGewonnen_ = anzahl;
    [self updateStatsDisplay];
}



@end
