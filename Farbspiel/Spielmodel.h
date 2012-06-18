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
    SpielLevel _level;
    NSMutableArray* _farbfelder;
    NSUInteger _felderProKante;
    NSUInteger _maximaleZuege;
    
    NSUInteger _zuege;
    long _spieldauer;
    BOOL _abgebrochen;
    
#if DEBUG
    BOOL _debugErzwungenerSieg;
#endif
}

@property (nonatomic, strong) NSMutableArray*   farbfelder;
@property (assign)            SpielLevel        level;
@property (readonly)          NSUInteger        felderProKante;
@property (assign)            NSUInteger        zuege;
@property (readonly)          NSUInteger        maximaleZuege;
@property (assign)            long              spieldauer;
@property (assign)            BOOL              abgebrochen;
#if DEBUG
@property (assign)            BOOL              debugErzwungenerSieg;
#endif

-(id)initWithModel:(Spielmodel*)templateModel;
-(id)initWithLevel:(SpielLevel)level;
-(NSNumber *) farbeAnPositionZeile:(NSUInteger)row spalte:(NSUInteger)col;
-(void)farbeGewaehlt:(NSUInteger)colorNum;
-(void)farbeGewaehlt:(NSUInteger)colorNum fuerPositionX:(NSUInteger)x Y:(NSUInteger)y;
-(BOOL) siegErreicht;
-(BOOL) verloren;
-(int) spaltenFuerLevel:(SpielLevel)level;
-(int) maximaleZuegeFuerLevel:(SpielLevel)level;
-(BOOL) spielLaeuft;
-(NSSet*)unterschiedeZuModel:(Spielmodel*)other;

+(NSString*) levelNameFor:(SpielLevel)level;
@end
