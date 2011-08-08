//
//  SpielrasterView.h
//  Farbspiel
//
//  Created by Daniel Schneller on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SpielrasterViewDatasource; 

@interface SpielrasterView : UIView {
    UIView* raster_;
    id<SpielrasterViewDatasource> dataSource_;
}

@property (nonatomic,retain) IBOutlet UIView* raster;
@property (nonatomic,retain) id<SpielrasterViewDatasource> dataSource;
@end



@protocol SpielrasterViewDatasource <NSObject>

-(NSNumber *) farbeFuerRasterfeldZeile:(NSUInteger)row spalte:(NSUInteger)col;
-(NSUInteger)rasterZeilen;
-(NSUInteger)rasterSpalten;

@end