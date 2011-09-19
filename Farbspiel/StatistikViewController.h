//
//  StatistikViewController.h
//  Farbspiel
//
//  Created by Daniel Schneller on 19.09.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatistikView.h"

@interface StatistikViewController : NSObject {
    IBOutlet StatistikView *statistikView_;
    IBOutlet UILabel *lAnzahlSpiele_;
    IBOutlet UILabel *lAnzahlGewonnen_;
    IBOutlet UILabel *lAnzahlVerloren_;
    IBOutlet UILabel *lProzentGewonnen_;
    
    NSUInteger anzahlSpiele_;
    NSUInteger anzahlGewonnen_;
}

@property (nonatomic, retain) StatistikView* statistikView;
@property (nonatomic) NSUInteger anzahlSpiele;
@property (nonatomic) NSUInteger anzahlGewonnen;
@property (nonatomic,readonly) NSUInteger anzahlVerloren;
@property (nonatomic,readonly) float prozentGewonnen;


@end
