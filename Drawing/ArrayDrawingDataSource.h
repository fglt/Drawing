//
//  DrawingViewController.h
//  Drawing
//
//  Created by Coding on 6/7/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DrawingView.h"
#import "PathBL.h"
#import "Path.h"

@interface ArrayDrawingDataSource:NSObject<DrawingDataSource>

@property (strong, nonatomic) NSMutableArray *pathsList;
@property (strong, nonatomic) NSMutableArray *abandonedPathList;
@property (strong, nonatomic) PathBL *pathBL;

@end
