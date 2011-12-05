//
//  GewonnenVerlorenControllerDelegate.h
//  Farbspiel
//
//  Created by Daniel Schneller on 05.12.11.
//  Copyright (c) 2011 codecentric AG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spielmodel.h"

@protocol GewonnenVerlorenControllerDelegate <NSObject>

@required
-(void)neuesSpiel;
-(Spielmodel*)spielModel;
-(void)didReturnFromSettings;

@optional
-(UINavigationController*) navigationController;

@end