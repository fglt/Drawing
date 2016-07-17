//
//  Drawing.h
//  Drawing
//
//  Created by Coding on 6/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Path.h"


@protocol DrawingDataSource;

@interface DrawingView : UIView
//@property CGFloat radius;

@property UIColor *pathColor;
@property CGFloat pathWidth;

@property (weak, nonatomic) id<DrawingDataSource> dataSource;
@property Path *curPath;

-(void) viewSet;
-(void) roatation;
-(void) loadNewDrawing:(NSString*) drawingName;
-(void) saveToFile:(NSString *)name;
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
-(void) loadNewDrawing:(NSString*)drawingName;
-(void) saveToFile:(NSString*)name;
@end

