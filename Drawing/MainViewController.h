//
//  ViewController.h
//  Drawing
//
//  Created by Coding on 6/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingView.h"
#import "PathBL.h"
#import "Path.h"
#import "DrawingViewController.h"
#import "BarColorPicker.h"
#import "SquareColorPicker.h"

@interface MainViewController : DrawingViewController

@property (weak, nonatomic) IBOutlet SquareColorPicker *squareColorPicker;
@property (weak, nonatomic) IBOutlet UIStackView *palette;

@property (weak, nonatomic) IBOutlet BarColorPicker *barColorPicker;
@property (weak, nonatomic) IBOutlet UISlider *rSlider;
@property (weak, nonatomic) IBOutlet UISlider *gSlider;
@property (weak, nonatomic) IBOutlet UISlider *bSlider;
@property (weak, nonatomic) IBOutlet UILabel *rColor;
@property (weak, nonatomic) IBOutlet UILabel *gColor;
@property (weak, nonatomic) IBOutlet UILabel *bColor;
//- (IBAction)slideR:(UISlider *)sender;
//- (IBAction)slideG:(UISlider *)sender;
//- (IBAction)slideB:(UISlider *)sender;

- (IBAction)slideRGB:(UISlider *)sender;

- (IBAction)pathWidthChange:(UISlider *)sender;

- (IBAction)getARGB:(UIBarButtonItem *)sender;
- (IBAction)onClickSquareColorPicker:(SquareColorPicker *)sender;

- (IBAction)onClickBarColorPicker:(BarColorPicker *)sender;

@end

