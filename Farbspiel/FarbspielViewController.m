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
#import "Pair.h"



@implementation FarbspielViewController

#pragma mark - Undo
@synthesize undoManager;

-(void)undoManagerDidUndo:(id)object {
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

- (IBAction)undoSwipe:(UISwipeGestureRecognizer*)sender {
    if (![self.undoManager canUndo]) {
        [self shakeView:self.rasterController.view];
    } else {
        Spielmodel* oldModel = [[Spielmodel alloc] initWithModel:self.rasterController.model];
        [self.undoManager undo];
        [self.rasterController updateLayersFromOldModel:oldModel];
        
    }
}





#pragma mark - Sound

- (void)updateSoundButton:(BOOL)an {
    UIImage* img;
    if (an) {
        img = [UIImage imageNamed:@"speaker"];
    } else {
        img = [UIImage imageNamed:@"speaker_off"];
    }
    [self.soundAnAusButton setImage:img forState:UIControlStateNormal];
    [self.soundAnAusButton setImage:img forState:UIControlStateDisabled];

}

-(void) updateGUIAusSettings {
    [self updateSoundButton:[SoundManager sharedManager].soundAn];
    NSUInteger s;
    
    if (IPAD()) {
        s = 66;
    } else {
        s = 32;
    }
    
    for (UIButton *b in self.allColorButtons) {
        NSString* imgName = [[Farbmapping sharedInstance] imageNameForColor:b.tag andSize:s];
        UIImage *img = [UIImage imageNamed:imgName];
        [b setBackgroundImage:img forState:UIControlStateNormal];
        b.adjustsImageWhenDisabled = NO;
        b.opaque = YES;
        b.alpha = 1.0f;
    }
    [self.rasterController.view.gridLayer removeFromSuperlayer];
    if ([[Datenhaltung sharedInstance] boolFuerKey:PREFKEY_GITTER_AN]) {
        [self.rasterController.view.layer addSublayer:self.rasterController.view.gridLayer];
    }
    [self.rasterController.view prepareSublayers];
    [self.rasterController neuenSnapshotInstallieren];
}

-(void) soundStatusDidChange:(NSNotification *)notification {
    if ([[notification name] isEqualToString:SOUNDMANAGER_NOTIFICATION_SOUNDAN]) {
        NSNumber* wrappedBool = [notification object];
        [self updateSoundButton:[wrappedBool boolValue]];
    }
}






#pragma mark - Spielablauf


-(void) starteNeuesSpielMitLevel:(SpielLevel)level {
    self.rasterController.view = self.spielrasterView;
    self.rasterController.delegate = self;
    Spielmodel* model = [[Spielmodel alloc] initWithLevel:level];
    self.rasterController.model = model;
    [self.rasterController.view prepareSublayers];
    [self.rasterController neuenSnapshotInstallieren];
}

-(void)pruefeObLevelGewechseltWurde {
    SpielLevel storedLevel = (SpielLevel) [[Datenhaltung sharedInstance] integerFuerKey:PREFKEY_SPIELLEVEL];
    // Neuer Level gewaehlt?
    if (self.rasterController.model.level != storedLevel) {
        LOG_GAME(0, @"Neues Model mit Level %d", storedLevel);
        
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


- (void) setColorButtonState:(BOOL)state {
    for (UIButton* b in self.allColorButtons) {
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





#pragma mark - IBActions
- (IBAction)colorButtonPressed:(id)sender {
    NSInteger colorNumber = ((UIButton*)sender).tag;
    if (colorNumber < 0) {
        colorNumber = 0;
    }
    
    [self.rasterController colorClicked:(NSUInteger)colorNumber];
}


- (IBAction)settingsButtonPressed:(UIButton*)sender {
    SettingsViewController* settingsController = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    
    settingsController.passedInModel = self.rasterController.model;
    
    if (IPAD()) {
        self.settingsPopoverController = [[UIPopoverController alloc] initWithContentViewController:settingsController];
        self.settingsPopoverController.delegate = self;
        
        [self.settingsPopoverController presentPopoverFromRect:sender.frame 
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


#pragma mark - SpielrasterViewControllerDelegate protocol

-(void)spielrasterViewController:(SpielrasterViewController*)controller modelDidChange:(Spielmodel*)model {
    long dauer = model.spieldauer;
    int minuten = dauer / 60;
    int sekunden = dauer % 60;
    
    self.uhrLabel.text = [NSString stringWithFormat:@"%d:%02d", minuten, sekunden];

}

-(void)spielrasterViewController:(SpielrasterViewController*)controller spielEndeMitModel:(Spielmodel*)model {
    [self setAllButtonState:NO];
    [self.gewonnenVerlorenController zeigeGewonnenInZuegen:model onView:self.view];
}





#pragma mark - GewonnenVerlorenControllerDelegate

-(void)didReturnFromSettings {
    [self updateGUIAusSettings];
    [self pruefeObLevelGewechseltWurde];
}

- (void) neuesSpiel {
    [self updateGUIAusSettings];

    [self starteNeuesSpielMitLevel:[[Datenhaltung sharedInstance] integerFuerKey:PREFKEY_SPIELLEVEL]];
    [self setAllButtonState:YES];
}

-(Spielmodel*)spielModel {
    return self.rasterController.model;
}




#pragma mark - UIPopoverControllerDelegate

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    [self didReturnFromSettings];
}


#pragma mark - View Life Cycle

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


-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSUndoManager *manager = [[NSUndoManager alloc] init];
    self.undoManager = manager;
    self.undoManager.levelsOfUndo = 1;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(undoManagerDidUndo:)
                                                 name:NSUndoManagerDidUndoChangeNotification object:manager];
    

    for (UIButton* b in self.allColorButtons)
    {
        b.layer.cornerRadius = 4.0f;
        b.layer.borderColor = [[UIColor blackColor] CGColor];
        b.layer.borderWidth = 1.0f;
        b.layer.masksToBounds = YES;
    }
    
    // Set the layer's corner radius
    self.spielrasterView.layer.cornerRadius = 8.0f;
    // Turn on masking
    self.spielrasterView.layer.masksToBounds = YES;
    // Display a border around the grid 
    // with a 1.0 pixel width
    self.spielrasterView.layer.borderWidth = 1.0f;
    self.spielrasterView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    
#if !DEBUG
    [self.debugButtonVerlieren removeFromSuperview];
    [self.debugButtonGewinnen removeFromSuperview];
#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(soundStatusDidChange:) 
                                                 name:SOUNDMANAGER_NOTIFICATION_SOUNDAN
                                               object:nil];
    
    self.defaultLevel = (SpielLevel) [[Datenhaltung sharedInstance] integerFuerKey:PREFKEY_SPIELLEVEL];
    [self starteNeuesSpielMitLevel:self.defaultLevel];
}

- (void) viewWillAppear:(BOOL)animated {
    [self updateGUIAusSettings];
}


-(void)viewDidAppear:(BOOL)animated {
    LOG_GAME(1, @"Became first responder: %d", [self becomeFirstResponder]);
    [self pruefeObLevelGewechseltWurde];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}



#pragma mark - Memory Management / Notification Center

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
}

@end
