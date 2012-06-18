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
    UIView* _raster;
    id<SpielrasterViewDatasource> _dataSource;
    CALayer* _gridLayer;
    NSMutableDictionary* _layerDict;
}

@property (nonatomic,strong) IBOutlet UIView* raster;
@property (nonatomic,strong) id<SpielrasterViewDatasource> dataSource;
@property (nonatomic,strong) NSMutableDictionary* layerDict;
@property (nonatomic,strong) CALayer* gridLayer;
- (void) prepareSublayers;

@end



@protocol SpielrasterViewDatasource <NSObject>

-(NSNumber *) farbeFuerRasterfeldZeile:(NSUInteger)row spalte:(NSUInteger)col;
-(NSUInteger)rasterZeilen;
-(NSUInteger)rasterSpalten;

@end