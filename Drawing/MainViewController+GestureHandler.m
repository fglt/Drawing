//
//  MainViewController+GestureHandler.m
//  Drawing
//
//  Created by Coding on 7/15/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "MainViewController+GestureHandler.h"

@implementation MainViewController (GestureHandler)

-(void) addGesture
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self                                               action:@selector(handlePan:)];
    
    // 旋转的 Recognizer
    UIRotationGestureRecognizer *rotateRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    // 捏合的 Recognizer
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    
    [self.view addGestureRecognizer:panGestureRecognizer];
    [self.view addGestureRecognizer:rotateRecognizer];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
}

- (void)handlePan:(UIPanGestureRecognizer*) recognizer
{
    NSLog(@"拖移，慢速移动");
    CGPoint translation = [recognizer translationInView:self.view];
    self.drawing.center = CGPointMake(self.drawing.center.x + translation.x, self.drawing.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.view];
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    NSLog(@"捏合, %f", recognizer.scale);
    self.drawing.transform = CGAffineTransformScale(self.drawing.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (void) handleRotate:(UIRotationGestureRecognizer*) recognizer
{
    NSLog(@"旋转, %f", recognizer.rotation);
    self.drawing.transform = CGAffineTransformRotate(self.drawing.transform, recognizer.rotation);
    recognizer.rotation = 0;
}
@end
