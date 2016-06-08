//
//  DrawingViewController.m
//  Drawing
//
//  Created by Coding on 6/7/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "DrawingViewController.h"

@interface DrawingViewController ()

@end

@implementation DrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pathBL = [ [PathBL alloc] init];
    self.drawing.delegate = self;
    self.drawing.dataSource = self;
    self.pathsList = [self.pathBL findAll];
    self.abandonedPathList = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - drawingViewDataSource
-(u_long) numberOfPath
{
    
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

-(void) reDraw
{
    [self.drawing setNeedsDisplay];
    
}

@end
