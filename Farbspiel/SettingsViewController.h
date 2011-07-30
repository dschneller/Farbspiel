//
//  SettingsViewController.h
//  Farbspiel
//
//  Created by Schneller Daniel on 26.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "FarbspielViewController.h"

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

    UIView *farbPreviewRahmen;
    
    Spielmodel* passedInModel_;
    FarbspielViewController *aufrufenderController_;
}


@property (nonatomic, retain) Spielmodel *passedInModel;
@property (nonatomic, retain) FarbspielViewController *aufrufenderController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *schwierigkeitsGrad;
@property (nonatomic, retain) IBOutlet UILabel *feldgroesseLabel;
@property (nonatomic, retain) IBOutlet UILabel *anzahlZuegeLabel;
@property (nonatomic, retain) IBOutlet UISwitch *soundEffekteSwitch;
@property (nonatomic, retain) IBOutlet UISegmentedControl *farbschema;

@property (nonatomic, retain) IBOutlet UIView *farbe1;
@property (nonatomic, retain) IBOutlet UIView *farbe2;
@property (nonatomic, retain) IBOutlet UIView *farbe3;
@property (nonatomic, retain) IBOutlet UIView *farbe4;
@property (nonatomic, retain) IBOutlet UIView *farbe5;
@property (nonatomic, retain) IBOutlet UIView *farbe6;
@property (nonatomic, retain) IBOutlet UIView *farbPreviewRahmen;

- (IBAction)zurueckZumSpiel:(id)sender;
- (IBAction)soundAnAus:(id)sender;
- (IBAction)levelGewaehlt:(id)sender;
- (IBAction)farbschemaGewaehlt:(id)sender;


@end
