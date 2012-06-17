//
//  SettingsViewController.h
//  Farbspiel
//
//  Created by Schneller Daniel on 26.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "StatistikViewController.h"
#import "StatistikView.h"
#import "Spielmodel.h"
#import "SoundManager.h"

@interface SettingsViewController : UIViewController {
}

@property (nonatomic, weak) IBOutlet UIButton *statistikLoeschenButton;
@property (nonatomic, strong) IBOutlet StatistikViewController *statistikViewController;
@property (nonatomic, weak) IBOutlet StatistikView *statistikPlaceholderView;
@property (nonatomic, strong) Spielmodel *passedInModel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *schwierigkeitsGrad;
@property (nonatomic, weak) IBOutlet UILabel *feldgroesseLabel;
@property (nonatomic, weak) IBOutlet UILabel *anzahlZuegeLabel;
@property (nonatomic, weak) IBOutlet UISwitch *soundEffekteSwitch;
@property (nonatomic, weak) IBOutlet UISegmentedControl *farbschema;
@property (nonatomic, weak) IBOutlet UISwitch *rasterSwitch;
@property (nonatomic, weak) IBOutlet UISegmentedControl *fuellmodus;

@property (nonatomic, weak) IBOutlet UIView *farbe1;
@property (nonatomic, weak) IBOutlet UIView *farbe2;
@property (nonatomic, weak) IBOutlet UIView *farbe3;
@property (nonatomic, weak) IBOutlet UIView *farbe4;
@property (nonatomic, weak) IBOutlet UIView *farbe5;
@property (nonatomic, weak) IBOutlet UIView *farbe6;
@property (nonatomic, weak) IBOutlet UIView *farbPreviewRahmen;
@property (nonatomic, weak) IBOutlet UIView *farbe1bg;
@property (nonatomic, weak) IBOutlet UIView *farbe2bg;
@property (nonatomic, weak) IBOutlet UIView *farbe3bg;
@property (nonatomic, weak) IBOutlet UIView *farbe4bg;
@property (nonatomic, weak) IBOutlet UIView *farbe5bg;
@property (nonatomic, weak) IBOutlet UIView *farbe6bg;

- (IBAction)zurueckZumSpiel:(id)sender;
- (IBAction)soundAnAus:(id)sender;
- (IBAction)levelGewaehlt:(id)sender;
- (IBAction)farbschemaGewaehlt:(id)sender;
- (IBAction)rasterAnAus:(id)sender;
- (IBAction)resetStats:(id)sender;

@end
