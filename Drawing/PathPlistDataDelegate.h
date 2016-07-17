//
//  PathPlistDataDelegate.h
//  Drawing
//
//  Created by Coding on 6/4/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PathDataDelegate.h"

@interface PathPlistDataDelegate : NSObject<PathDataDelegate>

@property (strong , nonatomic) NSString *tempDrawing;
@property (strong , nonatomic) NSMutableArray *drawingFileArray;
@property (strong , nonatomic) NSString *drawingsFileName;
@property (strong , nonatomic) NSMutableArray *pathArray;


@end
