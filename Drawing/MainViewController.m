//
//  ViewController.m
//  Drawing
//
//  Created by Coding on 6/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "MainViewController.h"
#import "constants.h"
#import "InfHSBSupport.h"

@interface MainViewController () <UIPopoverPresentationControllerDelegate>

- (IBAction)showPopover:(UIBarButtonItem *)sender;

@end

@implementation MainViewController
//@synthesize squareImageView;
//@synthesize barImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView:)
                                                 name:DrawingViewNotificationName
                                               object:nil];
    [self start];
}

-(void) start
{
    UIColor *color = [UIColor grayColor];
    self.drawing.pathColor =color;
    float h, s, v;
    
    HSVFromUIColor(color, &h, &s, &v);
    
    self.barColorPicker.value = h;
    self.squareColorPicker.point = CGPointMake(s, v);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) reloadView:(NSNotification*)notification
{
    NSString *name = [notification object];
    if([name isEqualToString:NewDrawingStr]){
        self.pathsList = [self.pathBL newDrawing];
    }else{
        self.pathsList = [self.pathBL findByName:name];
    }
    self.abandonedPathList  = [NSMutableArray array];
    [self  reDraw];
}

//
//- (IBAction)slideR:(UISlider *)sender {
//    
//    float r = self.rSlider.value;
//    float g = self.gSlider.value ;
//    float b = self.bSlider.value ;
//    float h, s,v;
//    RGBToHSV(r, g, b, &h, &s, &v, YES);
//    self.barColorPicker.value = h;
//    self.squareColorPicker.hue = h;
//    self.squareColorPicker.point = CGPointMake(s, v);
//}
//
//- (IBAction)slideG:(UISlider *)sender {
//    
//    float r = self.rSlider.value;
//    float g = self.gSlider.value ;
//    float b = self.bSlider.value ;
//    float h, s,v;
//    RGBToHSV(r, g, b, &h, &s, &v, YES);
//    self.barColorPicker.value = h;
//    self.squareColorPicker.hue = h;
//    self.squareColorPicker.point = CGPointMake(s, v);
//}
//
//- (IBAction)slideB:(UISlider *)sender {
//    
//    float r = self.rSlider.value;
//    float g = self.gSlider.value ;
//    float b = self.bSlider.value ;
//    float h, s,v;
//    RGBToHSV(r, g, b, &h, &s, &v, YES);
//    self.barColorPicker.value = h;
//    self.squareColorPicker.hue = h;
//    self.squareColorPicker.point = CGPointMake(s, v);
//}

- (IBAction)slideRGB:(UISlider *)sender {
    
    float r = self.rSlider.value;
    float g = self.gSlider.value ;
    float b = self.bSlider.value ;
    float h, s,v;
    RGBToHSV(r, g, b, &h, &s, &v, YES);
    self.barColorPicker.value = h;
    self.squareColorPicker.hue = h;
    self.squareColorPicker.point = CGPointMake(s, v);
}

- (IBAction)pathWidthChange:(UISlider *)sender {
    self.drawing.pathWidth = sender.value;
}

- (IBAction)getARGB:(UIBarButtonItem *)sender {
    if(self.palette.hidden)
    {
        self.palette.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
                        self.palette.alpha = 1;
            
                   }];
           }else{
       
        self.palette.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.palette.alpha = 0;
            
        }];

    }

}

- (IBAction)onClickSquareColorPicker:(SquareColorPicker *)sender {
    
    CGPoint point = sender.point;
    UIColor *color = [UIColor colorWithHue:sender.hue saturation:point.x brightness:point.y alpha:1];
    self.drawing.pathColor = color;
    float r, g,b;
    HSVtoRGB(sender.hue*360, point.x, point.y, &r, &g, &b);
    [self doSetText:r :g :b];
}

- (IBAction)onClickBarColorPicker:(BarColorPicker *)sender {
    CGPoint point = self.squareColorPicker.point;
    self.squareColorPicker.hue =   sender.value;
    UIColor *color = [UIColor colorWithHue:sender.value saturation:point.x brightness:point.y alpha:1];
    self.drawing.pathColor = color;
    float r, g,b;
    HSVtoRGB(sender.value*360, point.x, point.y, &r, &g, &b);
    [self doSetText:r :g :b];
}

-(void)doSetText:(float)r :(float)g :(float)b
{
    self.rSlider.value = r;
    self.gSlider.value = g;
    self.bSlider.value = b;
    
    self.rColor.text = [[NSNumber numberWithInt:(int)(r*255)] stringValue];
    self.gColor.text = [[NSNumber numberWithInt:(int)(g*255)] stringValue];
    self.bColor.text = [[NSNumber numberWithInt:(int)(b*255)] stringValue];
}

- (IBAction)onClickSave:(UIBarButtonItem *)sender {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:@"保存" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * textField){
        textField.placeholder =@"名称";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *name = alertController.textFields.firstObject;
        NSString * text = name.text;
        if([text isEqualToString:@""])
        {
            [alertController setMessage:@"名称不合法, 重新输入！"];
            [self presentViewController:alertController animated:true completion:nil];
        }else
            [self.pathBL saveToFile:text];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:true completion:nil];
};

- (IBAction)showPopover:(UIBarButtonItem *)sender {
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MainStoryBoardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:FileTableNavigationID];
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = sender;
    popController.delegate = self;
}

static void HSVFromUIColor(UIColor* color, float* h, float* s, float* v)
{
    CGColorRef colorRef = [color CGColor];
    
    const CGFloat* components = CGColorGetComponents(colorRef);
    size_t numComponents = CGColorGetNumberOfComponents(colorRef);
    
    CGFloat r, g, b;
    
    if (numComponents < 3) {
        r = g = b = components[0];
    }
    else {
        r = components[0];
        g = components[1];
        b = components[2];
    }
    
    RGBToHSV(r, g, b, h, s, v, YES);
    NSLog(@"%f",h);
}
@end
