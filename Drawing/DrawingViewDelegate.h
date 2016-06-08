//
//  DrawingViewDelegate.h
//  Drawing
//
//  Created by Coding on 6/5/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DrawingView.h"

@class DrawingView;
@protocol DrawingViewDelegate <NSObject>

//-(void) addPath:(Path*)path;
//-(void) removeLast;
//-(void) addAbandonedPath;
//-(void) backAbandonedPath;

-(void) reDraw;
@end
