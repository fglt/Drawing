//
//  Drawing.h
//  Drawing
//
//  Created by Coding on 6/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Drawing : UIView
//@property CGFloat radius;
@property NSMutableArray *pathArray;
@property NSMutableArray *pathAbandonedArray;
@property UIColor *pathColor;
@property CGFloat pathWidth;


-(void) viewSet;
@end
