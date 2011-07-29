//
//  FarbspielViewController.h
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertView-BKAdditions.h"
#import "SpielrasterView.h"
#import "SpielrasterViewController.h"
#import "ColorfulButton.h"
#import "SoundManager.h"

@interface FarbspielViewController : UIViewController <SpielrasterViewControllerDelegate> {
    
//    SpielrasterViewController *rasterController_;
    
    IBOutlet UIButton *debugButtonVerlieren;
    IBOutlet UIView *gewonnenView;
    
    IBOutlet UILabel *gewonnenVerlorenLabel;
    IBOutlet UILabel *gewonnenInXZuegenLabel;
    IBOutlet UILabel *spieldauerLabel;
    IBOutlet UILabel *uhrLabel;
    IBOutlet UILabel *levelLabel;
    
    IBOutlet UILabel *anzahlSpieleLabel;
    IBOutlet UILabel *anzahlGewonnenLabel;
    IBOutlet UILabel *prozentGewonnenLabel;
    IBOutlet UILabel *anzahlVerlorenLabel;
    
    IBOutlet ColorfulButton *einstellungenButton;
    IBOutlet ColorfulButton *neuesSpielButton_;
    IBOutlet SpielrasterViewController *rasterController;
    IBOutlet SpielrasterView *spielrasterView_;
    IBOutlet ColorfulButton *farbe0Button_;
    IBOutlet ColorfulButton *farbe1Button_;
    IBOutlet ColorfulButton *farbe2Button_;
    IBOutlet ColorfulButton *farbe3Button_;
    IBOutlet ColorfulButton *farbe4Button_;
    IBOutlet ColorfulButton *farbe5Button_;
    
    IBOutlet UIButton *soundAnAusButton_;
    CAGradientLayer *blurLayer_;

    Spielmodel* neuesModel_;
    SpielLevel defaultLevel_;
}

@property (nonatomic,retain) SpielrasterViewController* rasterController;
@property (nonatomic,assign) SpielLevel defaultLevel;

- (IBAction)neuesSpiel:(id)sender;
- (IBAction)colorButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;
- (IBAction)soundAnAus:(id)sender;
- (IBAction)gitterAnAus:(id)sender;

- (void)settingsGeaendert:(Spielmodel*)modelAusSettings;

@end
