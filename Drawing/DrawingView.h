//
//  Drawing.h
//  Drawing
//
//  Created by Coding on 6/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Path.h"


@protocol DrawingViewDelegate;
@protocol DrawingDataSource;

@interface DrawingView : UIView
//@property CGFloat radius;

@property UIColor *pathColor;
@property CGFloat pathWidth;
@property (weak, nonatomic) id<DrawingViewDelegate> delegate;
@property (weak, nonatomic) id<DrawingDataSource> dataSource;

-(void) viewSet;
-(void) roatation;

@end

@protocol DrawingDataSource <NSObject>


@required
-(u_long) numberOfPath;
-(Path *) pathAtIndex:(u_long)index;
-(Path *) pathAtLast;
-(u_long) numberOfAbandonedPath;
-(Path *) AbandonedPathAtLast;
-(void) addPath:(Path*)path;
-(void) removeLast;
-(void) addAbandonedPath;
-(void) backAbandonedPath;
@end

@protocol DrawingViewDelegate <NSObject>

-(void) reDraw;
@end
