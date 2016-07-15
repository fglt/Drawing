//
//  GestureHandler.m
//  Drawing
//
//  Created by Coding on 7/15/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "GestureHandler.h"

@implementation GestureHandler
//- (void)handlePan:(UIPanGestureRecognizer*) recognizer
//{
//    NSLog(@"拖移，慢速移动");
//    CGPoint translation = [recognizer translationInView:self.view];
//    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
//    [recognizer setTranslation:CGPointZero inView:self.view];
//}
//
//- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
//{
//    NSLog(@"捏合, %f", recognizer.scale);
//    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
//    recognizer.scale = 1;
//}
//
//- (void) handleRotate:(UIRotationGestureRecognizer*) recognizer
//{
//    NSLog(@"旋转, %f", recognizer.rotation);
//    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
//    recognizer.rotation = 0;
//}
@end
