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
#import "LambdaAlert.h"

@interface FarbspielViewController()
    @property (weak, nonatomic, readonly) CAGradientLayer* blurLayer;
@end

@implementation FarbspielViewController

@synthesize blurLayer = _blurLayer;
- (CAGradientLayer*) blurLayer {
    if (!_blurLayer) {
        _blurLayer = [CAGradientLayer layer];
        _blurLayer.frame = self.view.bounds;
        _blurLayer.colors = [NSArray arrayWithObjects:(id)[[[UIColor darkGrayColor] colorByChangingAlphaTo:0.7f] CGColor], (id)[[[[UIColor darkGrayColor] colorByDarkeningColor] colorByChangingAlphaTo:0.7f] CGColor], nil];
    }
    return _blurLayer;
}


-(void) starteNeuesSpielMitLevel:(SpielLevel)level {
    self.rasterController.view = self.spielrasterView;
    self.rasterController.delegate = self;
    
    Spielmodel* model = [[Spielmodel alloc] initWithLevel:level];
    self.rasterController.model = model;
}


#pragma mark - View lifecycle

- (void)updateSoundButton:(BOOL)an {
    if (an) {
        [self.soundAnAusButton setImage:[UIImage imageNamed:@"speaker"] forState:UIControlStateNormal];
    } else {
        [self.soundAnAusButton setImage:[UIImage imageNamed:@"speaker_off"] forState:UIControlStateNormal];
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
    
    NSUndoManager *manager = [[NSUndoManager alloc] init];
    self.undoManager = manager;
    self.undoManager.levelsOfUndo = 1;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(undoManagerDidUndo:)
                name:NSUndoManagerDidUndoChangeNotification object:manager];
    
    
     // Set the layer's corner radius
     [[self.spielrasterView layer] setCornerRadius:8.0f];
     // Turn on masking
     [[self.spielrasterView layer] setMasksToBounds:YES];
     // Display a border around the button 
     // with a 1.0 pixel width
     [[self.spielrasterView layer] setBorderWidth:1.0f];
    
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
    
    for (ColorfulButton *b in self.allColorButtons) {
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
        
        if (self.rasterController.model.siegErreicht ||
            self.rasterController.model.verloren ||
            !self.rasterController.model.spielLaeuft) {
            [self starteNeuesSpielMitLevel:storedLevel];
        } else {
            LambdaAlert *alert = [[LambdaAlert alloc]
                                  initWithTitle:NSLocalizedString(@"Q_NEUE_EINSTELLUNGEN_TITEL", @"Title for question after settings change")  message:NSLocalizedString(@"Q_NEUE_EINSTELLUNGEN_ERKLAERUNG", @"New Game now -> Current is counted as lost!")];
            [alert addButtonWithTitle:NSLocalizedString(@"B_NEUES_SPIEL", @"Button text for -new game-") block:^{ [self.rasterController spielAbbrechen]; }];
            [alert addButtonWithTitle:NSLocalizedString(@"B_WEITERSPIELEN", @"Button text for -continue game-") block:NULL];
            [alert show];
        }
    }

}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self updateGUIAusSettings];
    [self pruefeObLevelGewechseltWurde];
}

-(void)viewDidAppear:(BOOL)animated {
    NSLog(@"Became first responder: %d", [self becomeFirstResponder]);
    [self pruefeObLevelGewechseltWurde];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}


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
                         CGRect f = self.gewonnenView.frame;
                         CGRect nf = CGRectMake(f.origin.x, -f.size.height, f.size.width, f.size.height);
                         self.gewonnenView.alpha = 0;
                         self.gewonnenView.frame = nf;
                     } 
                     completion:^(BOOL finished){
                         NSLog(@"Fade Out Animation Finished");

                         [self.gewonnenView removeFromSuperview];
                         [[self blurLayer] removeFromSuperlayer];
                         self.gewonnenView = nil;
                     }];

}

- (void) loadAndInitGewonnenView {
    if (!self.gewonnenView) {
        UIView* newGewonnenView;
        UINib* nib = [UINib nibWithNibName:@"GewonnenView" bundle:[NSBundle mainBundle]];
        NSArray* nibContents = [nib instantiateWithOwner:self options:nil];
        newGewonnenView = [nibContents objectAtIndex:0];
        
        
        [[newGewonnenView layer] setCornerRadius:8.0f];
        // Turn on masking
        [[newGewonnenView layer] setMasksToBounds:YES];
        // Display a border around the button 
        // with a 1.0 pixel width
        [[newGewonnenView layer] setBorderWidth:1.0f];
        [[newGewonnenView layer] setBorderColor:[[[UIColor whiteColor] colorByChangingAlphaTo:0.8f] CGColor]];
        
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"StatistikView" owner:self.statistikViewController options:nil];
        StatistikView *statistikView = (StatistikView *)[views objectAtIndex:0];

        [self.statistikPlaceholder addSubview:statistikView];
        self.statistikViewController.statistikView = statistikView;
        
        

        
        [self.neuesSpielButton setHighColor:[UIColor greenColor]];
        [self.neuesSpielButton setLowColor:[[UIColor greenColor] colorByDarkeningColor]];
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
    
    
    self.statistikViewController.anzahlSpiele = anzahlSpiele;
    self.statistikViewController.anzahlGewonnen = anzahlGewonnen;
    
    long dauer = model.spieldauer;
    int minuten = dauer / 60;
    int sekunden = dauer % 60;
    
    self.gewonnenView.alpha = 0;
    self.gewonnenView.center = CGPointMake(self.view.center.x, -self.gewonnenView.frame.size.height);

    self.gewonnenVerlorenLabel.text = gewonnenVerloren;
    self.gewonnenInXZuegenLabel.text = [NSString stringWithFormat:@"%d", zuege, nil];
    
    self.spieldauerLabel.text = [NSString stringWithFormat:@"%d:%02d", minuten, sekunden];
    self.levelLabel.text = level;

    [self.view.layer addSublayer:[self blurLayer]];

    [self.view addSubview:self.gewonnenView];
    
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"Fade In Animation Began");
        self.gewonnenView.alpha = 0.85f;
        self.gewonnenView.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
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
    for (ColorfulButton* b in self.allColorButtons) {
        b.enabled = state;
    }
}

- (void) setAllButtonState:(BOOL)state {
    [self setColorButtonState:state];    
    self.settingsToggleButton.enabled = state;
    self.soundAnAusButton.enabled = state;
#if DEBUG
    self.debugButtonGewinnen.enabled = state;
    self.debugButtonVerlieren.enabled = state;
#endif
    if (self.undoSwipeGestureRecognizer) {
        self.undoSwipeGestureRecognizer.enabled = state;
    }
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
    [self setAllButtonState:YES];
}

- (IBAction)colorButtonPressed:(id)sender {
    NSInteger colorNumber = ((UIButton*)sender).tag;
    if (colorNumber < 0) {
        colorNumber = 0;
    }
    
    [self.rasterController colorClicked:(NSUInteger)colorNumber];
}

- (IBAction)settingsButtonPressed:(UIButton*)sender {
    [self loadAndInitGewonnenView];
    SettingsViewController* settingsController = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    
    settingsController.passedInModel = self.rasterController.model;
    settingsController.aufrufenderController = self;
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.settingsPopoverController = [[UIPopoverController alloc] initWithContentViewController:settingsController];
        self.settingsPopoverController.delegate = self;
        
        UIView* popoverReferenceView;
        if (self.gewonnenView.window) {
            popoverReferenceView = self.gewonnenView;
        } else {
            popoverReferenceView = self.view;
        }
        
        [self.settingsPopoverController presentPopoverFromRect:sender.frame 
                                       inView:popoverReferenceView
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


- (IBAction)undoSwipe:(UISwipeGestureRecognizer*)sender {
    if (![self.undoManager canUndo]) {
        [self shakeView:self.rasterController.view];
    } else {
        [self.undoManager undo];
    }
}



#pragma mark - SpielrasterViewControllerDelegate protocol

-(void)spielrasterViewController:(SpielrasterViewController*)controller modelDidChange:(Spielmodel*)model {
    long dauer = model.spieldauer;
    int minuten = dauer / 60;
    int sekunden = dauer % 60;
    
    self.uhrLabel.text = [NSString stringWithFormat:@"%d:%02d", minuten, sekunden];

}

-(void)spielrasterViewController:(SpielrasterViewController*)controller spielEndeMitModel:(Spielmodel*)model {
    [self setAllButtonState:NO];
    [self zeigeGewonnenInZuegen:model];
}

#pragma mark - SettingsViewcontroller callback
- (void)settingsGeaendert:(Spielmodel*)modelAusSettings {
}



#pragma mark - Memory Management / Notification Center

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
}

#pragma mark - Synthesize Properties

@synthesize allColorButtons         = _allColorButtons;
@synthesize debugButtonGewinnen     = _debugButtonGewinnen;
@synthesize debugButtonVerlieren    = _debugButtonVerlieren;
@synthesize gewonnenInXZuegenLabel  = _gewonnenInXZuegenLabel;
@synthesize gewonnenVerlorenLabel   = _gewonnenVerlorenLabel;
@synthesize gewonnenView            = _gewonnenView;
@synthesize levelLabel              = _levelLabel;
@synthesize rasterController        = _rasterController;
@synthesize settingsToggleButton    = _settingsToggleButton;
@synthesize soundAnAusButton        = _soundAnAusButton;
@synthesize spieldauerLabel         = _spieldauerLabel;
@synthesize spielrasterView         = _spielrasterView;
@synthesize uhrLabel                = _uhrLabel;
@synthesize undoSwipeGestureRecognizer = _undoSwipeGestureRecognizer;

@synthesize defaultLevel            = _defaultLevel;
@synthesize einstellungenButton     = _einstellungenButton;
@synthesize neuesSpielAlert         = _neuesSpielAlert;
@synthesize neuesSpielButton        = _neuesSpielButton;
@synthesize settingsPopoverController = _settingsPopoverController;
@synthesize statistikPlaceholder    = _statistikPlaceholder;
@synthesize statistikViewController = _statistikViewController;
@synthesize undoManager             = _undoManager;


@end
