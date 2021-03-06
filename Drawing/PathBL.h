//
//  PathBL.h
//  Drawing
//
//  Created by Coding on 6/4/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PathDao.h"

@interface PathBL : NSObject
@property PathDao *pathDao;


-(NSMutableArray *) newDrawing;

//插入Path方法
-(NSMutableArray*) createPath:(Path*)path;

//删除Path方法
-(NSMutableArray*) remove;

//查询所用数据方法
-(NSMutableArray*) findAll;
-(BOOL) saveToFile:(NSString *)fileName;

-(NSMutableArray*) findByName:(NSString *)name;
-(NSMutableArray *) allPathFiles;
-(NSMutableArray *)  removeDrawing:(NSString *) drawingName;
@end
