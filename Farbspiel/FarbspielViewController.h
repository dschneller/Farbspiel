//
//  FarbspielViewController.h
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpielrasterView.h"
#import "SpielrasterViewController.h"
#import "ColorfulButton.h"
#import "SoundManager.h"
#import "GewonnenVerlorenController.h"

@interface FarbspielViewController : UIViewController
<SpielrasterViewControllerDelegate, UIPopoverControllerDelegate> {
    
    
    SpielLevel _defaultLevel;
}

@property (strong, nonatomic) IBOutletCollection(ColorfulButton) NSArray *allColorButtons;

@property (weak, nonatomic) IBOutlet UIButton *debugButtonVerlieren;
@property (weak, nonatomic) IBOutlet UIButton *debugButtonGewinnen;
@property (weak, nonatomic) IBOutlet SpielrasterViewController *rasterController;
@property (weak, nonatomic) IBOutlet UIButton *settingsToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *soundAnAusButton;
@property (weak, nonatomic) IBOutlet SpielrasterView *spielrasterView;
@property (weak, nonatomic) IBOutlet UILabel *uhrLabel;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *undoSwipeGestureRecognizer;
@property (strong, nonatomic) IBOutlet GewonnenVerlorenController* gewonnenVerlorenController;

@property (assign, nonatomic) SpielLevel defaultLevel;
@property (strong, nonatomic) UIAlertView* neuesSpielAlert;
@property (strong, nonatomic) UIPopoverController* settingsPopoverController;
@property (strong, nonatomic) NSUndoManager *undoManager; // override to enable writing


- (void) neuesSpiel;

- (IBAction)colorButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;
- (IBAction)soundAnAus:(id)sender;
- (IBAction)gitterAnAus:(id)sender;

- (void)settingsGeaendert:(Spielmodel*)modelAusSettings;

@end
