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

- (UIImage *)captureWithView
{
    // 1.开启上下文，第二个参数是是否不透明（opaque）NO为透明，这样可以防止占据额外空间（例如圆形图会出现方框），第三个为伸缩比例，0.0为不伸缩。
    UIGraphicsBeginImageContextWithOptions(self.drawing.frame.size, NO, 0.0);
    
    // 2.将控制器view的layer渲染到上下文
    [self.drawing.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 3.取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}



//-(BOOL)shouldAutorotate{
//    if([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ||[[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight)
//    {
//        return NO;
//    }
//    else{
//        return YES;
//    }
//}
@end
