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
    
    IBOutlet ColorfulButton *neuesSpielButton_;
    IBOutlet SpielrasterViewController *rasterController;
    IBOutlet SpielrasterView *spielrasterView_;
    IBOutlet ColorfulButton *farbe0Button_;
    IBOutlet ColorfulButton *farbe1Button_;
    IBOutlet ColorfulButton *farbe2Button_;
    IBOutlet ColorfulButton *farbe3Button_;
    IBOutlet ColorfulButton *farbe4Button_;
    IBOutlet ColorfulButton *farbe5Button_;
    
    CAGradientLayer *blurLayer_;
    
    
//    BOOL displayingPrimary;
}

@property (nonatomic,retain) SpielrasterViewController* rasterController;


- (IBAction)neuesSpiel:(id)sender;
- (IBAction)colorButtonPressed:(id)sender;
- (IBAction)settingsButtonPressed:(id)sender;

@end
