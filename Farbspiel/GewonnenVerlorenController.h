//
//  GewonnenVerlorenController.h
//  Farbspiel
//
//  Created by Daniel Schneller on 02.12.11.
//  Copyright (c) 2011 codecentric AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorfulButton.h"
#import "GewonnenVerlorenView.h"
#import "StatistikView.h"
#import "StatistikViewController.h"
#import "Spielmodel.h"

@class FarbspielViewController;

@interface GewonnenVerlorenController : NSObject

@property (weak, nonatomic) IBOutlet StatistikView *statistikPlaceholder;
@property (strong, nonatomic) IBOutlet StatistikViewController *statistikViewController;
@property (weak, nonatomic) IBOutlet ColorfulButton *neuesSpielButton;
@property (weak, nonatomic) IBOutlet ColorfulButton *einstellungenButton;

@property (strong, nonatomic) IBOutlet GewonnenVerlorenView* view;
@property (weak, nonatomic) IBOutlet UILabel *gewonnenInXZuegenLabel;
@property (weak, nonatomic) IBOutlet UILabel *gewonnenVerlorenLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *spieldauerLabel;
@property (weak, nonatomic) IBOutlet FarbspielViewController* delegate;

@property (strong, nonatomic, readonly) CAGradientLayer* blurLayer;


- (IBAction)neuesSpiel:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;

- (void) fadeOut;
- (void) zeigeGewonnenInZuegen:(Spielmodel*)model onView:(UIView*) parentView;


@end
