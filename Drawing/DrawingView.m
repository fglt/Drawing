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




-(void) viewSet
{
    pathColor = [UIColor blueColor];
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

- (void)drawRect:(CGRect)rect {
    
    u_long count = [self.dataSource numberOfPath];
    
    for(int i=0; i<count; i++){
        Path *path = [self.dataSource pathAtIndex:i];
        NSMutableArray *pointsArray = path.points;
        UIBezierPath *bpath = [UIBezierPath bezierPath];
        [path.color set];
        bpath.lineWidth = [path.width floatValue];;
        
        [bpath moveToPoint: CGPointFromString(pointsArray[0]) ];
        
        for (int i=1; i<pointsArray.count; i++)
        {
            [bpath addLineToPoint:CGPointFromString(pointsArray[i])];
        }
        bpath.lineCapStyle = kCGLineCapRound ;
        bpath.lineJoinStyle = kCGLineJoinRound ;
        [bpath stroke];
            
    }
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableArray *pointsArray = [NSMutableArray array];

    Path *path =  [[Path alloc] init];
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [pointsArray addObject:NSStringFromCGPoint(point)];

    path.color = pathColor ;
    path.width = [NSNumber  numberWithFloat:pathWidth] ;
    path.points = pointsArray;
    
    [self.dataSource addPath:path];

}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [ [touches anyObject] locationInView:self];
    CGPoint prePoint = [[touches anyObject] previousLocationInView:self];

    Path *path = [self.dataSource pathAtLast];
    [path.points addObject:NSStringFromCGPoint(point)];
    
    CGRect rect = CGRectMake( MIN(point.x, prePoint.x)-pathWidth, MIN(point.y, prePoint.y)-pathWidth , ABS(point.x - prePoint.x)+pathWidth*2, ABS(point.y - prePoint.y)+pathWidth*2);
    [self setNeedsDisplayInRect:rect];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGFloat timeInterval = 0.3;
    
    if(touch.tapCount>0){
        [self.dataSource removeLast];
    }
    
    if(touch.tapCount == 1)
    {
         [self performSelector:@selector(tapOnce) withObject:nil afterDelay:timeInterval];
    }
    
    NSLog(@"touchcount:%lu", (unsigned long)touch.tapCount);
    if(touch.tapCount == 2)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapOnce) object:nil];
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
