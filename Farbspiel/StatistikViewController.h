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
}


@property (weak, nonatomic) IBOutlet StatistikView *statistikView;
@property (weak, nonatomic) IBOutlet UILabel *anzahlSpieleLabel;
@property (weak, nonatomic) IBOutlet UILabel *anzahlGewonnenLabel;
@property (weak, nonatomic) IBOutlet UILabel *anzahlVerlorenLabel;
@property (weak, nonatomic) IBOutlet UILabel *prozentGewonnenLabel;


@property (nonatomic) NSUInteger anzahlSpiele;
@property (nonatomic) NSUInteger anzahlGewonnen;
@property (nonatomic,readonly) NSUInteger anzahlVerloren;
@property (nonatomic,readonly) float prozentGewonnen;


@end
