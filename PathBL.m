//
//  PathBL.m
//  Drawing
//
//  Created by Coding on 6/4/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "PathBL.h"
#import "PathPlistDataDelegate.h"

@implementation PathBL


- (id) init{
    
    self.pathDao = [PathDao sharedInstance];
    
    return self;
    
}
//插入Path方法
-(NSMutableArray*) createPath:(Path*)path
{
    [self.pathDao create:path];
    return [self.pathDao findAll];
}

//删除Path方法
-(NSMutableArray*) remove
{
    [self.pathDao remove];
    return [self.pathDao findAll];
}

//查询所用数据方法
-(NSMutableArray*) findAll
{
    return [self.pathDao findAll];
}
-(BOOL) save:(NSMutableArray *)pathList
{
    return [self.pathDao save:pathList];
}
@end
