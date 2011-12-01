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
#import "StatistikView.h"
#import "StatistikViewController.h"

@interface FarbspielViewController : UIViewController
<SpielrasterViewControllerDelegate, UIPopoverControllerDelegate> {
    
    
    SpielLevel _defaultLevel;
}

@property (strong, nonatomic) IBOutletCollection(ColorfulButton) NSArray *allColorButtons;

@property (weak, nonatomic) IBOutlet UIButton *debugButtonVerlieren;
@property (weak, nonatomic) IBOutlet UIButton *debugButtonGewinnen;
@property (weak, nonatomic) IBOutlet UILabel *gewonnenInXZuegenLabel;
@property (weak, nonatomic) IBOutlet UILabel *gewonnenVerlorenLabel;
@property (weak, nonatomic) IBOutlet UIView *gewonnenView;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet SpielrasterViewController *rasterController;
@property (weak, nonatomic) IBOutlet UIButton *settingsToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *soundAnAusButton;
@property (weak, nonatomic) IBOutlet UILabel *spieldauerLabel;
@property (weak, nonatomic) IBOutlet SpielrasterView *spielrasterView;
@property (weak, nonatomic) IBOutlet UILabel *uhrLabel;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *undoSwipeGestureRecognizer;

@property (assign, nonatomic) SpielLevel defaultLevel;
@property (strong, nonatomic) ColorfulButton *einstellungenButton;
@property (strong, nonatomic) UIAlertView* neuesSpielAlert;
@property (strong, nonatomic) ColorfulButton *neuesSpielButton;
@property (strong, nonatomic) UIPopoverController* settingsPopoverController;
@property (strong, nonatomic) StatistikView *statistikPlaceholder;
@property (strong, nonatomic) StatistikViewController *statistikViewController;
@property (strong, nonatomic) NSUndoManager *undoManager; // override to enable writing





- (IBAction)neuesSpiel:(id)sender;
- (IBAction)colorButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;
- (IBAction)soundAnAus:(id)sender;
- (IBAction)gitterAnAus:(id)sender;

- (void)settingsGeaendert:(Spielmodel*)modelAusSettings;

@end
