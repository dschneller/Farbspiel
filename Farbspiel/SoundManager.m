//
//  SoundManager.m
//  Farbspiel
//
//  Created by Daniel Schneller on 22.07.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import "SoundManager.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SoundManager

static SoundManager *sharedSingleton;

+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
        sharedSingleton = [[SoundManager alloc] init];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        for (int i=0; i<NUMSOUNDS; i++) {
            sounds_[i] = 0;
        }
    }
    return self;
}

+(SoundManager*) sharedManager {
    return sharedSingleton;
}


-(void) playSound:(NSString*)filename ext:(NSString*)ext forSoundType:(SoundType)type //withId:(SystemSoundID)soundId;
{
    if (!sounds_[type]) {
        SystemSoundID newSoundId;
        NSString *path  = [[NSBundle mainBundle] pathForResource:filename ofType:ext];
        if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
            NSURL *pathURL = [NSURL fileURLWithPath : path];
            AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &newSoundId);
            sounds_[type] = newSoundId;
        } else {
            NSLog(@"error, sound file not found: %@", path);
        }
    }
    AudioServicesPlayAlertSound(sounds_[type]);
}

-(void)playSound:(SoundType)sound {
    NSString* soundFileName;
    switch (sound) {
        case BUTTON:
            soundFileName = @"210";
            break;
        case GEWONNEN:
            soundFileName = @"215";
            break;
            
        case VERLOREN:
            soundFileName = @"225";
            break;
            
        default:
            soundFileName = nil;
            break;
    }
    
    [self playSound:soundFileName ext:@"caf" forSoundType:sound];
}



#pragma mark - Resource Management


- (void)disposeSoundEffects {
    for (int i=0; i<NUMSOUNDS; i++) {
        SystemSoundID sound = sounds_[i];
        if (sound) {
            AudioServicesDisposeSystemSoundID(sound);
            sounds_[i]=0;
        }
    }
}




- (void)dealloc {
    [self disposeSoundEffects];
    [super dealloc];
}

@end
