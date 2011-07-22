//
//  SpielrasterViewController.h
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpielrasterView.h"
#import "Spielmodel.h"

@protocol SpielrasterViewControllerDelegate;

@interface SpielrasterViewController : NSObject <SpielrasterViewDatasource> {
    Spielmodel* model_;
    SpielrasterView* view_;
    id<SpielrasterViewControllerDelegate> delegate_;
    NSTimer* timer_;
    UILabel *zuegeLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *zuegeLabel;
@property (nonatomic, retain) SpielrasterView* view;
@property (nonatomic, retain) Spielmodel* model;
@property (nonatomic, retain) id<SpielrasterViewControllerDelegate> delegate;

-(void) colorClicked:(int)colorNumber;
- (IBAction)verlieren:(id)sender;

@end




@protocol SpielrasterViewControllerDelegate <NSObject>

-(void)spielrasterViewController:(SpielrasterViewController*)controller modelDidChange:(Spielmodel*)model;

-(void)spielrasterViewController:(SpielrasterViewController*)controller spielEndeMitModel:(Spielmodel*)model;

@end