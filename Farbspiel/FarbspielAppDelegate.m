//
//  FarbspielAppDelegate.m
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FarbspielAppDelegate.h"

#import "FarbspielViewController.h"
#import "Prefkeys.h"
#import "Spielmodel.h"

@implementation FarbspielAppDelegate


@synthesize window=_window;
@synthesize navigationController = _navigationController;

@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSNumber* zero = [NSNumber numberWithInt:0];
    // since no default values have been set (i.e. no preferences file created), create it here		
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 zero, [NSString stringWithFormat:PREFKEY_GEWONNENZAEHLER_FORMAT,EASY],
                                 zero, [NSString stringWithFormat:PREFKEY_SPIELZAEHLER_FORMAT,EASY],
                                 zero, [NSString stringWithFormat:PREFKEY_GEWONNENZAEHLER_FORMAT,MEDIUM],
                                 zero, [NSString stringWithFormat:PREFKEY_SPIELZAEHLER_FORMAT,MEDIUM],
                                 zero, [NSString stringWithFormat:PREFKEY_GEWONNENZAEHLER_FORMAT,HARD],
                                 zero, [NSString stringWithFormat:PREFKEY_SPIELZAEHLER_FORMAT,HARD],
                                 [NSNumber numberWithBool:YES], PREFKEY_SOUND_AN,
                                 [NSNumber numberWithBool:YES], PREFKEY_GITTER_AN,
                                 nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
     
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor blackColor];
    
//    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    NSLog(@"Synced defaults: %d", [[NSUserDefaults standardUserDefaults] synchronize]);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [_navigationController release];
    [super dealloc];
}

@end
