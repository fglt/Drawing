//
//  ViewController.h
//  Drawing
//
//  Created by Coding on 6/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drawing.h"
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet Drawing *drawing;
@property (nonatomic, strong) UIPopoverController *popController;

- (IBAction)pathWidthChange:(UISlider *)sender;

- (IBAction)getARGB:(UIBarButtonItem *)sender;
@end

