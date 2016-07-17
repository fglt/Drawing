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
@synthesize tempDrawing;
@synthesize drawingsFileName;
@synthesize drawingFileArray;

-(id)init{
    
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    tempDrawing = [dir stringByAppendingPathComponent:PathPlistFileName];
    NSFileManager *manager = [ NSFileManager defaultManager];
    drawingsFileName = [dir stringByAppendingPathComponent:AllPathsFileName];
    BOOL  fileExits = [manager fileExistsAtPath:tempDrawing];
    if(fileExits){
        pathArray = [NSMutableArray arrayWithContentsOfFile:tempDrawing];
    }
    
    if(pathArray  == nil)
        pathArray = [NSMutableArray array];
    
    if([manager fileExistsAtPath:drawingsFileName]){
        drawingFileArray = [NSMutableArray arrayWithContentsOfFile:drawingsFileName];
    }
    if(drawingFileArray == nil)
        drawingFileArray = [NSMutableArray array];

    return self;
}

-(BOOL) newDrawing
{
    pathArray = [NSMutableArray array];
    NSFileManager *manager = [ NSFileManager defaultManager];
    return [manager removeItemAtPath:tempDrawing error:nil];
}

-(BOOL) create:(Path *)path{

    CGFloat r,g,b,a;
    [path.color getRed:&r green:&g blue:&b alpha:&a];
    NSArray *colorArray = @[[NSNumber numberWithFloat:r],[NSNumber numberWithFloat:g],[NSNumber numberWithFloat:b],[NSNumber numberWithFloat:a]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[ colorArray, path.width, path.points] forKeys:@[ PathColor,  PathWidth, PathPoints] ];

    [pathArray addObject:dict];
    return [pathArray writeToFile:tempDrawing atomically:YES];

}

-(BOOL) remove{
    [pathArray removeLastObject];

    return [pathArray writeToFile:tempDrawing atomically:true];
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
    for(int i=0; i< drawingFileArray.count; i++)
    {
        if([drawingFileArray[i] isEqualToString:drawingName])
        {
            [drawingFileArray removeObjectAtIndex:i];
            [drawingFileArray writeToFile:drawingsFileName atomically:true];
            break;
        }
    }
    return drawingFileArray;
}

-(BOOL) saveToFile:(NSString *)fileName
{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dest = [dir stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:@"plist" ]];

    
    BOOL exist = false ;
    for(int i=0; i< drawingFileArray.count; i++)
    {
        if([drawingFileArray[i] isEqualToString:fileName])
        {
            exist = YES;
            break;
        }
    }
    
    if(!exist)
    {
        [drawingFileArray addObject:fileName];
        [drawingFileArray writeToFile:drawingsFileName atomically:true];
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
    return drawingFileArray;
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
    BOOL  fileExits = [manager fileExistsAtPath:tempDrawing];
    if(!fileExits){
        NSString *defaultPath = [ [ [ NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:PathPlistFileName];
        NSError *err;
        BOOL  sucess = [ manager copyItemAtPath:defaultPath toPath:tempDrawing error:&err];
        NSAssert(sucess, @"错误写入文件");
    }
    
}

-(NSString *) appDocumentsDirFileWithName{
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    tempDrawing = [dir stringByAppendingPathComponent:PathPlistFileName];
    
    return tempDrawing;
}


@end
