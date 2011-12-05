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
    UISegmentedControl *schwierigkeitsGrad;
    UILabel *feldgroesseLabel;
    UILabel *anzahlZuegeLabel;
    UISwitch *soundEffekteSwitch;
    UISegmentedControl *farbschema;
    UIView *farbPreviewRahmen_;
    UIView *farbe1_;
    UIView *farbe2_;
    UIView *farbe3_;
    UIView *farbe4_;
    UIView *farbe5_;
    UIView *farbe6_;
    UISwitch *rasterSwitch_;
    IBOutlet UIButton *statistikLoeschenButton_;
    
    IBOutlet StatistikViewController *statistikViewController_;
    IBOutlet StatistikView *statistikPlaceholderView_;
    Spielmodel* passedInModel_;
    UIView *farbe1bg_;
    UIView *farbe2bg_;
    UIView *farbe3bg_;
    UIView *farbe4bg_;
    UIView *farbe5bg_;
    UIView *farbe6bg_;
}


@property (nonatomic, strong) Spielmodel *passedInModel;
@property (nonatomic, strong) IBOutlet UISegmentedControl *schwierigkeitsGrad;
@property (nonatomic, strong) IBOutlet UILabel *feldgroesseLabel;
@property (nonatomic, strong) IBOutlet UILabel *anzahlZuegeLabel;
@property (nonatomic, strong) IBOutlet UISwitch *soundEffekteSwitch;
@property (nonatomic, strong) IBOutlet UISegmentedControl *farbschema;
@property (nonatomic, strong) IBOutlet UISwitch *rasterSwitch;

@property (nonatomic, strong) IBOutlet UIView *farbe1;
@property (nonatomic, strong) IBOutlet UIView *farbe2;
@property (nonatomic, strong) IBOutlet UIView *farbe3;
@property (nonatomic, strong) IBOutlet UIView *farbe4;
@property (nonatomic, strong) IBOutlet UIView *farbe5;
@property (nonatomic, strong) IBOutlet UIView *farbe6;
@property (nonatomic, strong) IBOutlet UIView *farbPreviewRahmen;
@property (nonatomic, strong) IBOutlet UIView *farbe1bg;
@property (nonatomic, strong) IBOutlet UIView *farbe2bg;
@property (nonatomic, strong) IBOutlet UIView *farbe3bg;
@property (nonatomic, strong) IBOutlet UIView *farbe4bg;
@property (nonatomic, strong) IBOutlet UIView *farbe5bg;
@property (nonatomic, strong) IBOutlet UIView *farbe6bg;

- (IBAction)zurueckZumSpiel:(id)sender;
- (IBAction)soundAnAus:(id)sender;
- (IBAction)levelGewaehlt:(id)sender;
- (IBAction)farbschemaGewaehlt:(id)sender;
- (IBAction)rasterAnAus:(id)sender;
- (IBAction)resetStats:(id)sender;

@end
