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
-(BOOL) newDrawing;
-(BOOL) create:(Path *)path;
-(BOOL) remove;
-(BOOL) modify:(Path *)path;
-(NSMutableArray *)findAll;
//-(BOOL) save:(NSMutableArray *)pathList;
-(BOOL) saveToFile:(NSString *)fileName;
-(NSMutableArray*) findByName:(NSString *)name;
-(NSMutableArray *) allPathFiles;
-(NSMutableArray *)  removeDrawing:(NSString *) drawingName;
@end
