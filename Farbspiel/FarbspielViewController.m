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
#import "UIColor+Tools.h" 
#import <QuartzCore/QuartzCore.h>

@implementation FarbspielViewController

@synthesize rasterController;


- (void)dealloc
{
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

#pragma mark - View lifecycle

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

    [self.view.layer insertSublayer:[self makeBackgroundGradientLayer] atIndex:0];
    
#if !DEBUG
        [debugButtonVerlieren removeFromSuperview];
#endif

    [self starteNeuesSpiel];
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
    
    // Temporaer
    int anzahlSpiele = 105;
    int anzahlGewonnen = 55;
    int anzahlVerloren = anzahlSpiele - anzahlGewonnen;
    float prozentGewonnen = (float)anzahlGewonnen / (float)anzahlSpiele* 100.0f;
    
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
//    [self.view.layer insertSublayer:[self makeBlurLayer] atIndex:0];

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
//    [self loadAndInitGewonnenView];
//    
//    
//    
//    
//    [UIView transitionFromView:(displayingPrimary ? self.view : gewonnenView)
//                        toView:(displayingPrimary ? gewonnenView : self.view)
//                      duration:1.0
//                       options:(displayingPrimary ? 
//                                UIViewAnimationOptionTransitionFlipFromRight :
//                                UIViewAnimationOptionTransitionFlipFromLeft)
//                    completion:^(BOOL finished) {
//                        if (finished) {
//                            displayingPrimary = !displayingPrimary;
//                        }
//                    }
//     ];
//    
    
}

#pragma - SpielrasterViewControllerDelegate protocol
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
