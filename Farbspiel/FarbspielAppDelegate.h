//
//  FarbspielAppDelegate.h
//  Farbspiel
//
//  Created by Schneller Daniel on 21.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FarbspielViewController;

@interface FarbspielAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet FarbspielViewController *viewController;

@end
