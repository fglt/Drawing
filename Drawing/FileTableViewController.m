//
//  FileTableViewController.m
//  Drawing
//
//  Created by Coding on 6/6/16.
//  Copyright © 2016 Coding. All rights reserved.
//

#import "FileTableViewController.h"
#import "PathBL.h"
#import "constants.h"

@interface FileTableViewController ()
@property (strong, nonatomic) NSMutableArray *fileList;
@property (strong, nonatomic) PathBL  *pathbl;
@end

@implementation FileTableViewController

@synthesize fileList;
@synthesize pathbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    pathbl = [[PathBL alloc] init];
    fileList = [pathbl allPathFiles];
    UIView *view = [UIView new];
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor blueColor];
    [self.tableView setTableFooterView:view];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dismissMe {
//    
//    NSLog(@"Popover was dismissed with internal tap");
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return fileList.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileCellIdentifier" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if(row == 0)
    {
        cell.textLabel.text = NewDrawingStr;
    }else{
        cell.textLabel.text = fileList[row-1];
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name;

    if(indexPath.row == 0)
        name = NewDrawingStr;
    else
        name = fileList[indexPath.row-1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DrawingViewNotificationName object:name userInfo:nil];
     [self dismissViewControllerAnimated:YES completion:nil];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete ) {
        // Delete the row from the data source
        if(indexPath.row>0){
            self.fileList = [pathbl removeDrawing:fileList[indexPath.row-1]];
        [   tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [tableView reloadData];
        }
    }
}


@end
