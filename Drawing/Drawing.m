//
//  Drawing.m
//  Drawing
//
//  Created by Coding on 6/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "Drawing.h"
IB_DESIGNABLE
@implementation Drawing
@synthesize pathColor;
@synthesize pathWidth;
//@synthesize radius;
@synthesize pathArray;
@synthesize pathAbandonedArray;


-(void) viewSet
{
    pathColor = [UIColor blueColor];
    pathWidth = 4;
    pathArray = [NSMutableArray array];
    pathAbandonedArray = [NSMutableArray array];
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
    //UIImage *image = [UIImage imageWithContentsOfFile:<#(nonnull NSString *)#>];
    if(pathArray.count>0)
    {
        for(NSMutableDictionary *dict in pathArray)
        {
            UIColor *color = [dict objectForKey:@"color"];
            CGFloat width = [[dict objectForKey:@"width"] floatValue];
            NSMutableArray *pointsArray = [dict objectForKey:@"points"];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [color set];
            path.lineWidth = width;
            
            [path moveToPoint: CGPointFromString(pointsArray[0]) ];
            
            for (int i=1; i<pointsArray.count; i++)
            {
                [path addLineToPoint:CGPointFromString(pointsArray[i])];
            }
            path.lineCapStyle = kCGLineCapRound ;
            path.lineJoinStyle = kCGLineJoinRound ;
            [path stroke];
            
        }
    }
  
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSMutableArray *pointsArray = [NSMutableArray array];
    NSMutableDictionary *pointsDict = [ NSMutableDictionary dictionary];
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [pointsArray addObject:NSStringFromCGPoint(point)];
    [pointsDict setObject:self.pathColor forKey:@"color"];
    [pointsDict setObject:[NSNumber numberWithFloat: self.pathWidth] forKey:@"width"];
    [pointsDict setObject:pointsArray forKey:@"points"];
    [pathArray addObject:pointsDict];
}

-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [ [touches anyObject] locationInView:self];
    CGPoint prePoint = [[touches anyObject] previousLocationInView:self];
    NSMutableDictionary *pointDict = [pathArray lastObject];
    NSMutableArray *pointsArrray = [pointDict objectForKey:@"points"];
    [pointsArrray addObject:NSStringFromCGPoint(point)];
    
    CGRect rect = CGRectMake( MIN(point.x, prePoint.x)-pathWidth, MIN(point.y, prePoint.y)-pathWidth , ABS(point.x - prePoint.x)+pathWidth*2, ABS(point.y - prePoint.y)+pathWidth*2);
    [self setNeedsDisplayInRect:rect];
}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGFloat timeInterval = 0.3;
    
    if(touch.tapCount>0){
        [pathArray removeLastObject];
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

-(void)undo
{
    if(pathArray.count>0){
        NSMutableDictionary *path = [pathArray lastObject];
        [pathAbandonedArray addObject:path];
        [pathArray removeLastObject];
        [self setNeedsDisplay];
    }
}

-(void)redo
{
    if(pathAbandonedArray.count>0){
        NSMutableDictionary *path = [pathAbandonedArray lastObject];
        [pathArray addObject:path];
        [pathAbandonedArray removeLastObject];
        [self setNeedsDisplay];
    }
}

-(void)tapTwice
{
    [self undo];
}
-(void)tapOnce
{
    //[self redo];
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
