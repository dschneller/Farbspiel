//
//  GewonnenVerlorenController.m
//  Farbspiel
//
//  Created by Daniel Schneller on 02.12.11.
//  Copyright (c) 2011 codecentric AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIColor+Tools.h"
#import "GewonnenVerlorenController.h"
#import "StatistikView.h"
#import "Datenhaltung.h"
#import "SoundManager.h"
#import "BlurLayer.h"
#import "SettingsViewController.h"

@implementation GewonnenVerlorenController

@synthesize view = _view;
@synthesize statistikPlaceholder = _statistikPlaceholder;
@synthesize statistikViewController= _statistikViewController;
@synthesize neuesSpielButton = _neuesSpielButton;
@synthesize einstellungenButton = _einstellungenButton;
@synthesize gewonnenVerlorenLabel = _gewonnenVerlorenLabel;
@synthesize gewonnenInXZuegenLabel = _gewonnenInXZuegenLabel;
@synthesize spieldauerLabel = _spieldauerLabel;
@synthesize levelLabel = _levelLabel;
@synthesize blurLayer = _blurLayer;

@synthesize delegate = _delegate;
@synthesize popoverController = _popoverController;

- (CAGradientLayer*) blurLayerForView:(UIView*)view {
    if (!_blurLayer) { 
        _blurLayer = [BlurLayer layerForParentView:view];
    }
    return _blurLayer;
}


- (void) fadeOut {
    [UIView animateWithDuration:0.5
                     animations:^{
                         LOG_GAME(1,@"Fade Out Animation Began");
                         CGRect f = self.view.frame;
                         CGRect nf = CGRectMake(f.origin.x, -f.size.height, f.size.width, f.size.height);
                         self.view.alpha = 0;
                         self.view.frame = nf;
                     } 
                     completion:^(BOOL finished){
                         LOG_GAME(1, @"Fade Out Animation Finished");
                         
                         [self.view removeFromSuperview];
                         [self.blurLayer removeFromSuperlayer];
                         self.view = nil;
                     }];
}

- (StatistikViewController*) statistikViewController {
    if (!_statistikViewController) {
        _statistikViewController = [[StatistikViewController alloc] init];
    }
    return _statistikViewController;
}


- (void) loadAndInitViewMitStatistikSubview {
    if (!self.view) {
        GewonnenVerlorenView* newGewonnenView;
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
        
        [self.neuesSpielButton setHighColor:[UIColor greenColor]];
        [self.neuesSpielButton setLowColor:[[UIColor greenColor] colorByDarkeningColor]];
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"StatistikView" owner:self.statistikViewController options:nil];
        StatistikView *statistikView = (StatistikView *)[views objectAtIndex:0];
        
        [self.statistikPlaceholder addSubview:statistikView];
        self.statistikViewController.statistikView = statistikView;

        self.view = newGewonnenView;
    }
}

- (void) zeigeGewonnenInZuegen:(Spielmodel*)model onView:(UIView*) parentView {
    [self loadAndInitViewMitStatistikSubview];
    [[Datenhaltung sharedInstance] speichereSpielAusgang:model];
    
    int zuege = model.zuege;
    
    NSString* gewonnenVerloren = (model.siegErreicht) ? NSLocalizedString(@"L_GEWONNEN", @"Label for -won-") : NSLocalizedString(@"L_VERLOREN", @"Label for -lost-");
    
    NSUInteger anzahlSpiele = [[Datenhaltung sharedInstance] anzahlSpieleGesamtFuerLevel:model.level];
    NSUInteger anzahlGewonnen = [[Datenhaltung sharedInstance] anzahlSpieleGewonnen:YES fuerLevel:model.level];
    
    
    LOG_GAME(1, @"GewonnenVerlorenController.statistikViewController = %@ ", self.statistikViewController);
    
    self.statistikViewController.anzahlSpiele = anzahlSpiele;
    self.statistikViewController.anzahlGewonnen = anzahlGewonnen;
    
    long dauer = model.spieldauer;
    int minuten = dauer / 60;
    int sekunden = dauer % 60;
    
    self.view.alpha = 0;
    self.view.center = CGPointMake(parentView.center.x, 0-self.view.frame.size.height);
    
    self.gewonnenVerlorenLabel.text = gewonnenVerloren;
    self.gewonnenInXZuegenLabel.text = [NSString stringWithFormat:@"%d", zuege, nil];
    
    self.spieldauerLabel.text = [NSString stringWithFormat:@"%d:%02d", minuten, sekunden];
    self.levelLabel.text = [Spielmodel levelNameFor:model.level];
    
    [parentView.layer addSublayer:[self blurLayerForView:parentView]];
    
    [parentView addSubview:self.view];
    
    [UIView animateWithDuration:0.5 animations:^{
        LOG_GAME(1, @"Fade In Animation Began");
        LOG_GAME(1, @"GewonnenView Center: %g, %g", self.view.center.x, self.view.center.y);
        self.view.alpha = 0.85f;
        self.view.center = CGPointMake(parentView.center.x, parentView.center.y - 30);
        LOG_GAME(1, @"GewonnenView CenterNeu: %g, %g", self.view.center.x, self.view.center.y);
        
        if (model.siegErreicht) {
            [[SoundManager sharedManager] playSound:GEWONNEN];
        } else {
            [[SoundManager sharedManager] playSound:VERLOREN];
        }
    } completion:^(BOOL finished) {
        LOG_GAME(1, @"Fade In Animation Done");
    }];
}

- (IBAction)neuesSpiel:(id)sender {
    [self.delegate neuesSpiel];
    [self fadeOut];
}


- (IBAction)settingsButtonPressed:(UIButton*)sender {
    SettingsViewController* settingsController = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    
    settingsController.passedInModel = [self.delegate spielModel];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:settingsController];
        
        self.popoverController.delegate = self;
        
        [self.popoverController presentPopoverFromRect:sender.frame 
                                                                 inView:self.view
                                               permittedArrowDirections:UIPopoverArrowDirectionAny 
                                                               animated:YES];
        
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight 
                               forView:[self.delegate navigationController].view cache:YES];
        [[self.delegate navigationController ]
         pushViewController:settingsController animated:NO];
        [UIView commitAnimations];
    }
}

@end
