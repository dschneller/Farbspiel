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
#import "Farbmapping.h"
#import "Pair.h"

@implementation SpielrasterViewController

@synthesize zuegeLabel;
@synthesize view = view_;
@synthesize shadowView;
@synthesize model = model_;
@synthesize delegate = delegate_;


-(void) updateZuegeDisplay {
    self.zuegeLabel.text = [NSString stringWithFormat:@"%d / %d", self.model.zuege, self.model.maximaleZuege];
}

-(void) setModel:(Spielmodel *)model {
    model_ = model;
    [self.delegate spielrasterViewController:self modelDidChange:model];
    self.view.dataSource = self;
    [self.view prepareSublayers];
    [self updateZuegeDisplay];
//    [self.view setNeedsDisplay];
}


-(void) tick {
    LOG_TICK(2, @"TICK %ld", self.model.spieldauer);
    self.model.spieldauer = self.model.spieldauer+1;
    [self.delegate spielrasterViewController:self modelDidChange:self.model];
}

- (void)stopAndClearTimer {
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
}

- (void)startTimer {
    if (!timer_) {
        timer_ = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    }
}

-(void)neuesSpielZaehlenFuerLevel:(SpielLevel)level {
    NSString* key = [NSString stringWithFormat:PREFKEY_SPIELZAEHLER_FORMAT, level];
    LOG_GAME(0, @"Gezaehlt: Level %d, Count %d", self.model.level, [[Datenhaltung sharedInstance] erhoeheIntegerFuerKey:key]);
}


- (void)spielstart {
    [self startTimer];
    [self neuesSpielZaehlenFuerLevel:self.model.level];
}

- (void)spielende {
  [self stopAndClearTimer];
  [self.delegate spielrasterViewController:self spielEndeMitModel:self.model];
}

-(void) doUndo:(Spielmodel*)previousModel {
    self.model.zuege = previousModel.zuege;
    for (NSUInteger i=0; i<self.model.farbfelder.count; i++) {
        [self.model.farbfelder replaceObjectAtIndex:i withObject:[previousModel.farbfelder objectAtIndex:i]];
    }
    [self updateZuegeDisplay];
//    [self.view setNeedsDisplay];
}



-(void) colorClicked:(NSUInteger)colorNumber {
    if (self.model.zuege == 0) {
        [self spielstart];
    }

    NSNumber* farbeObenLinks = [self.model farbeAnPositionZeile:0 spalte:0];
    if ([farbeObenLinks unsignedIntValue] == colorNumber) {
        // gleiche farbe geklickt, wie ohnehin schon oben links
        return;
    }
    [[SoundManager sharedManager] playSound:BUTTON];

    Spielmodel* oldModel = [[Spielmodel alloc] initWithModel:self.model];
    [self.view.undoManager registerUndoWithTarget:self selector:@selector(doUndo:) object:oldModel];
    
    [self.model farbeGewaehlt:colorNumber];
    [self updateZuegeDisplay];
    if ([self.model siegErreicht] || self.model.zuege >= self.model.maximaleZuege) {
        [self spielende];
    }
    
    // LAYERS updaten
    // 1. differenz zwischen neuem und altem model finden
    NSSet* differenz = [self.model unterschiedeZuModel:oldModel];
    // 2. Entsprechende Layers raussuchen und aendern
    if ([differenz count] == 0) {
        return;
    }
    
    NSArray* keyTimes = [NSArray arrayWithObjects:     // Relative timing values for the 3 keyframes
                         [NSNumber numberWithFloat:0], 
                         [NSNumber numberWithFloat:1.0],
                         nil]; 
    NSArray* timingFunctions = [NSArray arrayWithObjects:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],        // from keyframe 1 to keyframe 2
     nil]; // from keyframe 2 to keyframe 3

    Pair* p1 = [[differenz objectEnumerator] nextObject];
    CALayer* l1 = [self.view.layerDict objectForKey:p1];
    NSNumber *farbe = [self farbeFuerRasterfeldZeile:p1.y spalte:p1.x];
    NSString* imgName = [[Farbmapping sharedInstance] imageNameForColor:[farbe intValue] andSize:l1.bounds.size.width];
    UIImage* img = [UIImage imageNamed:imgName];
    CAKeyframeAnimation *contentAnimation;
    contentAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    contentAnimation.values = [NSArray arrayWithObjects:l1.contents, (id)[img CGImage], nil];
    contentAnimation.keyTimes = keyTimes;
    contentAnimation.removedOnCompletion = NO;
    contentAnimation.fillMode= kCAFillModeForwards;
    
    CAKeyframeAnimation *rotation;
    rotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.values = [NSArray arrayWithObjects:           // i.e., Rotation values for the 3 keyframes, in RADIANS
                        [NSNumber numberWithFloat:0.0 * M_PI], 
                        [NSNumber numberWithFloat:2 * M_PI], 
                        nil]; 
    rotation.keyTimes = keyTimes;
    rotation.timingFunctions = timingFunctions;
    CAKeyframeAnimation *zoom;

    zoom = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    zoom.values = [NSArray arrayWithObjects:
                   [NSNumber numberWithFloat:1.0f],
                   [NSNumber numberWithFloat:1.5f], 
                   [NSNumber numberWithFloat:1.0f], 
                    nil]; 
    rotation.keyTimes = [NSArray arrayWithObjects:     // Relative timing values for the 3 keyframes
                         [NSNumber numberWithFloat:0], 
                         [NSNumber numberWithFloat:0.5f], 
                         [NSNumber numberWithFloat:1.0f],
                         nil]; 
    rotation.timingFunctions = timingFunctions;

    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    [animGroup setAnimations:[NSArray arrayWithObjects:contentAnimation, /*rotation,*/ zoom, nil]];
    animGroup.duration = 0.5f;
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;

    for (Pair* p in differenz) {
        CALayer *tileLayer = [self.view.layerDict objectForKey:p];
        [tileLayer addAnimation:animGroup forKey:nil];
    }
    
}

-(void) spielAbbrechen {
    self.model.abgebrochen = YES;
    [self spielende];
}

- (IBAction)verlieren:(id)sender {
    [self spielende];
//    [self.view setNeedsDisplay];
}

- (IBAction)gewinnen:(id)sender {
#if DEBUG
    self.model.debugErzwungenerSieg = YES;
    [self spielende];
//    [self.view setNeedsDisplay];
#endif
}


#pragma - SpielrasterViewDataSource
-(NSNumber *) farbeFuerRasterfeldZeile:(NSUInteger)row spalte:(NSUInteger)col {
    return [self.model farbeAnPositionZeile:row spalte:col];
}

-(NSUInteger)rasterZeilen {
    return self.model.felderProKante;
}
-(NSUInteger)rasterSpalten {
    return self.model.felderProKante;    
}

#pragma - memory


- (void)dealloc
{
    [self stopAndClearTimer];
}


@end
