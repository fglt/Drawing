//
//  PathDataDelegate.h
//  Drawing
//
//  Created by Coding on 6/4/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Path.h"

@protocol PathDataDelegate <NSObject>

@required
-(BOOL) create:(Path *)path;
-(BOOL) remove;
-(BOOL) modify:(Path *)path;
-(NSMutableArray *)findAll;
-(BOOL) save:(NSMutableArray *)pathList;
@end
