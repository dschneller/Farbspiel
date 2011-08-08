//
//  Spielmodel.h
//  Farbspiel
//
//  Created by Daniel Schneller on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SPALTEN_EASY 12
#define ZUEGE_EASY 22
  

#define SPALTEN_MEDIUM 18
#define ZUEGE_MEDIUM 30  

#define SPALTEN_HARD 24
#define ZUEGE_HARD 36   


typedef enum {
    EASY = 0,
    MEDIUM = 1,
    HARD = 2,
} SpielLevel;



@interface Spielmodel : NSObject {
    SpielLevel level_;
    NSMutableArray *farbfelder_;
    NSUInteger felderProKante_;
    NSUInteger maximaleZuege_;
    
    NSUInteger zuege_;
    long spieldauer_;
    BOOL abgebrochen_;
    
}

@property (nonatomic, retain) NSMutableArray* farbfelder;
@property (assign)            SpielLevel      level;
@property (readonly)          NSUInteger felderProKante;
@property (assign)            NSUInteger             zuege;
@property (readonly)          NSUInteger             maximaleZuege;
@property (assign)            long            spieldauer;
@property (assign)            BOOL            abgebrochen;

-(id)initWithLevel:(SpielLevel)level;
-(NSNumber *) farbeAnPositionZeile:(NSUInteger)row spalte:(NSUInteger)col;
-(void)farbeGewaehlt:(NSUInteger)colorNum;
-(BOOL) siegErreicht;
-(BOOL) verloren;
-(int) spaltenFuerLevel:(SpielLevel)level;
-(int) maximaleZuegeFuerLevel:(SpielLevel)level;
-(BOOL) spielLaeuft;

@end
