//
//  SettingsViewController.m
//  Farbspiel
//
//  Created by Schneller Daniel on 26.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "SoundManager.h"
#import "Spielmodel.h"

@implementation SettingsViewController

@synthesize passedInModel = passedInModel_;
@synthesize aufrufenderController = aufrufenderController_;

@synthesize schwierigkeitsGrad;
@synthesize feldgroesseLabel;
@synthesize anzahlZuegeLabel;
@synthesize soundEffekteSwitch;
@synthesize farbschema;

@synthesize farbe1 = farbe1_;
@synthesize farbe2 = farbe2_;
@synthesize farbe3 = farbe3_;
@synthesize farbe4 = farbe4_;
@synthesize farbe5 = farbe5_;
@synthesize farbe6 = farbe6_;
@synthesize farbPreviewRahmen;

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

- (void)setupLayerPropsForView:(UIView*)aView {
    aView.layer.cornerRadius = 2.0f;
    aView.layer.masksToBounds = YES;
    aView.layer.borderWidth = 1.0f;
}

- (void) initValues {
    self.soundEffekteSwitch.on = [[SoundManager sharedManager] soundAn];
    self.schwierigkeitsGrad.selectedSegmentIndex = self.passedInModel.level;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupLayerPropsForView:self.farbe1];
    [self setupLayerPropsForView:self.farbe2];
    [self setupLayerPropsForView:self.farbe3];
    [self setupLayerPropsForView:self.farbe4];
    [self setupLayerPropsForView:self.farbe5];
    [self setupLayerPropsForView:self.farbe6];
    
    [self setupLayerPropsForView:farbPreviewRahmen_];

}

-(void)viewWillAppear:(BOOL)animated {
    [self initValues];
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
    [farbschema release];
    [farbe1_ release];
    [farbe2_ release];
    [farbe3_ release];
    [farbe4_ release];
    [farbe5_ release];
    [farbe6_ release];
    [farbPreviewRahmen release];
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
    SpielLevel level = self.schwierigkeitsGrad.selectedSegmentIndex;
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
    
    Spielmodel* newModel = [[[Spielmodel alloc] initWithLevel:level] autorelease];
    [self.aufrufenderController settingsGeaendert:newModel];
}
@end
