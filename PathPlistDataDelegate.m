//
//  PathPlistDataDelegate.m
//  Drawing
//
//  Created by Coding on 6/4/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "PathPlistDataDelegate.h"
#import "Path.h"
#include <UIKit/UIKit.h>

NSString * const PathColor = @"color";
NSString * const PathWidth =@"width";
NSString * const PathPoints = @"points";
NSString * const PathPlistFileName = @"PathList.plist";
@implementation PathPlistDataDelegate

-(id)init{
    
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [dir stringByAppendingPathComponent:PathPlistFileName];
    NSFileManager *manager = [ NSFileManager defaultManager];
    
    BOOL  fileExits = [manager fileExistsAtPath:filePath];
    if(!fileExits){
        NSString *defaultPath = [ [ [ NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:PathPlistFileName];
        NSError *err;
        BOOL  sucess = [ manager copyItemAtPath:defaultPath toPath:filePath error:&err];
        NSAssert(sucess, @"错误写入文件");
    }
    
    array = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    return self;
}

-(BOOL) create:(Path *)path{

    CGFloat r,g,b,a;
    [path.color getRed:&r green:&g blue:&b alpha:&a];
    NSArray *colorArray = @[[NSNumber numberWithFloat:r],[NSNumber numberWithFloat:g],[NSNumber numberWithFloat:b],[NSNumber numberWithFloat:a]];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[ colorArray, path.width, path.points] forKeys:@[ PathColor,  PathWidth, PathPoints] ];

    [array addObject:dict];
    return [array writeToFile:filePath atomically:YES];

}

-(BOOL) remove{
    [array removeLastObject];

    return [array writeToFile:filePath atomically:true];
}

-(BOOL) modify:(Path *)path{
    
    if([self remove]){
        return [self create:path];
    }
    
    return  NO;
}

-(NSMutableArray *) findAll{
    
    NSMutableArray *listData = [ [ NSMutableArray alloc] init];

    for (NSDictionary *dict in array) {
        Path *path = [[Path alloc] init];
        NSArray *colorArray = [dict objectForKey:PathColor];
        path.color = [UIColor colorWithRed:[colorArray[0] floatValue] green:[colorArray[1] floatValue] blue:[colorArray[2] floatValue] alpha:[colorArray[3] floatValue]];
        path.width = [dict objectForKey:PathWidth];
        path.points = [dict objectForKey:PathPoints];
        
        [listData addObject:path];
    }
    
    return listData;
}

-(BOOL) save:(NSMutableArray *)pathList
{
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for(int i=0; i<pathList.count; i++)
        {
            Path *path = pathList[i];
            UIColor *color = path.color;
            CGFloat r,g,b,a;
            [color getRed:&r green:&g blue:&b alpha:&a];
            NSArray *colorArray = @[[NSNumber numberWithFloat:r],[NSNumber numberWithFloat:g],[NSNumber numberWithFloat:b],[NSNumber numberWithFloat:a]];
            NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[ colorArray, path.width, path.points] forKeys:@[ PathColor,  PathWidth, PathPoints] ];
            [tmpArray addObject:dict];
            NSLog(@"color: %@",color.description);
        }
    BOOL sucess = [tmpArray writeToFile:filePath atomically:true];
    return sucess;
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
