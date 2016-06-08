//
//  PaletteViewController.h
//  Drawing
//
//  Created by Coding on 6/7/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaletteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIColor * lastColor;
@end
