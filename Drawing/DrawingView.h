//
//  Drawing.h
//  Drawing
//
//  Created by Coding on 6/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Path.h"
#import "DrawingViewDelegate.h"
#import "DrawingDataSource.h"

@interface DrawingView : UIView
//@property CGFloat radius;

@property UIColor *pathColor;
@property CGFloat pathWidth;
@property (weak, nonatomic) id<DrawingViewDelegate> delegate;
@property (weak, nonatomic) id<DrawingDataSource> dataSource;

-(void) viewSet;
@end
