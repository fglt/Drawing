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
    self.pathbl = [ [PathBL alloc] init];
    self.drawing.delegate = self;
    self.drawing.dataSource = self;
    self.pathsList = [self.pathbl findAll];
    self.abandonedPathList = [NSMutableArray array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pathWidthChange:(UISlider *)sender {
    self.drawing.pathWidth = sender.value;
}

- (IBAction)getARGB:(UIBarButtonItem *)sender {

}

- (IBAction)onClickSave:(UIBarButtonItem *)sender {
     //[self.pathbl save:self.pathsList];
}

- (IBAction)showPopover:(UIBarButtonItem *)sender {
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"Date"];
    
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
    self.pathsList = [self.pathbl createPath:path];
}

-(void) removeLast
{
    self.pathsList = [self.pathbl remove];
}

-(void) addAbandonedPath
{
    if(self.pathsList.count>0){
        Path *path = [self.pathsList lastObject];
        self.pathsList = [self.pathbl remove];
        [self.abandonedPathList addObject:path];
    }
}


-(void) backAbandonedPath
{
    if(self.abandonedPathList.count>0){
        Path *path = [self.abandonedPathList lastObject];
        [self.abandonedPathList removeLastObject];
        self.pathsList = [self.pathbl createPath:path];
    }
}
@end
