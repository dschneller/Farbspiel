//
//  FarbspielViewController.m
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "FarbspielViewController.h"
#import "Farbmapping.h"
#import "Datenhaltung.h"
#import "UIColor+Tools.h" 
#import "SettingsViewController.h"

@implementation FarbspielViewController

@synthesize rasterController;
@synthesize undoManager;
@synthesize defaultLevel = defaultLevel_;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    

    for (ColorfulButton* b in allColorButtons) {
        [b release];
    }

    [spielrasterView_ release];
    [rasterController release];
    [gewonnenView release];
    [neuesSpielButton_ release];
    [gewonnenInXZuegenLabel release];
    [debugButtonVerlieren release];
    [gewonnenVerlorenLabel release];
    [spieldauerLabel release];
    [levelLabel release];
    [blurLayer_ release];
    [uhrLabel release];
    
    [soundAnAusButton_ release];
    [einstellungenButton release];
    [debugButtonGewinnen release];
    [statistikPlaceholder_ release];
    [statistikViewController_ release];
    [allColorButtons release];
    [settingsToggleButton release];
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

-(void) starteNeuesSpielMitLevel:(SpielLevel)level {
    self.rasterController.view = spielrasterView_;
    self.rasterController.delegate = self;
    
    Spielmodel* model = [[Spielmodel alloc] initWithLevel:level];
    self.rasterController.model = model;
    [model release];
}


#pragma mark - View lifecycle

- (void)updateSoundButton:(BOOL)an {
    if (an) {
        [soundAnAusButton_ setImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
    } else {
        [soundAnAusButton_ setImage:[UIImage imageNamed:@"speaker_off"] forState:UIControlStateNormal];
    }
}

-(void)undoManagerDidUndo:(id)object {
//    NSLog(@"Undo Manager did Undo");
    [self.undoManager removeAllActions];
}

- (void)shakeView:(UIView *)viewToShake
{
    CGFloat t = 5.0;
    CGAffineTransform translateRight  = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform = CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}
-(void) handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer {
    if (![self.undoManager canUndo]) {
        [self shakeView:self.rasterController.view];
    } else {
        [self.undoManager undo];
    }
    
}


-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [super motionEnded:motion withEvent:event]; // let undo happen
    if (motion == UIEventSubtypeMotionShake) {
        if (![self.undoManager canUndo]) {
            [self shakeView:self.rasterController.view];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [spielrasterView_ addGestureRecognizer:recognizer];
    [recognizer release];
    
    NSUndoManager *manager = [[NSUndoManager alloc] init];
    self.undoManager = manager;
    self.undoManager.levelsOfUndo = 1;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(undoManagerDidUndo:)
                name:NSUndoManagerDidUndoChangeNotification object:manager];
    
    [manager release];
    
     // Set the layer's corner radius
     [[spielrasterView_ layer] setCornerRadius:8.0f];
     // Turn on masking
     [[spielrasterView_ layer] setMasksToBounds:YES];
     // Display a border around the button 
     // with a 1.0 pixel width
     [[spielrasterView_ layer] setBorderWidth:1.0f];
    
#if !DEBUG
    [debugButtonVerlieren removeFromSuperview];
    [debugButtonGewinnen removeFromSuperview];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(soundStatusDidChange:) 
                                                 name:SOUNDMANAGER_NOTIFICATION_SOUNDAN
                                               object:nil];

    self.defaultLevel = (SpielLevel) [[Datenhaltung sharedInstance] integerFuerKey:PREFKEY_SPIELLEVEL];
    [self starteNeuesSpielMitLevel:self.defaultLevel];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

-(void) updateGUIAusSettings {
    [self updateSoundButton:[SoundManager sharedManager].soundAn];
    
    for (ColorfulButton *b in allColorButtons) {
        [b setHighColor:[[Farbmapping sharedInstance] farbeMitNummer:b.tag]];
        [b setLowColor:[[Farbmapping sharedInstance] shadeFarbeMitNummer:b.tag]];
    }
    
    [self.rasterController.view setNeedsDisplay];
}

- (void) viewWillAppear:(BOOL)animated {
    [self updateGUIAusSettings];
}



-(BOOL)canBecomeFirstResponder {
    return YES;
}


-(void)pruefeObLevelGewechseltWurde {
    SpielLevel storedLevel = (SpielLevel) [[Datenhaltung sharedInstance] integerFuerKey:PREFKEY_SPIELLEVEL];
    // Neuer Level gewaehlt?
    if (self.rasterController.model.level != storedLevel) {
        NSLog(@"Neues Model mit Level %d", storedLevel);
        
        if (rasterController.model.siegErreicht ||
            rasterController.model.verloren ||
            !rasterController.model.spielLaeuft) {
            [self starteNeuesSpielMitLevel:storedLevel];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Q_NEUE_EINSTELLUNGEN_TITEL", @"Title for question after settings change")  message:NSLocalizedString(@"Q_NEUE_EINSTELLUNGEN_ERKLAERUNG", @"New Game now -> Current is counted as lost!") delegate:nil cancelButtonTitle:NSLocalizedString(@"B_WEITERSPIELEN", @"Button text for -continue game-") otherButtonTitles:NSLocalizedString(@"B_NEUES_SPIEL", @"Button text for -new game-"), nil];
            
            [alert showUsingButtonBlock:^(NSInteger buttonIndex) {
                // NO = 0, YES = 1
                if(buttonIndex == 1) {
                    [self.rasterController spielAbbrechen];
                }
            }];
            [alert release];
        }
    }

}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [popoverController release];
    [self updateGUIAusSettings];
    [self pruefeObLevelGewechseltWurde];
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"Became first responder: %d", [self becomeFirstResponder]);
    [self pruefeObLevelGewechseltWurde];
}

- (void)viewDidUnload
{
    [rasterController release];
    rasterController = nil;
    
    for (ColorfulButton* b in allColorButtons) {
        [b release];
    }
    
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
    [blurLayer_ release];
    blurLayer_ = nil;
    [uhrLabel release];
    uhrLabel = nil;
    
    [soundAnAusButton_ release];
    soundAnAusButton_ = nil;
    [einstellungenButton release];
    einstellungenButton = nil;
    [debugButtonGewinnen release];
    debugButtonGewinnen = nil;
    [statistikPlaceholder_ release];
    statistikPlaceholder_ = nil;
    [statistikViewController_ release];
    statistikViewController_ = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.undoManager = nil;
    [allColorButtons release];
    allColorButtons = nil;
    [settingsToggleButton release];
    settingsToggleButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#define IPAD() UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (IPAD()) {
        return ((interfaceOrientation == UIInterfaceOrientationPortrait)
                || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
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
        
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"StatistikView" owner:statistikViewController_ options:nil];
        StatistikView *statistikView = (StatistikView *)[views objectAtIndex:0];

        [statistikPlaceholder_ addSubview:statistikView];
        statistikViewController_.statistikView = statistikView;
        
        [gewonnenView retain];
        

        
        [neuesSpielButton_ setHighColor:[UIColor greenColor]];
        [neuesSpielButton_ setLowColor:[[UIColor greenColor] colorByDarkeningColor]];
    }

}



- (void) zeigeGewonnenInZuegen:(Spielmodel*)model {
    [self loadAndInitGewonnenView];
    [[Datenhaltung sharedInstance] speichereSpielAusgang:model];
    
    int zuege = model.zuege;

    NSString* gewonnenVerloren = (model.siegErreicht) ? NSLocalizedString(@"L_GEWONNEN", @"Label for -won-") : NSLocalizedString(@"L_VERLOREN", @"Label for -lost-");
    NSString* level;
    switch (model.level) {
        case HARD:
            level = NSLocalizedString(@"L_SCHWER", @"Level name for -hard-");
            break;
            
        case MEDIUM:
            level = NSLocalizedString(@"L_MITTEL", @"Level name for -medium-");
            break;
            
        case EASY:
        default:
            level = NSLocalizedString(@"L_EASY", @"Level name for -easy-");
            break;
    }
    
    NSUInteger anzahlSpiele = [[Datenhaltung sharedInstance] anzahlSpieleGesamtFuerLevel:model.level];
    NSUInteger anzahlGewonnen = [[Datenhaltung sharedInstance] anzahlSpieleGewonnen:YES fuerLevel:model.level];
    
    
    statistikViewController_.anzahlSpiele = anzahlSpiele;
    statistikViewController_.anzahlGewonnen = anzahlGewonnen;
    
    long dauer = model.spieldauer;
    int minuten = dauer / 60;
    int sekunden = dauer % 60;
    
    gewonnenView.alpha = 0;
    gewonnenView.center = CGPointMake(self.view.center.x, -gewonnenView.frame.size.height);

    gewonnenVerlorenLabel.text = gewonnenVerloren;
    gewonnenInXZuegenLabel.text = [NSString stringWithFormat:@"%d", zuege, nil];
    
    spieldauerLabel.text = [NSString stringWithFormat:@"%d:%02d", minuten, sekunden];
    levelLabel.text = level;

    [self.view.layer addSublayer:[self blurLayer]];

    [self.view addSubview:gewonnenView];
    
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"Fade In Animation Began");
        gewonnenView.alpha = 0.85f;
        gewonnenView.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
        if (model.siegErreicht) {
            [[SoundManager sharedManager] playSound:GEWONNEN];
        } else {
            [[SoundManager sharedManager] playSound:VERLOREN];
        }
    } completion:^(BOOL finished) {
        NSLog(@"Fade In Animation Done");
    }];
}

- (void) setColorButtonState:(BOOL)state {
    for (ColorfulButton* b in allColorButtons) {
        b.enabled = state;
    }
}

- (void) disableColorButtons {
    [self setColorButtonState:NO];
}
     
- (void) enableColorButtons {
    [self setColorButtonState:YES];
}

#pragma mark - Notification Center

- (void) soundStatusDidChange:(NSNotification *)notification {
    if ([[notification name] isEqualToString:SOUNDMANAGER_NOTIFICATION_SOUNDAN]) {
        NSNumber* wrappedBool = [notification object];
        [self updateSoundButton:[wrappedBool boolValue]];
    }
}


#pragma mark - IBActions

- (IBAction)neuesSpiel:(id)sender {
    [self starteNeuesSpielMitLevel:[[Datenhaltung sharedInstance] integerFuerKey:PREFKEY_SPIELLEVEL]];
    [self fadeOutGewonnenView];
    [self enableColorButtons];
}

- (IBAction)colorButtonPressed:(id)sender {
    NSInteger colorNumber = ((UIButton*)sender).tag;
    if (colorNumber < 0) {
        colorNumber = 0;
    }
    
    [self.rasterController colorClicked:(NSUInteger)colorNumber];
}

- (IBAction)settingsButtonPressed:(id)sender {
    [self loadAndInitGewonnenView];
    SettingsViewController* settingsController = [[[SettingsViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    
    settingsController.passedInModel = self.rasterController.model;
    settingsController.aufrufenderController = self;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIPopoverController* popController = [[UIPopoverController alloc] initWithContentViewController:settingsController];
        popController.delegate = self;
        [popController presentPopoverFromRect:settingsToggleButton.frame 
                                       inView:self.view
                     permittedArrowDirections:UIPopoverArrowDirectionAny 
                                     animated:YES];
        
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight 
                               forView:self.navigationController.view cache:YES];
        [self.navigationController 
         pushViewController:settingsController animated:NO];
        [UIView commitAnimations];
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



#pragma mark - SpielrasterViewControllerDelegate protocol

-(void)spielrasterViewController:(SpielrasterViewController*)controller modelDidChange:(Spielmodel*)model {
    long dauer = model.spieldauer;
    int minuten = dauer / 60;
    int sekunden = dauer % 60;
    
    uhrLabel.text = [NSString stringWithFormat:@"%d:%02d", minuten, sekunden];

}

-(void)spielrasterViewController:(SpielrasterViewController*)controller spielEndeMitModel:(Spielmodel*)model {
    [self disableColorButtons]; // TODO ALLE BUTTONS
    [self zeigeGewonnenInZuegen:model];
}

#pragma mark - SettingsViewcontroller callback
- (void)settingsGeaendert:(Spielmodel*)modelAusSettings {
}

@end
