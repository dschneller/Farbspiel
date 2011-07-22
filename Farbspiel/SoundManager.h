//
//  SoundManager.h
//  Farbspiel
//
//  Created by Daniel Schneller on 22.07.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define NUMSOUNDS 3

typedef enum {
    BUTTON = 0,
    GEWONNEN = 1,
    VERLOREN = 2,
} SoundType;


@interface SoundManager : NSObject {
    SystemSoundID sounds_[NUMSOUNDS];
}

+(SoundManager*) sharedManager;

-(void)playSound:(SoundType)sound;


@end
