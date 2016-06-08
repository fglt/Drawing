//
//  PathPlistDataDelegate.m
//  Drawing
//
//  Created by Coding on 6/4/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "PathPlistDataDelegate.h"
#import "Path.h"
#import <UIKit/UIKit.h>
#import "constants.h"

@implementation PathPlistDataDelegate
@synthesize pathArray;
@synthesize filePath;
@synthesize pathsFileName;
@synthesize pathFileArray;

-(id)init{
    
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [dir stringByAppendingPathComponent:PathPlistFileName];
    NSFileManager *manager = [ NSFileManager defaultManager];
    pathsFileName = [dir stringByAppendingPathComponent:AllPathsFileName];
    BOOL  fileExits = [manager fileExistsAtPath:filePath];
    if(fileExits){
        pathArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    }
    
    if(pathArray  == nil)
        pathArray = [NSMutableArray array];
    
    if([manager fileExistsAtPath:pathsFileName]){
        pathFileArray = [NSMutableArray arrayWithContentsOfFile:pathsFileName];
    }
    if(pathFileArray == nil)
        pathFileArray = [NSMutableArray array];

    return self;
}

-(BOOL) newDrawing
{
    pathArray = [NSMutableArray array];
    NSFileManager *manager = [ NSFileManager defaultManager];
    return [manager removeItemAtPath:filePath error:nil];
}

-(BOOL) create:(Path *)path{

    CGFloat r,g,b,a;
    [path.color getRed:&r green:&g blue:&b alpha:&a];
    NSArray *colorArray = @[[NSNumber numberWithFloat:r],[NSNumber numberWithFloat:g],[NSNumber numberWithFloat:b],[NSNumber numberWithFloat:a]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[ colorArray, path.width, path.points] forKeys:@[ PathColor,  PathWidth, PathPoints] ];

    [pathArray addObject:dict];
    return [pathArray writeToFile:filePath atomically:YES];

}

-(BOOL) remove{
    [pathArray removeLastObject];

    return [pathArray writeToFile:filePath atomically:true];
}

-(BOOL) modify:(Path *)path{
    
    if([self remove]){
        return [self create:path];
    }
    
    return  NO;
}

-(NSMutableArray *) findAll{
    
    NSMutableArray *listData = [ [ NSMutableArray alloc] init];

    for (NSDictionary *dict in pathArray) {
        Path *path = [[Path alloc] init];
        NSArray *colorArray = [dict objectForKey:PathColor];
        path.color = [UIColor colorWithRed:[colorArray[0] floatValue] green:[colorArray[1] floatValue] blue:[colorArray[2] floatValue] alpha:[colorArray[3] floatValue]];
        path.width = [dict objectForKey:PathWidth];
        path.points = [dict objectForKey:PathPoints];
        
        [listData addObject:path];
    }
    
    return listData;
}

-(NSMutableArray *)  removeDrawing:(NSString *) drawingName
{
    for(int i=0; i< pathFileArray.count; i++)
    {
        if([pathFileArray[i] isEqualToString:drawingName])
        {
            [pathFileArray removeObjectAtIndex:i];
            [pathFileArray writeToFile:pathsFileName atomically:true];
            break;
        }
    }
    return pathFileArray;
}

-(BOOL) saveToFile:(NSString *)fileName
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dest = [dir stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"plist" ]];

    
    BOOL exist = false ;
    for(int i=0; i< pathFileArray.count; i++)
    {
        if([pathFileArray[i] isEqualToString:fileName])
        {
            exist = YES;
            break;
        }
    }
    
    if(!exist)
    {
        [pathFileArray addObject:fileName];
        [pathFileArray writeToFile:pathsFileName atomically:true];
    }

    return [pathArray writeToFile:dest atomically:YES];
}

-(NSMutableArray*) findByName:(NSString *)name
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *destpath = [dir stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"plist" ]];

    pathArray = [NSMutableArray arrayWithContentsOfFile:destpath];
    return [self  findAll];
}

-(NSMutableArray *) allPathFiles
{
    return pathFileArray;
}

-(NSMutableArray *)ArrayWithString:(NSString *)str
{
    NSMutableArray *arraytmp =[NSMutableArray array];
    
    int i=0;
    int j=0;
    for(; i<str.length; i++)
    {
        NSString *tmp;
        if([str characterAtIndex:i] == '{')
        {
            j= i;
        }
        if([str characterAtIndex:i] == '}')
        {
            tmp = [str substringWithRange:NSMakeRange(j, i-j+1)];
            [arraytmp addObject:tmp];
        }
    }
    
    return arraytmp;
}

-(void) createPlistFileWithFileName{
    NSFileManager *manager = [ NSFileManager defaultManager];
    //NSString *path = [self appDocumentsDirFileWithName:fileName];
    BOOL  fileExits = [manager fileExistsAtPath:filePath];
    if(!fileExits){
        NSString *defaultPath = [ [ [ NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:PathPlistFileName];
        NSError *err;
        BOOL  sucess = [ manager copyItemAtPath:defaultPath toPath:filePath error:&err];
        NSAssert(sucess, @"错误写入文件");
    }
    
}

-(NSString *) appDocumentsDirFileWithName{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [dir stringByAppendingPathComponent:PathPlistFileName];
    
    return filePath;
}


@end
