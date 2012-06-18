//
//  SoundManager.m
//  Farbspiel
//
//  Created by Daniel Schneller on 22.07.11.
//  Copyright 2011 codecentric AG. All rights reserved.
//

#import "SoundManager.h"
#import "Datenhaltung.h"

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
        _soundAn = [[Datenhaltung sharedInstance] boolFuerKey:PREFKEY_SOUND_AN];    
    }
    return self;
}

+(SoundManager*) sharedManager {
    return sharedSingleton;
}

-(BOOL)schalteSound {
    _soundAn = !_soundAn;
    [[Datenhaltung sharedInstance] setBool:self.soundAn forKey:PREFKEY_SOUND_AN];
    [[NSNotificationCenter defaultCenter] postNotificationName:SOUNDMANAGER_NOTIFICATION_SOUNDAN object:@(_soundAn)];
    return _soundAn;
    
}

-(void) playSound:(NSString*)filename ext:(NSString*)ext forSoundType:(SoundType)type //withId:(SystemSoundID)soundId;
{
    if (!_soundAn) {
        return;
    }
    if (!sounds_[type]) {
        SystemSoundID newSoundId;
        NSString *path  = [[NSBundle mainBundle] pathForResource:filename ofType:ext];
        if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
            NSURL *pathURL = [NSURL fileURLWithPath : path];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &newSoundId);
            sounds_[type] = newSoundId;
        } else {
            LOG_GAME(0, @"error, sound file not found: %@", path);
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
}

@end
