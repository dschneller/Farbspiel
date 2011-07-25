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
#define SOUNDMANAGER_NOTIFICATION_SOUNDAN @"soundAn"

typedef enum {
    BUTTON = 0,
    GEWONNEN = 1,
    VERLOREN = 2,
} SoundType;


@interface SoundManager : NSObject {
    SystemSoundID sounds_[NUMSOUNDS];
    BOOL soundAn_;
}

@property (nonatomic,assign) BOOL soundAn;

+(SoundManager*) sharedManager;
-(void)playSound:(SoundType)sound;
-(BOOL)schalteSound;

@end

