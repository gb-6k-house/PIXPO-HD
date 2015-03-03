//
//  MMRecordControllerTableViewController.m
//  P4PLive
//
//  Created by Maxwell on 14-7-1.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMRecordController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMLogoView.h"
#import "MMCenterTableViewCell.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
#import "MMNavigationController.h"

#import "MMAppDelegate.h"
#import "ubiaDeviceManager.h"
#import "ubiaRestClient.h"
#import "Utilities.h"
#import "ubiaCloudKuaiPan.h"

#import "ASIHTTPRequest.h"
#import "AudioButton.h"
#import <MediaPlayer/MediaPlayer.h>


@interface MMRecordController ()

@end

@implementation MMRecordController{
    __weak ubiaDeviceManager * deviceManager;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //视频播放结束通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    }
    return self;
}
-(void) loadView{
    [super loadView];
    
    self.navigationItem.title = NSLocalizedString(@"cloudrecord_txt", nil);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    deviceManager = appDelegate.deviceManager;
    
#if 1
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
#endif
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer * twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerDoubleTap:)];
    [twoFingerDoubleTap setNumberOfTapsRequired:2];
    [twoFingerDoubleTap setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:twoFingerDoubleTap];
    
    
    [self setupLeftMenuButton];
    //[self setupRightMenuButton];
    
    if(OSVersionIsAtLeastiOS7()){
        UIColor * barColor = [UIColor
                              colorWithRed:247.0/255.0
                              green:249.0/255.0
                              blue:250.0/255.0
                              alpha:1.0];
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        UIColor * barColor = [UIColor
                              colorWithRed:78.0/255.0
                              green:156.0/255.0
                              blue:206.0/255.0
                              alpha:1.0];
        [self.navigationController.navigationBar setTintColor:barColor];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton{
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}

-(void)contentSizeDidChange:(NSString *)size{
    [self.tableView reloadData];
}

-(void)refreshHandler
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm:ss a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    //[self reConnect:self];
    [self.refreshControl endRefreshing];
    
}

-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing data..."];
        //[deviceManager.restClient get_cloudinfo];
        [deviceManager.restClient.kuaipan get_file_info:@"/PMMCYHI3G7ZKEU7VDTMQ/picture/2014_05_12/20140512T092028.jpg"];
        [deviceManager.restClient.kuaipan download_file:@"/PMMCYHI3G7ZKEU7VDTMQ/picture/2014_05_12/20140512T092028.jpg"];
        [self.tableView reloadData];
        [self performSelector:@selector(refreshHandler) withObject:nil afterDelay:0];
    }
}

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cloudrecorderCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self videoPlay];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)videoPlay{
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Cache"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachePath])
    {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio.mp4"]]]) {
        MPMoviePlayerViewController *playerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio.mp4"]]]];
        [self presentMoviePlayerViewControllerAnimated:playerViewController];
        videoRequest = nil;
    }else{
#if 0
        ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]];
#else
        NSString *downloadurl = [deviceManager.restClient.kuaipan generate_download_url:@"/test.mp4"];
        ASIHTTPRequest *request=[[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:downloadurl]];
#endif
        AudioButton *musicBt = (AudioButton *)[self.view viewWithTag:1];
        [musicBt startSpin];
        //下载完存储目录
        [request setDownloadDestinationPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio.mp4"]]];
        //临时存储目录
        [request setTemporaryFileDownloadPath:[webPath stringByAppendingPathComponent:[NSString stringWithFormat:@"vedio.mp4"]]];
        [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
            [musicBt stopSpin];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setDouble:total forKey:@"file_length"];
            Recordull += size;//Recordull全局变量，记录已下载的文件的大小
            if (!isPlay&&Recordull > 400000) {
                isPlay = !isPlay;
                [self playVideo];
            }
        }];
        //断点续载
        [request setAllowResumeForFileDownloads:YES];
        [request startAsynchronous];
        videoRequest = request;
    }
}
- (void)playVideo{
    MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:@"http://127.0.0.1:12345/vedio.mp4"]];
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
}

- (void)videoFinished{
    if (videoRequest) {
        isPlay = !isPlay;
        [videoRequest clearDelegatesAndCancel];
        videoRequest = nil;
    }
}
@end
