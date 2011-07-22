//
//  SpielrasterViewController.m
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SpielrasterViewController.h"
#import "SoundManager.h"
#import "Datenhaltung.h"


@implementation SpielrasterViewController

@synthesize zuegeLabel;
@synthesize view = view_;
@synthesize model = model_;
@synthesize delegate = delegate_;


-(void) updateZuegeDisplay {
    self.zuegeLabel.text = [NSString stringWithFormat:@"%d / %d", self.model.zuege, self.model.maximaleZuege];
}

-(void) setModel:(Spielmodel *)model {
    [model_ release]; // altes loslassen
    model_ = model; // neues setzen
    [model_ retain]; // neues halten
    [self.delegate spielrasterViewController:self modelDidChange:model];
    self.view.dataSource = self;
    [self updateZuegeDisplay];
    [self.view setNeedsDisplay];
}


-(void) tick {
    NSLog(@"TICK %ld", self.model.spieldauer);
    self.model.spieldauer = self.model.spieldauer+1;
    [self.delegate spielrasterViewController:self modelDidChange:self.model];
}

- (void)stopAndClearTimer {
    if (timer_) {
        [timer_ invalidate];
        [timer_ release];
        timer_ = nil;
    }
}

- (void)startTimer {
    if (!timer_) {
        timer_ = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        [timer_ retain];
    }
}

-(void)neuesSpielZaehlenFuerLevel:(SpielLevel)level {
    NSString* key = [NSString stringWithFormat:PREFKEY_SPIELZAEHLER_FORMAT, level];
    NSLog(@"Gezaehlt: Level %d, Count %d", self.model.level, [[Datenhaltung sharedInstance] erhoeheIntegerFuerKey:key]);
}


- (void)spielstart {
    [self startTimer];
    [self neuesSpielZaehlenFuerLevel:self.model.level];
}

- (void)spielende {
  [self stopAndClearTimer];
  [self.delegate spielrasterViewController:self spielEndeMitModel:self.model];
}


-(void) colorClicked:(int)colorNumber {
    if (self.model.zuege == 0) {
        [self spielstart];
    }
    [[SoundManager sharedManager] playSound:BUTTON];
    [self.model farbeGewaehlt:colorNumber];
    [self updateZuegeDisplay];
    if ([self.model siegErreicht] || self.model.zuege >= self.model.maximaleZuege) {
        [self spielende];
    }
    [self.view setNeedsDisplay];
}

- (IBAction)verlieren:(id)sender {
    [self spielende];
    [self.view setNeedsDisplay];
}


#pragma - SpielrasterViewDataSource
-(NSNumber*) farbeFuerRasterfeldZeile:(int)row spalte:(int)col {
    return [self.model farbeAnPositionZeile:row spalte:col];
}

-(int) rasterZeilen {
    return self.model.felderProKante;
}
-(int) rasterSpalten {
    return self.model.felderProKante;    
}

#pragma - memory


- (void)dealloc
{
    [self stopAndClearTimer];
    [zuegeLabel release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
