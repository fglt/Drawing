//
//  DrawingViewController.m
//  Drawing
//
//  Created by Coding on 6/7/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "ArrayDrawingDataSource.h"
#import "constants.h"

@interface ArrayDrawingDataSource ()

@end

@implementation ArrayDrawingDataSource

- (id)init {
    self = [super init];

    self.pathBL = [ [PathBL alloc] init];
    self.pathsList = [self.pathBL findAll];
    self.abandonedPathList = [NSMutableArray array];
    
    return self;
}

#pragma mark - drawingViewDataSource
-(u_long) numberOfPath
{
    //NSLog(@"path count: %ld",self.pathsList.count);
    return self.pathsList.count;
    
}

-(Path *) pathAtIndex:(u_long)index
{
    return self.pathsList[index];
}

-(Path *) pathAtLast
{
    return [self.pathsList lastObject];
}
-(u_long) numberOfAbandonedPath
{
    return self.abandonedPathList.count;
}

-(Path *) AbandonedPathAtLast
{
    Path *path = [self.abandonedPathList lastObject];
    [self.abandonedPathList removeLastObject];
    
    return path;
}

-(void) addPath:(Path*)path
{
    self.pathsList = [self.pathBL createPath:path];
}

-(void) removeLast
{
    self.pathsList = [self.pathBL remove];
}

-(void) addAbandonedPath
{
    if(self.pathsList.count>0){
        Path *path = [self.pathsList lastObject];
        self.pathsList = [self.pathBL remove];
        [self.abandonedPathList addObject:path];
    }
}

-(void) backAbandonedPath
{
    if(self.abandonedPathList.count>0){
        Path *path = [self.abandonedPathList lastObject];
        [self.abandonedPathList removeLastObject];
        self.pathsList = [self.pathBL createPath:path];
    }
}

-(void) loadNewDrawing:(NSString*)drawingName
{
    if([drawingName isEqualToString:NewDrawingStr]){
        self.pathsList = [self.pathBL newDrawing];
    }else{
        self.pathsList = [self.pathBL findByName:drawingName];
    }
    self.abandonedPathList  = [NSMutableArray array];
}

-(void) saveToFile:(NSString*)name
{
    [self.pathBL saveToFile:name];
}
@end
