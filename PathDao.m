//
//  PathDao.m
//  Drawing
//
//  Created by Coding on 6/4/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "PathDao.h"
#import "PathPlistDataDelegate.h"


@implementation PathDao

static PathDao *sharedInstace;
+(PathDao *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
        sharedInstace.delegate = [[PathPlistDataDelegate alloc] init];
    });
    
    return sharedInstace;
}

-(BOOL) newDrawing
{
    return [self.delegate newDrawing];
}

-(BOOL) create:(Path *) path
{
   return [self.delegate create:path];
}
-(BOOL) remove
{
    return [self.delegate remove];
    
}
-(BOOL) modify:(Path *) path
{
    return [self.delegate modify:path];
}

-(NSMutableArray *) findAll
{
    return [self.delegate findAll];
}

//-(BOOL) save:(NSMutableArray *)pathList
//{
//    return [self.delegate save:pathList];
//}

-(BOOL) saveToFile:(NSString *)fileName
{
    return [self.delegate saveToFile:fileName];
}

-(NSMutableArray*) findByName:(NSString *)name
{
    return [self.delegate findByName:name];
}

-(NSMutableArray *) allPathFiles
{
    return [self.delegate allPathFiles];
}


-(NSMutableArray *)  removeDrawing:(NSString *) drawingName
{
    return [self.delegate removeDrawing:drawingName];
}

@end
