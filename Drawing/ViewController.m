//
//  ViewController.m
//  Drawing
//
//  Created by Coding on 6/3/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "ViewController.h"
#import "PathBL.h"

@interface ViewController () <UIPopoverPresentationControllerDelegate>

- (IBAction)showPopover:(UIBarButtonItem *)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //[self.drawing viewSet];
    self.pathBL = [ [PathBL alloc] init];
    self.drawing.delegate = self;
    self.drawing.dataSource = self;
    self.pathsList = [self.pathBL findAll];
    self.abandonedPathList = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView:)
                                                 name:@"drawingViewNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pathWidthChange:(UISlider *)sender {
    self.drawing.pathWidth = sender.value;
}

- (IBAction)getARGB:(UIBarButtonItem *)sender {
    self.pathsList = [self.pathBL findByName:@"001"];
    self.abandonedPathList  = [NSMutableArray array];
    [self  reDraw:self.drawing];
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"FileTable"];
    
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

#pragma mark - popoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // called when a Popover is dismissed
    NSLog(@"Popover was dismissed with external tap. Have a nice day!");
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
    // return YES if the Popover should be dismissed
    // return NO if the Popover should not be dismissed
    return YES;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {
    
    // called when the Popover changes positon
}


#pragma mark - drawingViewDataSource
-(u_long) numberOfPath
{
 
    return self.pathsList.count;
}

-(Path *) pathAtIndex:(u_long)index
{
    return self.pathsList[index];
}

-(Path *) pathAtLast
{
     return [self.pathsList lastObject];
}
-(u_long) numberOfAbandonedPath
{
    return self.abandonedPathList.count;
}

-(Path *) AbandonedPathAtLast
{
    Path *path = [self.abandonedPathList lastObject];
    [self.abandonedPathList removeLastObject];
    
    return path;
}

-(void) addPath:(Path*)path
{
    self.pathsList = [self.pathBL createPath:path];
}

-(void) removeLast
{
    self.pathsList = [self.pathBL remove];
}

-(void) addAbandonedPath
{
    if(self.pathsList.count>0){
        Path *path = [self.pathsList lastObject];
        self.pathsList = [self.pathBL remove];
        [self.abandonedPathList addObject:path];
    }
}

-(void) backAbandonedPath
{
    if(self.abandonedPathList.count>0){
        Path *path = [self.abandonedPathList lastObject];
        [self.abandonedPathList removeLastObject];
        self.pathsList = [self.pathBL createPath:path];
    }
}

-(void) reDraw:(DrawingView *)view
{
    [view setNeedsDisplay];
}

-(void) reloadView:(NSNotification*)notification
{
    NSString *name = [notification object];
    self.pathsList = [self.pathBL findByName:name];
    self.abandonedPathList  = [NSMutableArray array];
    [self  reDraw:self.drawing];
}
@end
