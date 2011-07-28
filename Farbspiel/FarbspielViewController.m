//
//  FarbspielViewController.m
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "FarbspielViewController.h"
#import "SpielrasterView.h"
#import "Farbmapping.h"
#import "SoundManager.h"
#import "Datenhaltung.h"
#import "UIColor+Tools.h" 
#import "SettingsViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FarbspielViewController

@synthesize rasterController;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    

    [farbe5Button_ release];
    [farbe4Button_ release];
    [farbe3Button_ release];
    [farbe2Button_ release];
    [farbe1Button_ release];
    [farbe0Button_ release];
    [spielrasterView_ release];
    [rasterController release];
    [gewonnenView release];
    [neuesSpielButton_ release];
    [gewonnenInXZuegenLabel release];
    [debugButtonVerlieren release];
    [gewonnenVerlorenLabel release];
    [spieldauerLabel release];
    [levelLabel release];
    [anzahlSpieleLabel release];
    [anzahlGewonnenLabel release];
    [prozentGewonnenLabel release];
    [anzahlVerlorenLabel release];
    [blurLayer_ release];
    [uhrLabel release];
    
    [soundAnAusButton_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (CAGradientLayer*) makeBackgroundGradientLayer {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor darkGrayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor],(id)[[UIColor darkGrayColor] CGColor], nil];
    return gradient;

}

- (CAGradientLayer*) blurLayer {
    if (!blurLayer_) {
        blurLayer_ = [CAGradientLayer layer];
        blurLayer_.frame = self.view.bounds;
        blurLayer_.colors = [NSArray arrayWithObjects:(id)[[[UIColor darkGrayColor] colorByChangingAlphaTo:0.7f] CGColor], (id)[[[[UIColor darkGrayColor] colorByDarkeningColor] colorByChangingAlphaTo:0.7f] CGColor], nil];
        [blurLayer_ retain];
    }
    return blurLayer_;
}

-(void) starteNeuesSpiel {
    self.rasterController.view = spielrasterView_;
    self.rasterController.delegate = self;
    
    Spielmodel* model = [[Spielmodel alloc] initWithLevel:EASY];
    self.rasterController.model = model;
    [model release];
}

#pragma mark - Shake to undo


-(void) undo {
    NSLog(@"UNDO", nil);
}

-(void) frageNachUndo {
    // TODO: Nicht direkt durchgreifen
    if (self.rasterController.model.zuege == 0) { 
        NSLog(@"Noch keine Zuege, ignoriere Undo Request", nil);
        return;
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Undo?" message:@"Möchten Sie den letzten Spielzug zurücknehmen?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja!", nil];
    
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	// NO = 0, YES = 1
	if(buttonIndex == 0) {
        NSLog(@"Undo nicht gewuenscht",nil);
    } else {
        [self undo];
    }
}


-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
   [self frageNachUndo];
}



#pragma mark - View lifecycle

- (void)updateSoundButton:(BOOL)an {
    if (an) {
        [soundAnAusButton_ setImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
    } else {
        [soundAnAusButton_ setImage:[UIImage imageNamed:@"speaker_off"] forState:UIControlStateNormal];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    displayingPrimary = YES;
    
    [farbe0Button_ setHighColor:[Farbmapping farbeMitNummer:0]];
    [farbe0Button_ setLowColor:[Farbmapping shadeFarbeMitNummer:0]];

    [farbe1Button_ setHighColor:[Farbmapping farbeMitNummer:1]];
    [farbe1Button_ setLowColor:[Farbmapping shadeFarbeMitNummer:1]];

    [farbe2Button_ setHighColor:[Farbmapping farbeMitNummer:2]];
    [farbe2Button_ setLowColor:[Farbmapping shadeFarbeMitNummer:2]];

    [farbe3Button_ setHighColor:[Farbmapping farbeMitNummer:3]];
    [farbe3Button_ setLowColor:[Farbmapping shadeFarbeMitNummer:3]];

    [farbe4Button_ setHighColor:[Farbmapping farbeMitNummer:4]];
    [farbe4Button_ setLowColor:[Farbmapping shadeFarbeMitNummer:4]];

    [farbe5Button_ setHighColor:[Farbmapping farbeMitNummer:5]];
    [farbe5Button_ setLowColor:[Farbmapping shadeFarbeMitNummer:5]];
    
     // Set the layer's corner radius
     [[spielrasterView_ layer] setCornerRadius:8.0f];
     // Turn on masking
     [[spielrasterView_ layer] setMasksToBounds:YES];
     // Display a border around the button 
     // with a 1.0 pixel width
     [[spielrasterView_ layer] setBorderWidth:1.0f];

  //  [self.view.layer insertSublayer:[self makeBackgroundGradientLayer] atIndex:0];
    
#if !DEBUG
        [debugButtonVerlieren removeFromSuperview];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(soundStatusDidChange:) 
                                                 name:SOUNDMANAGER_NOTIFICATION_SOUNDAN
                                               object:nil];
    
    [self updateSoundButton:[SoundManager sharedManager].soundAn];
    
    [self starteNeuesSpiel];
}


- (void) soundStatusDidChange:(NSNotification *)notification {
    if ([[notification name] isEqualToString:SOUNDMANAGER_NOTIFICATION_SOUNDAN]) {
        NSLog (@"Successfully received the test notification!");
        NSNumber* wrappedBool = [notification object];
        [self updateSoundButton:[wrappedBool boolValue]];
    }
}

- (IBAction)soundAnAus:(id)sender {
    [[SoundManager sharedManager] schalteSound];
}

- (IBAction)gitterAnAus:(id)sender {
    BOOL an = ![[Datenhaltung sharedInstance] boolFuerKey:PREFKEY_GITTER_AN];
    [[Datenhaltung sharedInstance] setBool:an forKey:PREFKEY_GITTER_AN];
    [self.rasterController.view setNeedsDisplay];
}


-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"Became first responder: %d", [self becomeFirstResponder]);
}

- (void)viewDidUnload
{
    [rasterController release];
    rasterController = nil;
    [farbe5Button_ release];
    farbe5Button_ = nil;
    [farbe4Button_ release];
    farbe4Button_ = nil;
    [farbe3Button_ release];
    farbe3Button_ = nil;
    [farbe2Button_ release];
    farbe2Button_ = nil;
    [farbe1Button_ release];
    farbe1Button_ = nil;
    [farbe0Button_ release];
    farbe0Button_ = nil;
    [spielrasterView_ release];
    spielrasterView_ = nil;
    [rasterController release];
    rasterController = nil;
    [gewonnenView release];
    gewonnenView = nil;
    [neuesSpielButton_ release];
    neuesSpielButton_ = nil;
    [gewonnenInXZuegenLabel release];
    gewonnenInXZuegenLabel = nil;
    [debugButtonVerlieren release];
    debugButtonVerlieren = nil;
    [gewonnenVerlorenLabel release];
    gewonnenVerlorenLabel = nil;
    [spieldauerLabel release];
    spieldauerLabel = nil;
    [levelLabel release];
    levelLabel = nil;
    [anzahlSpieleLabel release];
    anzahlSpieleLabel = nil;
    [anzahlGewonnenLabel release];
    anzahlGewonnenLabel = nil;
    [prozentGewonnenLabel release];
    prozentGewonnenLabel = nil;
    [anzahlVerlorenLabel release];
    anzahlVerlorenLabel = nil;
    [blurLayer_ release];
    blurLayer_ = nil;
    [uhrLabel release];
    uhrLabel = nil;
    
    [soundAnAusButton_ release];
    soundAnAusButton_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) fadeOutGewonnenView {
    [UIView animateWithDuration:0.5
                     animations:^{ 
                         NSLog(@"Fade Out Animation Began");
                         gewonnenView.alpha = 0;
                         [gewonnenView setFrame:CGRectMake(gewonnenView.frame.origin.x, -gewonnenView.frame.size.height, gewonnenView.frame.size.width, gewonnenView.frame.size.height)];
                     } 
                     completion:^(BOOL finished){
                         NSLog(@"Fade Out Animation Finished");

                         [gewonnenView removeFromSuperview];
                         [gewonnenView release];
                         [[self blurLayer] removeFromSuperlayer];
                         gewonnenView = nil;
                     }];

}

- (void) loadAndInitGewonnenView {
    if (!gewonnenView) {
        UINib* nib = [UINib nibWithNibName:@"GewonnenView" bundle:[NSBundle mainBundle]];
        NSArray* nibContents = [nib instantiateWithOwner:self options:nil];
        gewonnenView = [nibContents objectAtIndex:0];
        
        
        [[gewonnenView layer] setCornerRadius:8.0f];
        // Turn on masking
        [[gewonnenView layer] setMasksToBounds:YES];
        // Display a border around the button 
        // with a 1.0 pixel width
        [[gewonnenView layer] setBorderWidth:1.0f];
        [[gewonnenView layer] setBorderColor:[[[UIColor whiteColor] colorByChangingAlphaTo:0.8f] CGColor]];
        
        [gewonnenView retain];
        
        [neuesSpielButton_ setHighColor:[UIColor greenColor]];
        [neuesSpielButton_ setLowColor:[[UIColor greenColor] colorByDarkeningColor]];
    }

}



- (void) zeigeGewonnenInZuegen:(Spielmodel*)model {
    [self loadAndInitGewonnenView];
    
    int zuege = model.zuege;

    NSString* gewonnenVerloren = (model.siegErreicht) ? @"Gewonnen!" : @"Verloren!";
    NSString* level;
    switch (model.level) {
        case HARD:
            level = @"Hard";
            break;
            
        case MEDIUM:
            level = @"Medium";
            break;
            
        case EASY:
        default:
            level = @"Easy";
            break;
    }
    
    

    NSString* anzahlSpieleKey = [NSString stringWithFormat:PREFKEY_SPIELZAEHLER_FORMAT, model.level];
    NSString* anzahlGewonnenKey = [NSString stringWithFormat:PREFKEY_GEWONNENZAEHLER_FORMAT, model.level];

    if (model.siegErreicht) {
        [[Datenhaltung sharedInstance] erhoeheIntegerFuerKey:anzahlGewonnenKey];
    }
    
    
    int anzahlSpiele = [[Datenhaltung sharedInstance] integerFuerKey:anzahlSpieleKey];
    
    int anzahlGewonnen = [[Datenhaltung sharedInstance] integerFuerKey:anzahlGewonnenKey];
    
    int anzahlVerloren = anzahlSpiele - anzahlGewonnen;

    float prozentGewonnen;
    
    if (anzahlSpiele>0) {
        prozentGewonnen = (float)anzahlGewonnen / (float)anzahlSpiele* 100.0f;
        prozentGewonnenLabel.hidden = NO;
    } else {
        prozentGewonnen = NAN;
        prozentGewonnenLabel.hidden = YES;
    }
    
    long dauer = model.spieldauer;
    int minuten = dauer / 60;
    int sekunden = dauer % 60;
    
    
    gewonnenView.alpha = 0;
    gewonnenView.center = CGPointMake(self.view.center.x, -gewonnenView.frame.size.height);

    gewonnenVerlorenLabel.text = gewonnenVerloren;
    gewonnenInXZuegenLabel.text = [NSString stringWithFormat:@"%d", zuege, nil];
    anzahlSpieleLabel.text = [NSString stringWithFormat:@"%d", anzahlSpiele];
    anzahlGewonnenLabel.text = [NSString stringWithFormat:@"%d", anzahlGewonnen];
    anzahlVerlorenLabel.text = [NSString stringWithFormat:@"%d",anzahlVerloren];
    prozentGewonnenLabel.text = [NSString stringWithFormat:@"(%2.1f%%)", prozentGewonnen];
    spieldauerLabel.text = [NSString stringWithFormat:@"%d:%02d", minuten, sekunden];
    levelLabel.text = level;
    

    [self.view.layer addSublayer:[self blurLayer]];

    [self.view addSubview:gewonnenView];
    
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"Fade In Animation Began", nil);
        gewonnenView.alpha = 0.85f;
        gewonnenView.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
        if (model.siegErreicht) {
            [[SoundManager sharedManager] playSound:GEWONNEN];
        } else {
            [[SoundManager sharedManager] playSound:VERLOREN];
        }
    } completion:^(BOOL finished) {
        NSLog(@"Fade In Animation Done", nil);
    }];
}

- (void) setColorButtonState:(BOOL)state {
    farbe0Button_.enabled = state;
    farbe1Button_.enabled = state;
    farbe2Button_.enabled = state;
    farbe3Button_.enabled = state;
    farbe4Button_.enabled = state;
    farbe5Button_.enabled = state;
}

- (void) disableColorButtons {
    [self setColorButtonState:NO];
}
     
- (void) enableColorButtons {
    [self setColorButtonState:YES];
}


#pragma mark - IBActions

- (IBAction)neuesSpiel:(id)sender {
    [self starteNeuesSpiel];
    [self fadeOutGewonnenView];
    [self enableColorButtons];
}

- (IBAction)colorButtonPressed:(id)sender {
    int colorNumber = ((UIButton*)sender).tag;
    
    [self.rasterController colorClicked:colorNumber];
}

- (IBAction)settingsButtonPressed:(id)sender {
    [self loadAndInitGewonnenView];
    SettingsViewController* settingsController = [[[SettingsViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight 
                           forView:self.navigationController.view cache:YES];
    [self.navigationController 
     pushViewController:settingsController animated:NO];
    [UIView commitAnimations];
}



#pragma mark - SpielrasterViewControllerDelegate protocol

-(void)spielrasterViewController:(SpielrasterViewController*)controller modelDidChange:(Spielmodel*)model {
    long dauer = model.spieldauer;
    int minuten = dauer / 60;
    int sekunden = dauer % 60;
    
    uhrLabel.text = [NSString stringWithFormat:@"%d:%02d", minuten, sekunden];

}

-(void)spielrasterViewController:(SpielrasterViewController*)controller spielEndeMitModel:(Spielmodel*)model {
    [self disableColorButtons];
    [self zeigeGewonnenInZuegen:model];
}

@end
