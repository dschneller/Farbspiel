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
    int felderProKante_;
    int maximaleZuege_;
    
    int zuege_;
    long spieldauer_;
    
}

@property (nonatomic, retain) NSMutableArray* farbfelder;
@property (assign)            SpielLevel      level;
@property (readonly)          int             felderProKante;
@property (assign)            int             zuege;
@property (readonly)          int             maximaleZuege;
@property (assign)            long            spieldauer;

-(id)initWithLevel:(SpielLevel)level;
-(NSNumber*) farbeAnPositionZeile:(int)row spalte:(int)col;
-(void)farbeGewaehlt:(int)colorNum;
-(BOOL) siegErreicht;


@end
