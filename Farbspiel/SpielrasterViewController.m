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

-(void) updateZuegeDisplay {
    self.zuegeLabel.text = [NSString stringWithFormat:@"%d / %d", self.model.zuege, self.model.maximaleZuege];
}

-(void) setModel:(Spielmodel *)model {
    _model = model;
    [self.delegate spielrasterViewController:self modelDidChange:model];
    self.view.dataSource = self;
    [self.view prepareSublayers];
    //[self neuenSnapshotInstallieren];
    [self updateZuegeDisplay];
}

-(void) neuenSnapshotInstallieren
{
    UIImage* snapshotImg = [self.view snapshot];
    self.snapshotVIew.image = snapshotImg;
    self.view.layerDict = nil;
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
        (self.model.farbfelder)[i] = (previousModel.farbfelder)[i];
    }
    [self updateZuegeDisplay];
//    [self.view setNeedsDisplay];
}



- (void)updateLayersFromOldModel:(Spielmodel*)oldModel {
    // LAYERS updaten
    // 1. differenz zwischen neuem und altem model finden
    NSSet* differenz = [self.model unterschiedeZuModel:oldModel];

    // 2. Entsprechende Layers erzeugen und animieren
    if ([differenz count] == 0)
    {
        return;
    }
    CGSize size = self.view.tileSize;

    // alte Farbe ist bei allen gleich
    Pair *p1 = [[differenz objectEnumerator] nextObject];
    NSNumber* alteFarbe = [oldModel farbeAnPositionZeile:p1.y spalte:p1.x];
    NSString* imgNameAlt = [[Farbmapping sharedInstance] imageNameForColor:[alteFarbe intValue] andSize:size.width];
    UIImage* imgAlt = [UIImage imageNamed:imgNameAlt];
    
    // neue Farbe ist auch bei allen gleich
    NSNumber* neueFarbe = [self farbeFuerRasterfeldZeile:p1.y spalte:p1.x];
    NSString* imgNameNeu = [[Farbmapping sharedInstance] imageNameForColor:[neueFarbe intValue] andSize:size.width];
    UIImage* imgNeu = [UIImage imageNamed:imgNameNeu];
    
    
    // fuer jedes unterschiedliche Feld nun einen Layer anlegen,
    // der animiert und danach wieder weggeworfen wird, wenn ein
    // neuer Snapshot vorliegt. Initial ist die alte Farbe drin,
    // die dann weganimiert wird
    NSMutableArray* tempLayers = [NSMutableArray array];
    for (Pair* p in differenz)
    {
        CGRect frame = CGRectMake(p.x * size.width, p.y * size.height, size.width, size.height);
        CALayer *tile = [CALayer layer];
        tile.frame = frame;
        tile.contents = (__bridge id)([imgAlt CGImage]);
        [tempLayers addObject:tile];
        [self.view.layer addSublayer:tile];
    }

    // Animationsparameter
    NSArray* keyTimes = @[@0.0f,
                         @1.0f]; 
    NSArray* timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]]; // from keyframe 2 to keyframe 3
    
    CAKeyframeAnimation *contentAnimation;
    contentAnimation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    contentAnimation.values = @[(__bridge id)[imgAlt CGImage], (__bridge id)[imgNeu CGImage]];
    contentAnimation.keyTimes = keyTimes;
    contentAnimation.removedOnCompletion = NO;
    contentAnimation.fillMode= kCAFillModeForwards;
    
    
    CAKeyframeAnimation *rotation;
    rotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.values = @[[NSNumber numberWithFloat:0.0 * M_PI], 
                       [NSNumber numberWithFloat:2 * M_PI]]; 
    rotation.keyTimes = keyTimes;
    rotation.timingFunctions = timingFunctions;
    CAKeyframeAnimation *zoom;
    
    zoom = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    zoom.values = @[@1.0f,
                   @1.5f, 
                   @1.0f]; 
    rotation.keyTimes = @[@0.0f, 
                         @0.5f, 
                         @1.0f]; 
    rotation.timingFunctions = timingFunctions;
    


    [CATransaction begin];
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations =@[contentAnimation, /*rotation,*/ zoom];
    animGroup.duration = 2.5f;
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;

    for (CALayer* tileLayer in tempLayers)
    {
        [tileLayer addAnimation:animGroup forKey:nil];
    }
    [CATransaction commit];
    [CATransaction setCompletionBlock:^{
        UIImage *snapshot = [self.view snapshot];
        self.snapshotVIew.image = snapshot;
        for (CALayer *tileLayer in tempLayers)
        {
            [tileLayer removeFromSuperlayer];
        }
    }];
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
    
    [self updateLayersFromOldModel:oldModel];
    
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
