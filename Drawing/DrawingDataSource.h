//
//  DrawingDataSource.h
//  Drawing
//
//  Created by Coding on 6/5/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

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
