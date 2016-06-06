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

@property (strong , nonatomic) NSString *filePath;
@property (strong , nonatomic) NSMutableArray *pathFileArray;
@property (strong , nonatomic) NSString *allPaths;
@property (strong , nonatomic) NSMutableArray *array;


@end
