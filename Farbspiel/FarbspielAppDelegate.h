//
//  FarbspielAppDelegate.h
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FarbspielViewController;

@interface FarbspielAppDelegate : NSObject <UIApplicationDelegate> {

    UINavigationController *_navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet FarbspielViewController *viewController;

@end
