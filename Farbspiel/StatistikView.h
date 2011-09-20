//
//  StatistikView.h
//  Farbspiel
//
//  Created by Daniel Schneller on 19.09.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatistikView : UIView {
    UILabel *_anzahlSpiele;
    UILabel *_anzahlGewonnen;
    UILabel *_anzahlVerloren;
    UILabel *_prozentGewonnen;
}

@property (nonatomic, retain) IBOutlet UILabel *anzahlSpiele;
@property (nonatomic, retain) IBOutlet UILabel *anzahlGewonnen;
@property (nonatomic, retain) IBOutlet UILabel *anzahlVerloren;
@property (nonatomic, retain) IBOutlet UILabel *prozentGewonnen;

@end