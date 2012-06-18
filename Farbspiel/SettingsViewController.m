//
//  SettingsViewController.m
//  Farbspiel
//
//  Created by Schneller Daniel on 26.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "Farbmapping.h"
#import "Datenhaltung.h"
#import "LambdaSheet.h"

@implementation SettingsViewController


#pragma mark - View lifecycle

- (void)setupLayerPropsForView:(UIView*)aView showBorder:(BOOL)border {
    aView.layer.masksToBounds = YES;
    if (border) {
        aView.layer.cornerRadius = 2.0f;
        aView.layer.borderWidth = 1.0f;
    } else {
        aView.layer.cornerRadius = 0.0f;
        aView.layer.borderWidth = 0.0f;
    }
}

-(void) updateFarbschemaPreview {
    UIColor* col1 = [[Farbmapping sharedInstance] farbeMitNummer:0];
    UIColor* col2 = [[Farbmapping sharedInstance] farbeMitNummer:1];
    UIColor* col3 = [[Farbmapping sharedInstance] farbeMitNummer:2];
    UIColor* col4 = [[Farbmapping sharedInstance] farbeMitNummer:3];
    UIColor* col5 = [[Farbmapping sharedInstance] farbeMitNummer:4];
    UIColor* col6 = [[Farbmapping sharedInstance] farbeMitNummer:5];
    UIColor* clear = [UIColor clearColor];
    
    BOOL raster = self.rasterSwitch.on;
    [self setupLayerPropsForView:self.farbe1 showBorder:raster];
    [self setupLayerPropsForView:self.farbe2 showBorder:raster];
    [self setupLayerPropsForView:self.farbe3 showBorder:raster];
    [self setupLayerPropsForView:self.farbe4 showBorder:raster];
    [self setupLayerPropsForView:self.farbe5 showBorder:raster];
    [self setupLayerPropsForView:self.farbe6 showBorder:raster];

    [self setupLayerPropsForView:self.farbe1bg showBorder:NO];
    [self setupLayerPropsForView:self.farbe2bg showBorder:NO];
    [self setupLayerPropsForView:self.farbe3bg showBorder:NO];
    [self setupLayerPropsForView:self.farbe4bg showBorder:NO];
    [self setupLayerPropsForView:self.farbe5bg showBorder:NO];
    [self setupLayerPropsForView:self.farbe6bg showBorder:NO];
    
    self.farbe1.backgroundColor = raster ? col1 : clear;
    self.farbe1bg.backgroundColor = raster ? clear : col1;
    self.farbe2.backgroundColor = raster ? col2 : clear;
    self.farbe2bg.backgroundColor = raster ? clear : col2;
    self.farbe3.backgroundColor = raster ? col3 : clear;
    self.farbe3bg.backgroundColor = raster ? clear : col3;
    self.farbe4.backgroundColor = raster ? col4 : clear;
    self.farbe4bg.backgroundColor = raster ? clear : col4;
    self.farbe5.backgroundColor = raster ? col5 : clear;
    self.farbe5bg.backgroundColor = raster ? clear : col5;
    self.farbe6.backgroundColor = raster ? col6 : clear;
    self.farbe6bg.backgroundColor = raster ? clear : col6;
    
    [self.farbPreviewRahmen setNeedsDisplay];
}

- (void)updateStatsView {
    NSUInteger anzahlSpiele = [[Datenhaltung sharedInstance] anzahlSpieleGesamtFuerLevel:self.schwierigkeitsGrad.selectedSegmentIndex];
    NSUInteger anzahlGewonnen = [[Datenhaltung sharedInstance] anzahlSpieleGewonnen:YES fuerLevel:self.schwierigkeitsGrad.selectedSegmentIndex];
    
    self.statistikViewController.anzahlSpiele = anzahlSpiele;
    self.statistikViewController.anzahlGewonnen = anzahlGewonnen;
    self.statistikLoeschenButton.hidden = anzahlSpiele == 0;

}

-(void) updateLevelDetailViewFuerLevel:(SpielLevel)level {
    int kantenlaenge;
    int zuege;
    switch (level) {
        case HARD:
            kantenlaenge = SPALTEN_HARD;
            zuege = ZUEGE_HARD;
            break;
            
        case MEDIUM:
            kantenlaenge = SPALTEN_MEDIUM;
            zuege = ZUEGE_MEDIUM;
            break;
            
        case EASY:
        default:
            kantenlaenge = SPALTEN_EASY;
            zuege = ZUEGE_EASY;
            break;
    }

    self.feldgroesseLabel.text = [NSString stringWithFormat:@"%d x %d", kantenlaenge, kantenlaenge];
    self.anzahlZuegeLabel.text = [NSString stringWithFormat:@"%d", zuege];

}

- (void) initValues {
    self.soundEffekteSwitch.on = [[SoundManager sharedManager] soundAn];
    SpielLevel level = (SpielLevel)[[Datenhaltung sharedInstance] integerFuerKey:PREFKEY_SPIELLEVEL];
    self.schwierigkeitsGrad.selectedSegmentIndex = level;
    self.farbschema.selectedSegmentIndex = [Farbmapping sharedInstance].farbschema;
    self.rasterSwitch.on = [[Datenhaltung sharedInstance] boolFuerKey:PREFKEY_GITTER_AN];
    [self updateLevelDetailViewFuerLevel:level];
    [self updateFarbschemaPreview];
    [self updateStatsView];
}

- (IBAction)resetStats:(id)sender {
    SpielLevel level = (SpielLevel)[[Datenhaltung sharedInstance] integerFuerKey:PREFKEY_SPIELLEVEL];
    LambdaSheet *sheet = [[LambdaSheet alloc] 
                          initWithTitle:[NSString stringWithFormat:
                                         NSLocalizedString(@"Q_STATISTIK_LOESCHEN", nil), 
                                         [Spielmodel levelNameFor:level]]];
    
    [sheet addDestructiveButtonWithTitle:NSLocalizedString(@"Q_STATISTIK_LOESCHEN_JA",nil) block:^{ [[Datenhaltung sharedInstance] resetLevel:self.schwierigkeitsGrad.selectedSegmentIndex];
        [self updateStatsView];
 }];
    [sheet addCancelButtonWithTitle:NSLocalizedString(@"Q_STATISTIK_LOESCHEN_NEIN",nil)];
    [sheet showInView:self.view];
}

#pragma mark - View Life Cycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"StatistikView" owner:self.statistikViewController options:nil];
    StatistikView *statistikView = (StatistikView *)views[0];
    
    self.statistikPlaceholderView.backgroundColor = [UIColor clearColor];
    [self.statistikPlaceholderView addSubview:statistikView];
    self.statistikViewController.statistikView = statistikView;

    [self setupLayerPropsForView:self.farbPreviewRahmen showBorder:YES];
    
    self.contentSizeForViewInPopover = CGSizeMake(320,480);
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self initValues];
    BOOL raster = self.rasterSwitch.on;
    [self setupLayerPropsForView:self.farbe1 showBorder:raster];
    [self setupLayerPropsForView:self.farbe2 showBorder:raster];
    [self setupLayerPropsForView:self.farbe3 showBorder:raster];
    [self setupLayerPropsForView:self.farbe4 showBorder:raster];
    [self setupLayerPropsForView:self.farbe5 showBorder:raster];
    [self setupLayerPropsForView:self.farbe6 showBorder:raster];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - IBActions

- (IBAction)zurueckZumSpiel:(id)sender {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft 
                           forView:self.navigationController.view cache:YES];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
    
}

- (IBAction)soundAnAus:(id)sender {
    [[SoundManager sharedManager] setSoundAn:self.soundEffekteSwitch.on];
}

- (IBAction)levelGewaehlt:(id)sender {
    SpielLevel level = (SpielLevel) self.schwierigkeitsGrad.selectedSegmentIndex;
    [self updateLevelDetailViewFuerLevel:level];
    [[Datenhaltung sharedInstance] setInteger:level fuerKey:PREFKEY_SPIELLEVEL];
    [self updateStatsView];
}

- (IBAction)farbschemaGewaehlt:(id)sender {
    int schema = self.farbschema.selectedSegmentIndex;
    [Farbmapping sharedInstance].farbschema=schema;
    [self updateFarbschemaPreview];
}

- (IBAction)rasterAnAus:(id)sender {
    BOOL raster = [[Datenhaltung sharedInstance] boolFuerKey:PREFKEY_GITTER_AN];
    [[Datenhaltung sharedInstance] setBool:!raster forKey:PREFKEY_GITTER_AN];
    [self updateFarbschemaPreview];
}


@end
