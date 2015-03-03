//
//  MMTransferTableViewController.m
//  P4PCamLive
//
//  Created by Maxwell on 14/12/29.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMTransferTableViewController.h"
#import "MMAppDelegate.h"
#import "ubiaDeviceManager.h"
#import "ubiaFileNode.h"
#import "Utilities.h"
#import "MMTransferItemCell.h"
#import "MMFinishItemCell.h"
#import <MediaPlayer/MediaPlayer.h>


@interface MMTransferTableViewController ()
{
    __weak ubiaDeviceManager *deviceManager;
}

@end

@implementation MMTransferTableViewController
@synthesize finshedItemArrary,downloadingItemArrary,uploadingItemArrary;
@synthesize currentDevice;
@synthesize badgeNum;

-(BOOL)checkFileExist:(NSMutableArray *) arraryList withFile:(ubiaFileNode *) fileNode{
    ubiaFileNode * tmpFileNode;
    for (int index = 0; index < [arraryList count]; index++) {
        tmpFileNode = [arraryList objectAtIndex:index];
        if ([tmpFileNode.fileName isEqualToString:fileNode.fileName]) {
            return TRUE;
        }
    }
    return  FALSE;
}
- (void) loadIncompleteItem{

    NSString * pathName = [Utilities checkDocumentsPathwithCreate:currentDevice.uid withType:UTIL_DEVICE_DOWNLOAD];
    NSArray *incompleteItemArray = [NSMutableArray arrayWithArray:[Utilities getFilesByUID:currentDevice.uid attr:UTIL_DEVICE_DOWNLOAD]];
    NSString *fullFileName;
    
    for (int index = 0; index < [incompleteItemArray count]; index++) {
        
        ubiaFileNode * fileNode = [[ubiaFileNode alloc] init];
        fileNode.fileName = [incompleteItemArray objectAtIndex:index];
        fileNode.pathName = pathName;
        fileNode.subDirType = UTIL_DEVICE_DOWNLOAD;
    
        if (FALSE == [fileNode readTransferDatafromFile])
        {
            fullFileName = [pathName stringByAppendingPathComponent:fileNode.fileName];
            
            [Utilities deleteFile:[[NSURL alloc]initFileURLWithPath:fullFileName]];
            
        }else{
            if (FALSE == [self checkFileExist:deviceManager.downloadingArray withFile:fileNode]) {
                //[deviceManager.downloadingArray addObject: fileNode];
                fileNode.pathName = currentDevice.uid;
                [deviceManager startDownLoadFile:fileNode];
            }
        }
    }
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    downloadingItemArrary =  deviceManager.downloadingArray;
    uploadingItemArrary = deviceManager.uploadingArray;
    
    badgeNum = 0;
    if (0 == [downloadingItemArrary count]) {
        [self.tabBarItem setBadgeValue:nil];
    }else{
        [self addTabBarBadge:[downloadingItemArrary count]];
    }
    
    finshedItemArrary = [NSMutableArray arrayWithArray:[Utilities getFilesByUID:currentDevice.uid attr:UTIL_DEVICE_FILE]];
    
    [self setupRightFileButton:FALSE];
    
#if 0
    UIView * headerView = self.tableView.tableHeaderView;
    CGRect newFrame = headerView.frame;
    newFrame.size.height = newFrame.size.height + self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    
    headerView.frame = newFrame;
    [self.tableView setTableHeaderView:headerView];
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.tableView sizeToFit];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    deviceManager = appDelegate.deviceManager;
    currentDevice = deviceManager.currentDevice;
    [self loadIncompleteItem];
    //NSArray * filelist = [Utilities getFilesByUID:currentDevice.uid];
    NSLog(@"%s===========>",__FUNCTION__);
    for(int index = 0; index < [deviceManager.downloadingArray count]; index++){
        ubiaFileNode * fileNode = [deviceManager.downloadingArray objectAtIndex:index];
        NSLog(@"file[%@] status[%d]",fileNode.fileName, fileNode.status);
    }
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


- (void) addDownloadItem:(ubiaFileNode *)fileNode {
    
    badgeNum += 1;
    if (badgeNum) {
        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",badgeNum]];
    }
    
    if (nil == deviceManager) {
        MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
        deviceManager = appDelegate.deviceManager;
    }
    //[deviceManager.downloadingArray addObject:fileNode];
    
    [deviceManager startDownLoadFile:fileNode];

    downloadingItemArrary = deviceManager.downloadingArray;
    
    [self.tableView reloadData];
}
- (void) addTabBarBadge:(int) num{
    badgeNum += num;
    if (badgeNum) {
        [self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",badgeNum]];
    }else{
        [self.tabBarItem setBadgeValue:nil];
    }
    //[self.tableView reloadData];
}

- (void) addUploadItem:(ubiaFileNode *) fileNode
{

}


#if 1
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    UILabel * customLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 2, 200, 18)];
    

    NSString * title;
    if (0 == section) {
        title = NSLocalizedString(@"file_downloading_count_txt", nil);
        title = [title stringByAppendingFormat:@"(%d)",[downloadingItemArrary count]];
    }else{
        title = NSLocalizedString(@"file_downloaded_count_txt", nil);
        title = [title stringByAppendingFormat:@"(%d)",[finshedItemArrary count]];
    }
    customLabel.text = title;
    //[UIFont fontWithName:@"Helvetica Neue" size:12];
    customLabel.font = [UIFont boldSystemFontOfSize:12];
    [customLabel setTextColor:[UIColor grayColor]];
    
    [view addSubview:customLabel];
    view.backgroundColor = [UIColor colorWithRed:0.9373 green:0.9373 blue:0.9373 alpha:1.0];
    
    if (0 == section && 0 == [downloadingItemArrary count]) {
        return nil;
    }
    
    return view;
}
#endif


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    return 2;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (0 == section) {
        return [downloadingItemArrary count];

    }else{
        return [finshedItemArrary count];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == [indexPath section]) {

        MMTransferItemCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"mm_transfer_ing_cell" forIndexPath:indexPath];
        
        // Configure the cell...
        ubiaFileNode * fileNode = [downloadingItemArrary objectAtIndex:[indexPath row]];
        
        fileNode.delegate = cell;
        
        if (fileNode.status == FILE_STATUS_TRANSFERING) {
            cell.onTransfering = TRUE;
        }else{
            cell.onTransfering = FALSE;
        }
        cell.FileNameLabel.text  = fileNode.fileName;
        cell.TransferStatusLabel.text = [NSString stringWithFormat:@"%@/%@",[Utilities formatFileSize:(fileNode.pktsize*fileNode.gotpktnum)],[Utilities formatFileSize:fileNode.filesize]];
    
        cell.TransferSpeedLabel.text = [Utilities formatFileSize:fileNode.transferspeed];
        
        cell.progressView.backColor = [UIColor colorWithRed:236.0 / 255.0
                                                      green:236.0 / 255.0
                                                       blue:236.0 / 255.0
                                                      alpha:1.0];
        cell.progressView.progressColor = [UIColor colorWithRed:82.0 / 255.0
                                                          green:135.0 / 255.0
                                                           blue:237.0 / 255.0
                                                          alpha:1.0];
        cell.progressView.audioPath = [[NSBundle mainBundle] pathForResource:@"In my song"
                                                                      ofType:@"mp3"];
        
        cell.progressView.lineWidth = 5;
        
        cell.StartOrPauseButton.tag = [indexPath row];
        
        //set CircularProgressView delegate
        cell.progressView.delegate = self;
        
        cell.progressView.fileNode = fileNode;
        
        return cell;
        
    }else{
        MMFinishItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mm_transfer_finish_cell" forIndexPath:indexPath];
        
        // Configure the cell...
        cell.FileNameLabel.text = [finshedItemArrary objectAtIndex:[indexPath row]];
     
        NSString * uidDir = [Utilities checkDocumentsPathwithCreate:currentDevice.uid withType:UTIL_DEVICE_FILE];
        NSString * filename = [uidDir stringByAppendingPathComponent:[finshedItemArrary objectAtIndex:[indexPath row]]];
        
        long size = [Utilities getFileAttributes:filename];
        
        cell.FileSizeLabel.text = [Utilities formatFileSize:size];
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == [indexPath section]) {
        NSString * uidDir = [Utilities checkDocumentsPathwithCreate:currentDevice.uid withType:UTIL_DEVICE_FILE];
        NSString * filename = [uidDir stringByAppendingPathComponent:[finshedItemArrary objectAtIndex:[indexPath row]]];
        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:filename]];
        [self presentMoviePlayerViewControllerAnimated:playerViewController];
    }

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
        if (0 == [indexPath section]) {
            //delete transfering item
            ubiaFileNode * fileNode = [downloadingItemArrary objectAtIndex:[indexPath row]];
            MMTransferItemCell * cell = (MMTransferItemCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.onTransfering = FALSE;
            
            [deviceManager stopDownLoadFile:fileNode];
        
            NSString * fullname = [Utilities checkDocumentsPathwithCreate:fileNode.pathName withType:fileNode.subDirType];
            
            fullname = [fullname stringByAppendingPathComponent:fileNode.fileName];
            
            //[fileNode.pathName stringByAppendingPathComponent:fileNode.fileName];
            
            [Utilities deleteFile:[[NSURL alloc]initFileURLWithPath:fullname]];
            
            //[downloadingItemArrary removeObjectAtIndex:[indexPath row]];
            [self.tableView reloadData];
            
        }else{
            //delete finished item
            NSString * uidDir = [Utilities checkDocumentsPathwithCreate:currentDevice.uid withType:UTIL_DEVICE_FILE];
            NSString * filename = [uidDir stringByAppendingPathComponent:[finshedItemArrary objectAtIndex:[indexPath row]]];
            
            [Utilities deleteFile:[[NSURL alloc]initFileURLWithPath:filename]];
            [finshedItemArrary removeObjectAtIndex:[indexPath row]];
            [self.tableView reloadData];
        }

        
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


#pragma mark Circular Progress View Delegate method

- (void)updateProgressViewWithFileNode:(ubiaFileNode *) fileInfo
{
    NSLog(@"+++++ fileNode[%@][%d:%d]",fileInfo.fileName,fileInfo.gotpktnum,fileInfo.pktnum);
    if (fileInfo.gotpktnum == fileInfo.pktnum) {
        //finish download
        [self addTabBarBadge: -1];
        
        int row = [downloadingItemArrary indexOfObject:fileInfo];
        [deviceManager.downloadingArray removeObject:fileInfo];
        downloadingItemArrary  = deviceManager.downloadingArray;
        
        NSIndexPath * index = [NSIndexPath indexPathForRow:row inSection:0];
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
      
        if (NO == [finshedItemArrary containsObject:fileInfo.fileName]) {
            [finshedItemArrary addObject:fileInfo.fileName];
            NSIndexPath * insertIndex = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[insertIndex] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }

        //MMFinishItemCell * cell = (MMFinishItemCell *)[self tableView:self.tableView cellForRowAtIndexPath:insertIndex];
        //cell.FileNameLabel.text = fileInfo.fileName;

        //finshedItemArrary = [NSMutableArray arrayWithArray:[Utilities getFilesByUID:currentDevice.uid attr:UTIL_DEVICE_FILE]];
        [self.tableView reloadData];
    }
}

- (void) updateProgressViewWithPlayer:(AVAudioPlayer *)player {
    //update timeLabel
    //self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",[self formatTime:(int)player.currentTime],[self formatTime:(int)self.circularProgressView.duration]];
}

- (void) playerDidFinishPlaying
{

}

@end
