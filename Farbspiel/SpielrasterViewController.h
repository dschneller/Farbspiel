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

@property (nonatomic, strong) IBOutlet UILabel *zuegeLabel;
@property (nonatomic, strong) SpielrasterView* view;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (nonatomic, strong) Spielmodel* model;
@property (nonatomic, strong) id<SpielrasterViewControllerDelegate> delegate;

-(void) colorClicked:(NSUInteger)colorNumber;
-(void) spielAbbrechen;
-(void)updateLayersFromOldModel:(Spielmodel*)oldModel;

- (IBAction)verlieren:(id)sender;
- (IBAction)gewinnen:(id)sender;

@end




@protocol SpielrasterViewControllerDelegate <NSObject>

-(void)spielrasterViewController:(SpielrasterViewController*)controller modelDidChange:(Spielmodel*)model;

-(void)spielrasterViewController:(SpielrasterViewController*)controller spielEndeMitModel:(Spielmodel*)model;

@end