//
//  Path.h
//  Drawing
//
//  Created by Coding on 6/4/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Path : NSObject
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) NSNumber *width;
@property (strong, nonatomic) NSMutableArray *points;
@end
