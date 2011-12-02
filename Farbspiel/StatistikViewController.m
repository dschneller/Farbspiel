//
//  StatistikViewController.m
//  Farbspiel
//
//  Created by Daniel Schneller on 19.09.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import "StatistikViewController.h"


@implementation StatistikViewController

@synthesize anzahlSpiele = _anzahlSpiele;
@synthesize anzahlGewonnen = _anzahlGewonnen;

@synthesize statistikView = _statistikView;
@synthesize anzahlSpieleLabel = _anzahlSpieleLabel;
@synthesize anzahlGewonnenLabel = _anzahlGewonnenLabel;
@synthesize anzahlVerlorenLabel = _anzahlVerlorenLabel;
@synthesize prozentGewonnenLabel = _prozentGewonnenLabel;


- (id)init
{
    self = [super init];
    if (self) {
        _anzahlSpiele = 0;
        _anzahlGewonnen = 0;
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
    self.anzahlSpieleLabel.text = [NSString stringWithFormat:@"%d", self.anzahlSpiele];
    self.anzahlGewonnenLabel.text = [NSString stringWithFormat:@"%d", self.anzahlGewonnen];
    self.anzahlVerlorenLabel.text = [NSString stringWithFormat:@"%d",self.anzahlVerloren];
    self.prozentGewonnenLabel.text = [NSString stringWithFormat:@"(%2.1f%%)", self.prozentGewonnen];
    
    if (self.anzahlSpiele>0) {
        self.prozentGewonnenLabel.hidden = NO;
    } else {
        self.prozentGewonnenLabel.hidden = YES;
    }
}

-(void) setAnzahlSpiele:(NSUInteger)anzahl {
    _anzahlSpiele = anzahl;
    [self updateStatsDisplay];
}

-(void) setAnzahlGewonnen:(NSUInteger)anzahl {
    _anzahlGewonnen = anzahl;
    [self updateStatsDisplay];
}



@end
