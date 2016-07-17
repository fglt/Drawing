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
#import "MainViewController+GestureHandler.h"

@interface MainViewController () <UIPopoverPresentationControllerDelegate>

- (IBAction)showPopover:(UIBarButtonItem *)sender;

@end

@implementation MainViewController

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView:)
                                                 name:DrawingViewNotificationName
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    [self start];
    //[self addGesture];

}


-(void) start
{
    self.viewBounds = self.view.bounds;
    self.drawing = [[DrawingView alloc]initWithFrame:self.view.bounds];
    [self.view insertSubview:self.drawing atIndex:0];

    UIColor *color = [UIColor colorWithWhite:0.5 alpha:0.2];
    self.drawing.pathColor =color;
    float h, s, v;
    
    HSVFromUIColor(color, &h, &s, &v);
     NSLog(@"hsv: %f: %f: %f",h, s,v);
    
    self.drawingDataSource = [[ArrayDrawingDataSource alloc] init];
    self.drawing.dataSource = self.drawingDataSource;
    
    self.circleColorPicker.hue = h;
    self.squareColorPicker.point = CGPointMake(s, v);
    self.squareColorPicker.roatation = M_PI/4;
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notification selector
-(void) reloadView:(NSNotification*)notification
{
    NSString *name = [notification object];
    [self.drawing loadNewDrawing:name];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    NSLog(@"self bounds: %@", NSStringFromCGRect(self.view.frame));
    if (orientation == UIDeviceOrientationPortrait) {//正常方向
        self.drawing.transform = CGAffineTransformIdentity;
        
    } else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        
        self.drawing.transform = CGAffineTransformMakeRotation(M_PI);
        
    } else if (orientation == UIDeviceOrientationLandscapeLeft) {
        
        self.drawing.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
    } else if (orientation == UIDeviceOrientationLandscapeRight) {
        self.drawing.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    //    self.drawing.bounds = CGRectMake(self.viewBounds.size.width/2, self.viewBounds.size.height/2, self.viewBounds.size.width/2, self.viewBounds.size.height/2);
    //
    self.drawing.bounds = self.viewBounds;
    self.drawing.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
    NSLog(@"%ld", orientation);
    NSLog(@"drawing bounds: %@", NSStringFromCGRect(self.drawing.bounds));
    NSLog(@"drawing frame: %@", NSStringFromCGRect(self.drawing.frame));
}


#pragma mark - action of event


- (IBAction)onClickImage:(UIBarButtonItem *)sender {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate =self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        controller.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        controller.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:controller.sourceType];
    }
    //controller.modalPresentationStyle = UIModalPresentationPopover;

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

- (IBAction)slideRGB:(UISlider *)sender {
    
    float r = self.rSlider.value;
    float g = self.gSlider.value ;
    float b = self.bSlider.value ;
    float h, s,v;
    RGBToHSV(r, g, b, &h, &s, &v, YES);
    self.circleColorPicker.hue = h;
    self.squareColorPicker.hue = h;
    self.squareColorPicker.point = CGPointMake(s, v);
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1];
    self.drawing.pathColor = color;
}

- (IBAction)pathWidthChange:(UISlider *)sender {
    self.drawing.pathWidth = sender.value;
}

- (IBAction)getARGB:(UIBarButtonItem *)sender {
    if(self.paletteView.hidden)
    {
        self.paletteView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
                        self.paletteView.alpha = 1;
            
                   }];
           }else{
       
        self.paletteView.hidden = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.paletteView.alpha = 0;
            
        }];

    }

}


- (IBAction)onClickClear:(UIButton *)sender {
    //UIColor *color = [UIColor clearColor];
    UIColor *color = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    self.drawing.pathColor =color;
    float h, s, v;
    
    HSVFromUIColor(color, &h, &s, &v);
    NSLog(@"hsv: %f: %f: %f",h, s,v);
    
    self.circleColorPicker.hue = h;
    self.squareColorPicker.point = CGPointMake(s, v);
    self.squareColorPicker.roatation = M_PI/4;
}

- (IBAction)onClickSquareColorPicker:(SquareColorPicker *)sender {
    CGPoint point = sender.point;
    UIColor *color = [UIColor colorWithHue:sender.hue saturation:point.x brightness:point.y alpha:1];
    self.drawing.pathColor = color;
    float r, g,b;
    HSVtoRGB(sender.hue*360, point.x, point.y, &r, &g, &b);
    [self doSetText:r :g :b];
}

- (IBAction)onClickCircleColorPicker:(CircleColcorPicker *)sender {
    self.squareColorPicker.hue = sender.hue;
    CGPoint point = self.squareColorPicker.point;
    UIColor *color = [UIColor colorWithHue:sender.hue saturation:point.x brightness:point.y alpha:1];
    self.drawing.pathColor = color;
    float r, g,b;
    HSVtoRGB(sender.hue*360, point.x, point.y, &r, &g, &b);
    [self doSetText:r :g :b];

}


-(void)doSetText:(float)rf :(float)gf :(float)bf
{
    self.rSlider.value = rf;
    self.gSlider.value = gf;
    self.bSlider.value = bf;
    int r = (int) (rf* 255);
    int g = (int) (gf* 255);
    int b = (int) (bf* 255);
    
    self.rColor.text = [[NSNumber numberWithInt:r] stringValue];
    self.gColor.text = [[NSNumber numberWithInt:g] stringValue];
    self.bColor.text = [[NSNumber numberWithInt:b] stringValue];
    
    [self sliderBGset:r :g :b :r :self.rSlider :0];
    [self sliderBGset:r :g :b :g :self.gSlider :1];
    [self sliderBGset:r :g :b :b :self.bSlider :2];
    
}

-(void) sliderBGset:(int)r :(int)g :(int)b : (int) w  :(UISlider *)slider :(int) index
{

    UIImage * lImg =  [UIImage imageWithCGImage:createSlideImage(r,g,b, index,true,w,6)];
    UIImage * rImg =  [UIImage imageWithCGImage:createSlideImage(r,g,b, index,false,256-w,6)];
    
    [slider setMinimumTrackImage:lImg forState:UIControlStateNormal ];
    [slider setMaximumTrackImage:rImg forState:UIControlStateNormal ];
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
        }else{
            [self.drawing saveToFile:text];
            UIImage * image = [self captureWithView];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
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
    
    CGFloat maxH = MIN(480, ([self.drawingDataSource.pathBL allPathFiles].count + 1) * 50);
    controller.preferredContentSize = CGSizeMake(200, maxH);
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

#pragma mark - UIImagePickerControllerDelegate function
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIColor *bgColor = [UIColor colorWithPatternImage: image];
    [self.drawing setBackgroundColor:bgColor];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"sucess");
}

- (UIImage *)captureWithView
{
    // 1.开启上下文，第二个参数是是否不透明（opaque）NO为透明，这样可以防止占据额外空间（例如圆形图会出现方框），第三个为伸缩比例，0.0为不伸缩。
    UIGraphicsBeginImageContextWithOptions(self.drawing.frame.size, NO, 0.0);
    
    // 2.将控制器view的layer渲染到上下文
    [self.drawing.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 3.取出图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
