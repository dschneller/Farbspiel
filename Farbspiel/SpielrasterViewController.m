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
    [self.view setNeedsDisplay];
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
    [self.view setNeedsDisplay];
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
    for (Pair* p in differenz) {
        CALayer *tileLayer = [self.view.layerDict objectForKey:p];
        NSNumber *farbe = [self farbeFuerRasterfeldZeile:p.y spalte:p.x];
        NSString* imgName = [[Farbmapping sharedInstance] imageNameForColor:[farbe intValue] andSize:tileLayer.bounds.size.width];
        
        UIImage *img = [UIImage imageNamed:imgName];
        tileLayer.contents = (id)[img CGImage];
        if ([[Datenhaltung sharedInstance] boolFuerKey:PREFKEY_GITTER_AN]) {
            tileLayer.borderWidth = 0.5f;
            tileLayer.borderColor = [[UIColor darkGrayColor] CGColor];
        } else {
            tileLayer.borderWidth = 0.0f;
        }
    }
    
    [self.view setNeedsDisplay];
}

-(void) spielAbbrechen {
    self.model.abgebrochen = YES;
    [self spielende];
}

- (IBAction)verlieren:(id)sender {
    [self spielende];
    [self.view setNeedsDisplay];
}

- (IBAction)gewinnen:(id)sender {
#if DEBUG
    self.model.debugErzwungenerSieg = YES;
    [self spielende];
    [self.view setNeedsDisplay];
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
