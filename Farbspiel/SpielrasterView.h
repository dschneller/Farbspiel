//
//  SpielrasterView.h
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol SpielrasterViewDatasource; 

@interface SpielrasterView : UIView {
    UIView* raster_;
    id<SpielrasterViewDatasource> dataSource_;
}

@property (nonatomic,strong) IBOutlet UIView* raster;
@property (nonatomic,strong) id<SpielrasterViewDatasource> dataSource;
@end



@protocol SpielrasterViewDatasource <NSObject>

-(NSNumber *) farbeFuerRasterfeldZeile:(NSUInteger)row spalte:(NSUInteger)col;
-(NSUInteger)rasterZeilen;
-(NSUInteger)rasterSpalten;

@end