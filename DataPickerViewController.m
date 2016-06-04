//
//  DataPickerViewController.m
//  Drawing
//
//  Created by Coding on 6/4/16.
//  Copyright © 2016 Coding. All rights reserved.
//


#import "DataPickerViewController.h"


@interface DataPickerViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation DataPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissMe)];
    [self.view addGestureRecognizer:tap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClick:(UIButton *)sender {
    NSDate *date = self.datePicker.date;
    NSDateFormatter *formatter = [ [NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"YYYY/MM/dd HH:mm:SS" ;
    self.label.text = [formatter stringFromDate:date];
    
}

- (void)dismissMe {
    
    NSLog(@"Popover was dismissed with internal tap");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end


