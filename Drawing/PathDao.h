//
//  PathDao.h
//  Drawing
//
//  Created by Coding on 6/4/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Path.h"
#import "PathDataDelegate.h"

@interface PathDao : NSObject
@property(strong, nonatomic) id<PathDataDelegate> delegate;
+(PathDao *) sharedInstance;

-(BOOL)newDrawing;
-(BOOL) create:(Path *) path;
-(BOOL) remove;
-(BOOL) modify:(Path *) path;
//-(BOOL) save:(NSMutableArray *)pathList;
-(NSMutableArray *) findAll;
-(BOOL) saveToFile:(NSString *)fileName;
-(NSMutableArray*) findByName:(NSString *)name;
-(NSMutableArray *) allPathFiles;
-(NSMutableArray *)  removeDrawing:(NSString *) drawingName;
@end
