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
#import "StatistikView.h"
#import "StatistikViewController.h"

@interface FarbspielViewController : UIViewController <SpielrasterViewControllerDelegate, UIPopoverControllerDelegate> {
    
    IBOutletCollection(ColorfulButton) NSArray *allColorButtons;
    
    IBOutlet UIButton *debugButtonVerlieren;
    IBOutlet UIButton *debugButtonGewinnen;
    IBOutlet UIView *gewonnenView;
    
    IBOutlet UILabel *gewonnenVerlorenLabel;
    IBOutlet UILabel *gewonnenInXZuegenLabel;
    IBOutlet UILabel *spieldauerLabel;
    IBOutlet UILabel *uhrLabel;
    IBOutlet UILabel *levelLabel;

    IBOutlet UIButton *settingsToggleButton;
    IBOutlet StatistikViewController *statistikViewController_;
    IBOutlet StatistikView *statistikPlaceholder_;
    IBOutlet ColorfulButton *einstellungenButton;
    IBOutlet ColorfulButton *neuesSpielButton_;
    IBOutlet SpielrasterViewController *rasterController;
    IBOutlet SpielrasterView *spielrasterView_;
    IBOutlet UIButton *soundAnAusButton_;
    CAGradientLayer *blurLayer_;

    SpielLevel defaultLevel_;
}

@property (nonatomic,retain) SpielrasterViewController* rasterController;
@property (nonatomic,assign) SpielLevel defaultLevel;

@property (retain) NSUndoManager *undoManager; // override to enable writing

- (IBAction)neuesSpiel:(id)sender;
- (IBAction)colorButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;
- (IBAction)soundAnAus:(id)sender;
- (IBAction)gitterAnAus:(id)sender;

- (void)settingsGeaendert:(Spielmodel*)modelAusSettings;

@end
