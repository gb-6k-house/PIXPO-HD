//
//  MMLocalRecordTableViewController.m
//  P4PCamLive
//
//  Created by Maxwell on 14/12/23.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMLocalRecordTableViewController.h"
#import "ubiaDeviceManager.h"
#import "Utilities.h"
#import "MMAppDelegate.h"

#import <MediaPlayer/MediaPlayer.h>

@interface MMLocalRecordTableViewController (){
  __weak ubiaDeviceManager * deviceManager;
}

@end

@implementation MMLocalRecordTableViewController
@synthesize itemArrary,currentDevice;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    deviceManager = appDelegate.deviceManager;
    currentDevice = deviceManager.currentDevice;
    NSArray * filelist = [Utilities getFilesByUID:currentDevice.uid attr:UTIL_LOCAL_FILE];
    int index = 0;
    NSRange range;
    itemArrary = [[NSMutableArray alloc] initWithCapacity:[filelist count]];
    
    for(index = 0; index< [filelist count];index++){
        range = [[filelist objectAtIndex:index] rangeOfString:@".png"];
                 
        if(range.length > 0)
        {
            ;
        }else{
        
            [itemArrary addObject:[filelist objectAtIndex:index]];
        
        }
        
        if (strstr([[filelist objectAtIndex:index] UTF8String], ".png")) {
            ;
        }else{
            ;
        }
    }
    
    //itemArrary = [NSMutableArray arrayWithArray:[Utilities getFilesByUID:currentDevice.uid]];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupRightFileButton:FALSE];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupRightFileButton:(BOOL)visiable{
    
    if (visiable) {
        UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [addBtn setImage:[UIImage imageNamed:@"Control_Filter"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(onFilterSearch) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setFrame:CGRectMake(60, 20, 20, 20)];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
        [addBtn setShowsTouchWhenHighlighted:YES];//设置发光
        [self.parentViewController.navigationItem setRightBarButtonItem:rightButton animated:YES];
    }else{
        
        [self.parentViewController.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

#if 0
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 180)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height ;

    return height;
    //return 64;
}
#endif
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [itemArrary count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mmLocalFileCell" forIndexPath:indexPath];

    // Configure the cell...
    cell.textLabel.text = [itemArrary objectAtIndex:[indexPath row]];
    
    NSString * uidDir = [Utilities checkDocumentsPathwithCreate:currentDevice.uid withType:UTIL_LOCAL_FILE];
    
    NSString * filename = [uidDir stringByAppendingPathComponent:[itemArrary objectAtIndex:[indexPath row]]];
    
    long size = [Utilities getFileAttributes:filename];
    cell.detailTextLabel.text = [Utilities formatFileSize:size];
    
    //cell.textLabel.textColor = [Utilities textColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * uidDir = [Utilities checkDocumentsPathwithCreate:currentDevice.uid withType:UTIL_LOCAL_FILE];
    NSString * filename = [uidDir stringByAppendingPathComponent:[itemArrary objectAtIndex:[indexPath row]]];
    
    MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:filename]];
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString * uidDir = [Utilities checkDocumentsPathwithCreate:currentDevice.uid withType:UTIL_LOCAL_FILE];
        
        NSString * filename = [uidDir stringByAppendingPathComponent:[itemArrary objectAtIndex:[indexPath row]]];
        
        [Utilities deleteFile:[[NSURL alloc]initFileURLWithPath:filename]];
        [itemArrary removeObjectAtIndex:[indexPath row]];
        [self.tableView reloadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)switchShowType:(BOOL)byFile
{
    if (byFile)
    {

        
    }else{


    }
}
@end
