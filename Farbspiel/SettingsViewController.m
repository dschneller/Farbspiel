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

@implementation SettingsViewController

@synthesize passedInModel = passedInModel_;
@synthesize aufrufenderController = aufrufenderController_;

@synthesize schwierigkeitsGrad;
@synthesize feldgroesseLabel;
@synthesize anzahlZuegeLabel;
@synthesize soundEffekteSwitch;
@synthesize rasterSwitch = rasterSwitch_;
@synthesize farbschema;

@synthesize farbPreviewRahmen = farbPreviewRahmen_;
@synthesize farbe1 = farbe1_;
@synthesize farbe2 = farbe2_;
@synthesize farbe3 = farbe3_;
@synthesize farbe4 = farbe4_;
@synthesize farbe5 = farbe5_;
@synthesize farbe6 = farbe6_;
@synthesize farbe1bg = farbe1bg_;
@synthesize farbe2bg = farbe2bg_;
@synthesize farbe3bg = farbe3bg_;
@synthesize farbe4bg = farbe4bg_;
@synthesize farbe5bg = farbe5bg_;
@synthesize farbe6bg = farbe6bg_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

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
    
    statistikViewController_.anzahlSpiele = anzahlSpiele;
    statistikViewController_.anzahlGewonnen = anzahlGewonnen;

}

- (void) initValues {
    self.soundEffekteSwitch.on = [[SoundManager sharedManager] soundAn];
    self.schwierigkeitsGrad.selectedSegmentIndex = [[Datenhaltung sharedInstance] integerFuerKey:PREFKEY_SPIELLEVEL];
    self.farbschema.selectedSegmentIndex = [Farbmapping sharedInstance].farbschema;
    self.rasterSwitch.on = [[Datenhaltung sharedInstance] boolFuerKey:PREFKEY_GITTER_AN];
    [self updateFarbschemaPreview];
    [self updateStatsView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"StatistikView" owner:statistikViewController_ options:nil];
    StatistikView *statistikView = [(StatistikView *)[views objectAtIndex:0] retain];
    
    [statistikPlaceholderView_ addSubview:statistikView];
    statistikViewController_.statistikView = statistikView;

    
    [self setupLayerPropsForView:farbPreviewRahmen_ showBorder:YES];
    
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


- (void)viewDidUnload
{
    [self setSchwierigkeitsGrad:nil];
    [self setFeldgroesseLabel:nil];
    [self setAnzahlZuegeLabel:nil];
    [self setSoundEffekteSwitch:nil];
    [self setFarbschema:nil];
    [self setFarbe1:nil];
    [self setFarbe2:nil];
    [self setFarbe3:nil];
    [self setFarbe4:nil];
    [self setFarbe5:nil];
    [self setFarbe6:nil];
    [self setFarbPreviewRahmen:nil];
    [self setFarbe1bg:nil];
    [self setFarbe2bg:nil];
    [self setFarbe3bg:nil];
    [self setFarbe4bg:nil];
    [self setFarbe5bg:nil];
    [self setFarbe6bg:nil];
    [self setRasterSwitch:nil];
    [statistikViewController_ release];
    statistikViewController_ = nil;
    [statistikPlaceholderView_ release];
    statistikPlaceholderView_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [schwierigkeitsGrad release];
    [feldgroesseLabel release];
    [anzahlZuegeLabel release];
    [soundEffekteSwitch release];
    [farbPreviewRahmen_ release];
    [farbschema release];
    [farbe1_ release];
    [farbe2_ release];
    [farbe3_ release];
    [farbe4_ release];
    [farbe5_ release];
    [farbe6_ release];
    [farbe1bg_ release];
    [farbe2bg_ release];
    [farbe3bg_ release];
    [farbe4bg_ release];
    [farbe5bg_ release];
    [farbe6bg_ release];
    [rasterSwitch_ release];
    [passedInModel_ release];
    [aufrufenderController_ release];
    [statistikViewController_ release];
    [statistikPlaceholderView_ release];
    [super dealloc];
}

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
    [[Datenhaltung sharedInstance] setInteger:level fuerKey:PREFKEY_SPIELLEVEL];
    Spielmodel* newModel = [[[Spielmodel alloc] initWithLevel:level] autorelease];
    [self.aufrufenderController settingsGeaendert:newModel];
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
