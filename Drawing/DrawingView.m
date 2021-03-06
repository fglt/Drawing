//
//  Drawing.m
//  Drawing
//
//  Created by Coding on 6/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "DrawingView.h"

IB_DESIGNABLE
@implementation DrawingView
@synthesize pathColor;
@synthesize pathWidth;
@synthesize curPath;


-(void) viewSet
{
    pathWidth = 4;

}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self !=nil){
        [self viewSet];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self !=nil){
        [self viewSet];
    }
    
    return self;
}

-(void) roatation
{
    
    UIDeviceOrientation or = [[UIDevice currentDevice] orientation];
    CGAffineTransform at = CGAffineTransformMakeRotation(0);
    switch (or) {
        case UIDeviceOrientationPortrait:
            at =  CGAffineTransformMakeRotation(M_PI * 0.5);
            break;
        case UIDeviceOrientationLandscapeLeft:
            at =  CGAffineTransformMakeRotation(0);
            break;
            
        case UIDeviceOrientationLandscapeRight:
            at =  CGAffineTransformMakeRotation(M_PI );
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            at =  CGAffineTransformMakeRotation(-M_PI *0.5 );
            break;
        default:
            break;
    }
//    CGRect rf = self.frame ;
//    CGRect rb = self.bounds;
//    self.frame = CGRectMake(0, 0, 1024, 768);
//    self.bounds = CGRectMake(0, 0, 1024, 768);
    [self setTransform:at];
}

- (void)drawRect:(CGRect)rect {

    u_long count = [self.dataSource numberOfPath];
    
    for(int i=0; i<count; i++){
        Path *path = [self.dataSource pathAtIndex:i];
        [self drawPath:path];
    }
    [self drawPath:curPath];
}

-(void)drawPath:(Path*)path
{
    NSMutableArray *pointsArray = path.points;
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    [path.color set];
    bpath.lineWidth = [path.width floatValue];;
    
    [bpath moveToPoint: CGPointFromString(pointsArray[0]) ];
    
    for (int j=0; j<pointsArray.count; j++)
    {
        [bpath addLineToPoint:CGPointFromString(pointsArray[j])];
    }
    bpath.lineCapStyle = kCGLineCapRound ;
    bpath.lineJoinStyle = kCGLineJoinRound ;
    [bpath strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    [bpath stroke];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableArray *pointsArray = [NSMutableArray array];

    curPath =  [[Path alloc] init];
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [pointsArray addObject:NSStringFromCGPoint(point)];

    curPath.color = pathColor ;
    curPath.width = [NSNumber  numberWithFloat:pathWidth] ;
    curPath.points = pointsArray;

}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [ [touches anyObject] locationInView:self];
    CGPoint prePoint = [[touches anyObject] previousLocationInView:self];

    //Path *path = [self.dataSource pathAtLast];
    [curPath.points addObject:NSStringFromCGPoint(point)];
    
    CGRect rect = CGRectMake( MIN(point.x, prePoint.x)-pathWidth, MIN(point.y, prePoint.y)-pathWidth , ABS(point.x - prePoint.x)+pathWidth*2, ABS(point.y - prePoint.y)+pathWidth*2);
    [self setNeedsDisplayInRect:rect];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGFloat timeInterval = 0.3;
    
    
    if(touch.tapCount == 0)
    {
         [self.dataSource addPath:curPath];
    }
    
    if(touch.tapCount>0){
        [self.dataSource removeLast];
    }
    
    if(touch.tapCount == 1)
    {
         //[self performSelector:@selector(tapOnce) withObject:nil afterDelay:timeInterval];
    }
    
    //NSLog(@"touchcount:%lu", (unsigned long)touch.tapCount);
    if(touch.tapCount == 2)
    {
        //[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapOnce) object:nil];
        [self performSelector:@selector(tapTwice) withObject:nil afterDelay:timeInterval];
    }

}

-(void)redo
{
    [self.dataSource backAbandonedPath];
    [self setNeedsDisplay];
    
}

-(void)tapTwice
{
    [self.dataSource addAbandonedPath];
    [self setNeedsDisplay];
}

-(void)tapOnce
{
    UIView *view  = [self.subviews lastObject];
    if( [view isKindOfClass:[UIToolbar class] ]){
        if(view.hidden){
            [view setHidden:NO];
        }else{
             [view setHidden:YES];
        }
    }
}


@end
