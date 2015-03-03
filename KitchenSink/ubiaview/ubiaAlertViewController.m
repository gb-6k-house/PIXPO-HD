//
//  ubiaAlertViewController.m
//  P4PCamLive
//
//  Created by work on 13-4-17.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import "ubiaAlertViewController.h"
#import "ubiaDevice.h"
#import "ubiaAlert.h"
#import "ubiaFileNode.h"
#import "MMDeviceFileCell.h"
#import "Utilities.h"

#import "IOTCAPIs.h"
#import "AVAPIs.h"
#import "AVIOCTRLDEFs.h"
#include "time.h"

#import "ubiaAlertDetailViewController.h"

#import "MMExampleCenterTableViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMLogoView.h"
#import "MMCenterTableViewCell.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
#import "MMNavigationController.h"

#import "MMDeviceFileCmdCell.h"
#import "ToggleButton.h"
#import "MMDeviceActivityCell.h"
#import "ubiaDeviceManager.h"
#import "MMAppDelegate.h"
#import "MMTransferTableViewController.h"
#import "ubiaRecordTabBarViewController.h"
#import "KxMenu.h"
#import "ubiaQueryInfo.h"

@interface ubiaAlertViewController ()
{
    //NSMutableArray * gotAlerts;
    __weak ubiaDeviceManager * deviceManager;

    UIBarButtonItem *deviceBarItem;
    
    UIBarButtonItem *cloudBarItem;
    
    UIBarButtonItem *localBarItem;
    NSArray * toolbarItems;
    
    UIColor *myGray;
    UIColor *myBlue;
    BOOL showByFile;
    UISegmentedControl *segmentedController;

    ubiaFileNode * currentPathNode;
    NSMutableDictionary *fileDict;
}
@end

@implementation ubiaAlertViewController
@synthesize currentDevice;
@synthesize alertArrary;
@synthesize fileArrary;
@synthesize header_height;
@synthesize selectedIndex;

@synthesize fileQueryParam;
@synthesize alertQueryParam;

extern char * ioctrlRecvBuf;
extern char * ioctrlSendBuf;

- (void)awakeFromNib
{

    myGray = [UIColor lightGrayColor]; //[UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:0.600];
    myBlue = [UIColor colorWithRed:0.2314 green:0.7922 blue:0.99 alpha:1.0000];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        if(alertArrary == nil)
            alertArrary = [NSMutableArray arrayWithCapacity:MAX_ALERT_INARRARY];
        if(fileArrary == nil)
            fileArrary = [NSMutableArray arrayWithCapacity:MAX_ALERT_INARRARY];
        
        [self createLoadingView];
        showByFile = FALSE;
        fileDict = [[NSMutableDictionary alloc] initWithCapacity:MAX_ALERT_INARRARY];

    }

    return self;
}

-(void)customSegmentAction:(id)sender
{
    UISegmentedControl * segment = (UISegmentedControl *)sender;
    if (0 ==[segment selectedSegmentIndex]) {
        [self switchShowType:FALSE];
    }else{
        [self switchShowType:TRUE];

    }
}

- (IBAction)ClickItemExpandBtn:(ToggleButton *)sender {
    NSLog(@"Clicked ToggleButton tag[%d]",sender.tag);
    //if (sender.on){
    //    sender.imageView.image = [UIImage imageNamed:@"Item_Expand"];
    //}else{
    //    sender.imageView.image = [UIImage imageNamed:@"Item_Close"];
    //}
}

- (IBAction)SegmentAction:(UISegmentedControl *)sender {
    if (0 ==[sender selectedSegmentIndex]) {
        [self switchShowType:FALSE];
    }else{
        [self switchShowType:TRUE];
    }
}

- (UIView *)createLoadingView {
    
    UIView *loading = [[UIView alloc] init];
    loading.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    loading.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
    loading.tag = 1123002;
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity startAnimating];
    [activity sizeToFit];
    activity.center = CGPointMake(loading.center.x, loading.frame.size.height/3);
    activity.autoresizingMask = UIViewAutoresizingFlexibleWidth  | UIViewAutoresizingFlexibleHeight;
    
    [loading addSubview:activity];
    
    [self.tableView addSubview:loading];
    [self.tableView bringSubviewToFront:loading];
    return loading;
}

- (void)loading:(BOOL)visible {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
    UIView *loadingView = [self.tableView viewWithTag:1123002];
    if (loadingView==nil){
        loadingView = [self createLoadingView];
    }
    loadingView.frame = CGRectMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
    self.tableView.userInteractionEnabled = !visible;
    
    if (visible) {
        loadingView.hidden = NO;
        [self.view bringSubviewToFront:loadingView];
    }
    
    loadingView.alpha = visible ? 0 : 1;
    [UIView animateWithDuration:0.3
                     animations:^{
                         loadingView.alpha = visible ? 1 : 0;
                     }
                     completion: ^(BOOL  finished) {
                         if (!visible) {
                             loadingView.hidden = YES;
                             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                         }
                     }];
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightFileButton:(BOOL)visiable{

    if (visiable) {
        UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [addBtn setImage:[UIImage imageNamed:@"Control_Filter"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setFrame:CGRectMake(60, 20, 20, 20)];
        
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
        [addBtn setShowsTouchWhenHighlighted:YES];//设置发光
        [self.parentViewController.navigationItem setRightBarButtonItem:rightButton animated:YES];
    }else{
    
        [self.parentViewController.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}

-(void)onFilterSearch :(KxMenuItem *) item{
    NSLog(@"%s tag:%d", __FUNCTION__,item.tag);
    ubiaQueryInfo * queryParam = [[ubiaQueryInfo alloc] init];
    queryParam.EndDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    
    queryParam.pathName = currentPathNode.pathName;
    
    switch (item.tag) {
        case 0:
            //今天
            queryParam.startDate = [[NSDate alloc]initWithTimeIntervalSinceNow:-86400];
            break;
        case 1:
            //two day
            queryParam.startDate = [[NSDate alloc]initWithTimeIntervalSinceNow:-86400*2];
            break;
        case 2:
            //three day
            queryParam.startDate = [[NSDate alloc]initWithTimeIntervalSinceNow:-86400*3];
            break;
        case 3:
            //7 days
            queryParam.startDate = [[NSDate alloc]initWithTimeIntervalSinceNow:-86400*7];
            break;
        case 4:
            //all
            queryParam.startDate = [[NSDate alloc]initWithTimeIntervalSince1970:0];
        case 5:
            //custom
            break;
        default:
            break;
    }
    if (showByFile) {
        [deviceManager queryFiles:queryParam];
    }else
    {
        [deviceManager queryAlerts:queryParam];
    }
}

-(void) finishLoadData{
    //alertArrary = gotAlerts;
    [self loading:NO];
    [self.tableView reloadData];
}
-(void) loadView{
    [super loadView];
    self.navigationItem.title = NSLocalizedString(@"record_tile_txt", nil);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // NSLog(@"AlertViewController viewDidLoad");
    
    //NSLog(@"Alert View Deivce is %@",currentDevice.uid);
    
#if 0
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
#endif

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

    
    if(OSVersionIsAtLeastiOS7()){
        UIColor * navbarColor = [UIColor colorWithRed:247.0/255.0 green:249.0/255.0 blue:250.0/255.0 alpha:1.0];
        UIColor * tabbarColor = [UIColor colorWithRed:0.0/255.0 green:188.0/255.0 blue:241.0/255.0 alpha:1.0];
        
        [self.navigationController.navigationBar setBarTintColor:navbarColor];
        [self.tabBarController.tabBar setTintColor:tabbarColor];
        [self.tabBarController.tabBar setBackgroundColor:[UIColor clearColor]];
    }
    else {
        UIColor * barColor = [UIColor
                              colorWithRed:78.0/255.0
                              green:156.0/255.0
                              blue:206.0/255.0
                              alpha:1.0];
        [self.navigationController.navigationBar setTintColor:barColor];
    }
    
 
    [self loading:YES];
    
     header_height = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceManagerComplete:) name: @"ubiaDeviceManagerCompleteNotification" object:nil];
    
    //[NSThread detachNewThreadSelector:@selector(queryRemoteAlert) toTarget:self withObject:nil];
    
}
#if 0
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}
#endif

-(void) customTableViewHeader{

    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 39)];

#if 1
    NSArray *array = [NSArray arrayWithObjects:NSLocalizedString(@"record_byevent_txt", nil),NSLocalizedString(@"record_byfile_txt", nil), nil];
    segmentedController = [[UISegmentedControl alloc] initWithItems:array];
    segmentedController.segmentedControlStyle = UISegmentedControlSegmentCenter;
    [segmentedController addTarget:self action:@selector(customSegmentAction:) forControlEvents:UIControlEventValueChanged];
    segmentedController.selectedSegmentIndex = 0;
    segmentedController.frame = CGRectMake (80,5,160,29);
    [self.tableView.tableHeaderView addSubview:segmentedController];
#endif

}

-(void) setTabBarBackground{
    UITabBar* tabbar = self.tabBarController.tabBar;
    
    UIImageView *imageView = [[ UIImageView alloc] initWithImage :[UIImage imageNamed: @"tabbar_bg"]];
    
    imageView.frame = CGRectMake (0,0,tabbar.frame.size.width,tabbar.frame.size.height);
    
    NSLog ( @"the frame is %f---%f", tabbar.frame.size.width,tabbar.frame.size.height);
    
    imageView. contentMode = UIViewContentModeScaleToFill ;
    
    [tabbar insertSubview :imageView atIndex : 0 ];
    // 方法二   适用于 iOS5+
    //[tabbar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"]];
}

- (void)showMenu:(UIBarButtonItem *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:NSLocalizedString(@"record_search_1day_txt", nil)
                    image:nil
                    target:self
                    action:@selector(onFilterSearch:)
                    tag:0],

      [KxMenuItem menuItem:NSLocalizedString(@"record_search_2day_txt", nil)
                     image:nil
                    target:self
                    action:@selector(onFilterSearch:)
                    tag:1],
      
      [KxMenuItem menuItem:NSLocalizedString(@"record_search_3day_txt", nil)
                     image:nil
                    target:self
                    action:@selector(onFilterSearch:)
                    tag:2],

      [KxMenuItem menuItem:NSLocalizedString(@"record_search_7day_txt", nil)
                     image:nil
                    target:self
                    action:@selector(onFilterSearch:)
                    tag:3],
      
      [KxMenuItem menuItem:NSLocalizedString(@"record_search_all_txt", nil)
                     image:nil
                    target:self
                    action:@selector(onFilterSearch:)
                    tag:4],
#if 0
      [KxMenuItem menuItem:NSLocalizedString(@"record_search_other_txt", nil)
                     image:nil
                    target:self
                    action:@selector(onFilterSearch:)
                    tag:5],
#endif
      ];
    
    //UIView *targetView = (UIView *)[self.navigationItem.rightBarButtonItem performSelector:@selector(view)];
    
    UIView *targetView = (UIView *)[self.parentViewController.navigationItem.rightBarButtonItem performSelector:@selector(view)];
    
    CGRect rect = targetView.frame;
    rect.origin.y -= 30;
    
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self customTableViewHeader];
    [self setTabBarBackground];
    [self setupRightFileButton:TRUE];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceManagerComplete:) name: @"ubiaDeviceManagerCompleteNotification" object:nil];
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    deviceManager = appDelegate.deviceManager;
    //deviceManager.currentDevice = currentDevice;
    currentDevice = deviceManager.currentDevice;
    
    if (currentPathNode == nil) {
        currentPathNode = [[ubiaFileNode alloc] init];
        currentPathNode.pathName = @"/";
    }
    if (fileQueryParam == nil) {
        //default search  one week
        fileQueryParam = [[ubiaQueryInfo alloc] init];
        fileQueryParam.startDate = [[NSDate alloc]initWithTimeIntervalSinceNow:-86400*7];
        fileQueryParam.EndDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    }
    if (alertQueryParam == nil) {
        alertQueryParam = [[ubiaQueryInfo alloc] init];
        alertQueryParam.startDate = [[NSDate alloc]initWithTimeIntervalSinceNow:-86400*7];
        alertQueryParam.EndDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
    }
    
    if (showByFile) {
        if ([deviceManager.queriedFiles count] == 0) {

            [deviceManager queryFiles:fileQueryParam];
        }
        
        [segmentedController setSelectedSegmentIndex:1];
    }else{
        if ([deviceManager.queriedAlerts count] == 0) {
            [deviceManager queryAlerts:alertQueryParam];
        }
        [segmentedController setSelectedSegmentIndex:0];
    }
    NSLog(@"ubiaAlertView [viewWillAppear]====<");


}
-(void) viewWillDisappear:(BOOL)animated{
     NSLog(@"ubiaAlertView [viewWillDisappear]====<");

    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)deviceManagerComplete:(NSNotification *)note{

    NSString *command = [[note userInfo] objectForKey:@"DeviceCommand"];
    
    NSLog(@"deviceManagerComplete [DeviceCommand]====>");
    
    if([command isEqualToString:@"GET_ALERTS"]){
        alertArrary = deviceManager.queriedAlerts;

        NSLog(@"GET_ALERTS========[%d]", [alertArrary count]);
    }
    
    if([command isEqualToString:@"GET_FILELIST"]){
        MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
        deviceManager = appDelegate.deviceManager;
        
        fileArrary = deviceManager.queriedFiles;

        NSLog(@"GET_FILELIST========[%d]", [fileArrary count]);
    }
    
    [self loading:NO];
    [self.tableView reloadData];
    
    NSLog(@"deviceManagerComplete [DeviceCommand]====<");
    
}

#if 0
-(void)handleData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm:ss a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    //[self queryRemoteAlert];
    
    [self.refreshControl endRefreshing];
    
    [self.tableView reloadData];
}


-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing data..."];
        [alertArrary removeAllObjects];
        [self.tableView reloadData];
        [self performSelector:@selector(handleData) withObject:nil afterDelay:0];
    }
}
#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    int num = 0;
    if (showByFile) {
        num = [fileArrary count];
    }else{
        num = [alertArrary count];
    }
    return num;
}

#if 1
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    UILabel * customLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 2, 200, 18)];
    
    NSString * title;
    if (showByFile) {
        title = NSLocalizedString(@"record_file_count_txt", nil);
        title = [title stringByAppendingFormat:@"(%d)",[fileArrary count]];
    }else{
        title = NSLocalizedString(@"record_event_count_txt", nil);
        title = [title stringByAppendingFormat:@"(%d)",[alertArrary count]];
        //tilte = [NSString stringWithFormat:@"事件总数 (%d)",[alertArrary count]];
    }
    customLabel.text = title;
    //[UIFont fontWithName:@"Helvetica Neue" size:12];
    customLabel.font = [UIFont boldSystemFontOfSize:12];
    [customLabel setTextColor:[UIColor grayColor]];
    
    [view addSubview:customLabel];
    view.backgroundColor = [UIColor colorWithRed:0.9373 green:0.9373 blue:0.9373 alpha:1.0];
    return view;
}
#endif

#if  1

#if 0
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString * tilte;
    if (showByFile) {
        tilte = [NSString stringWithFormat:@"文件总数 (%d)",[fileArrary count]];
    }else{
        tilte = [NSString stringWithFormat:@"事件总数 (%d)",[alertArrary count]];
    }
    return tilte;
}

#endif

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    if (showByFile) {
        ubiaFileNode * fileNode = (ubiaFileNode *)[fileArrary objectAtIndex:[indexPath row]];
        if (fileNode.isExpandCell) {
            height = 55;
        }else{
            height = 50;
        }
    }else{
        height = 80;
    }
    return height;
}
#endif

- (void)configureFileCmdItemCell:(MMDeviceFileCmdCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.delegate = self;
    cell.tag = [indexPath row] - 1;
}
- (void)configureFileItemCell:(MMDeviceFileCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ubiaFileNode *file = fileArrary[[indexPath row]];
    cell.tag = [indexPath row];
    if(file != nil){
        cell.FileNameLabel.text = file.fileName;
        cell.FileSizeLabel.text = [NSString stringWithFormat:@"%uK",file.filesize/1000];
        cell.UpdateTimeLabel.text = [Utilities utctimeToString:file.updatetime];
        //cell.ExpandBtn.onImage = [UIImage imageNamed:@"Item_Close"];
        //cell.ExpandBtn.offImage = [UIImage imageNamed:@"Item_Expand"];
        cell.ExpandBtn.tag = cell.tag;
    }
    cell.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"alertCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    UITableViewCell *retcell;

    int row = [indexPath row];
    if (showByFile) {
        ubiaFileNode *file = fileArrary[row];
        if (0 == file.isExpandCell){
            MMDeviceFileCell * filecell = [tableView dequeueReusableCellWithIdentifier:@"mmDeviceFileCell" forIndexPath:indexPath];
            
            if(filecell == nil){
                filecell =[[MMDeviceFileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mmDeviceFileCell"];
            }
            [self configureFileItemCell:filecell atIndexPath:indexPath];
            
            retcell = filecell;
        }else{
            MMDeviceFileCmdCell * cmdcell = [tableView dequeueReusableCellWithIdentifier:@"mmDeviceFileCmdCell" forIndexPath:indexPath];
            
            if(cmdcell == nil){
                cmdcell =[[MMDeviceFileCmdCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mmDeviceFileCmdCell"];
            }
            [self configureFileCmdItemCell:cmdcell atIndexPath:indexPath];
            
            retcell =  cmdcell;
        }
        
    }else{
        MMDeviceActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mmDeviceAlertCell" forIndexPath:indexPath];
        
        //CGRect frame = cell.frame; //control is your UIControl
        
        //frame.size.height = 80.0; //suppose 10 is the desired height.
        
        //cell.frame = frame;
        //[cell setNeedsLayout];
        
        if(cell == nil){
            cell =[[MMDeviceActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mmDeviceActivityCell"];
        }
        
        ubiaAlert *alert = alertArrary[row];
        
        if(alert != nil){
            struct tm ts;
            ts.tm_year = alert.year - 1900;
            ts.tm_mon = alert.month - 1;
            ts.tm_mday = alert.day;
            ts.tm_hour = alert.hour;
            ts.tm_min = alert.minute;
            ts.tm_sec = alert.second;
            
            //int st = mktime(&ts);s
            int st = timegm(&ts);
            NSDate *stDate = [[NSDate alloc] initWithTimeIntervalSince1970:st];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
            
            [dateFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
            
            NSString *destDateString = [dateFormatter stringFromDate:stDate];
            
            //cell.detailTextLabel.text = [NSString stringWithFormat:@"%d %04d-%02d-%02d %02d:%02d:%02d",alert.index, alert.year,alert.month,alert.day,alert.hour,alert.minute,alert.second];
            //cell.detailTextLabel.text = destDateString;
            
            cell.dateLabel.text = destDateString;
            
        }
        retcell = cell;
    }
    return retcell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goAlertPlayBack"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        ubiaAlertDetailViewController *playback = (ubiaAlertDetailViewController *)[segue destinationViewController];
        
        playback.currentDevice = currentDevice;
        playback.alert = alertArrary[[indexPath row]];
        
        header_height = 0;
        
#if 1        
        //MMActivity * activity = [[MMActivity alloc] init];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        //NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:playback.alert.year];
        [components setMonth:playback.alert.month];
        [components setDay:playback.alert.day];
        
        [components setHour:playback.alert.hour];
        [components setMinute:playback.alert.minute];
        [components setSecond:playback.alert.second];
        
        NSDate *stDate = [calendar dateFromComponents:components];
  

        //printf("%02d-%02d %d:%d:%d\n",pEvent->stTime.month,pEvent->stTime.day, pEvent->stTime.hour,pEvent->stTime.minute, pEvent->stTime.second);
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
        
        //[dateFormatter setDateFormat:@"yy-MM-dd a hh:mm:ss"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
  
        NSString *dateString = [dateFormatter stringFromDate:stDate];
        playback.dateLabel.text = dateString;
        
        dateString = [dateFormatter stringFromDate:stDate];
        [dateFormatter setDateFormat:@"zzz a hh:mm:ss"];
        playback.timeLabel.text = dateString;
        
#endif
        
    }
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    selectedIndex = indexPath;

    if (showByFile) {
        int row = [indexPath row];
        ubiaFileNode *fileNode = (ubiaFileNode *) [fileArrary objectAtIndex:[indexPath row]];

        if (0 == fileNode.isExpandCell) {
            
            if (row < [fileArrary count] - 1) {
                //this is not the last item
                ubiaFileNode * nextNode = (ubiaFileNode *) [fileArrary objectAtIndex:row+1];
                if (nextNode.isExpandCell) {
                    //has expanded, remove expand
                    [self.tableView beginUpdates];
                    fileNode.hasExpanded = 0;
                    MMDeviceFileCell *cell = (MMDeviceFileCell *)[tableView cellForRowAtIndexPath:indexPath];

                    cell.ExpandBtn.imageView.image = [UIImage imageNamed:@"Item_Expand"];

                    NSIndexPath * expandIndex = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
                    
                    [fileArrary removeObjectAtIndex:row+1];
                    
                    [self.tableView deleteRowsAtIndexPaths:@[expandIndex]  withRowAnimation:UITableViewRowAnimationMiddle];
                    [self.tableView endUpdates];
                    return;
                }else{
                    ubiaFileNode * newExpandNode = [[ubiaFileNode alloc] init];
                    newExpandNode.isExpandCell = 1;
                    [fileArrary insertObject:newExpandNode atIndex:row+1];
                    NSIndexPath * expandIndex = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
                    
                    fileNode.hasExpanded = 1;
                    MMDeviceFileCell *cell = (MMDeviceFileCell *)[tableView cellForRowAtIndexPath:indexPath];
                    
                    cell.ExpandBtn.imageView.image = [UIImage imageNamed:@"Item_Close"];
                    
                    [self.tableView beginUpdates];
                    [self.tableView insertRowsAtIndexPaths:@[expandIndex] withRowAnimation:UITableViewRowAnimationMiddle];
                    [self.tableView endUpdates];
                    
                }
            }else{
                ubiaFileNode * newExpandNode = [[ubiaFileNode alloc] init];
                newExpandNode.isExpandCell = 1;
                [fileArrary insertObject:newExpandNode atIndex:row+1];
                NSIndexPath * expandIndex = [NSIndexPath indexPathForItem:(indexPath.row+1) inSection:indexPath.section];
                
                fileNode.hasExpanded = 1;
                MMDeviceFileCell *cell = (MMDeviceFileCell *)[tableView cellForRowAtIndexPath:indexPath];

                cell.ExpandBtn.imageView.image = [UIImage imageNamed:@"Item_Close"];
                
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[expandIndex] withRowAnimation:UITableViewRowAnimationMiddle];
                [self.tableView endUpdates];
            }
        }else{

            NSIndexPath * mainIndex = [NSIndexPath indexPathForItem:(indexPath.row-1) inSection:indexPath.section];
            
            MMDeviceFileCell *cell = (MMDeviceFileCell *)[tableView cellForRowAtIndexPath:mainIndex];
            
            cell.ExpandBtn.imageView.image = [UIImage imageNamed:@"Item_Expand"];
            
            [fileArrary removeObjectAtIndex:row];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]  withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableView endUpdates];
        }
#if 0
        //fileNode.isExpandCell = !fileNode.isExpandCell;
        NSIndexSet * indexSet = [[NSIndexSet alloc] initWithIndex:[indexPath section]];
        [tableView reloadSections:indexSet withRowAnimation:UITableViewAutomaticDimension];
        //[self.tabBarItem setBadgeValue:@"1"];
        ubiaRecordTabBarViewController * tabbarview =  (ubiaRecordTabBarViewController *)self.parentViewController;
        MMTransferTableViewController * transferview = (MMTransferTableViewController *)[tabbarview.viewControllers objectAtIndex:2];
        [transferview.tabBarItem setBadgeValue:@"1"];
#endif
        //[self.parentViewController.tabBarItem setBadgeValue:@"1"];
    }

#if 0
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:appDelegate.storyboardName bundle:nil];
    ubiaAlertDetailViewController * playback = [storyboard instantiateViewControllerWithIdentifier:@"UBIA_ALERT_DETAIL_VIEW"];
    
    playback.currentDevice = currentDevice;
    playback.alert = alertArrary[[indexPath row]];
    

    //MMActivity * activity = [[MMActivity alloc] init];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:playback.alert.year];
    [components setMonth:playback.alert.month];
    [components setDay:playback.alert.day];
    
    [components setHour:playback.alert.hour];
    [components setMinute:playback.alert.minute];
    [components setSecond:playback.alert.second];
    
    NSDate *stDate = [calendar dateFromComponents:components];
    
    
    //printf("%02d-%02d %d:%d:%d\n",pEvent->stTime.month,pEvent->stTime.day, pEvent->stTime.hour,pEvent->stTime.minute, pEvent->stTime.second);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    //[dateFormatter setDateFormat:@"yy-MM-dd a hh:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString *dateString = [dateFormatter stringFromDate:stDate];
    playback.dateLabel.text = dateString;
    
    dateString = [dateFormatter stringFromDate:stDate];
    [dateFormatter setDateFormat:@"zzz a hh:mm:ss"];
    playback.timeLabel.text = dateString;

    [self.navigationController presentViewController:playback animated:NO completion:nil];
#endif
}

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

#pragma mark - User Actions
#pragma mark -


- (void)setcustomToolbar
{
    
    UIToolbar * tbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 320, 44)];
    //创建UIToolbar对象
    tbar.tintColor = [UIColor greenColor];
#if 1
    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 3; i++) {
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
        [array addObject:item];
    }
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, 100, 60);
    btn.titleLabel.text = @"TEST";
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    //要用initWithCustonView:
    [array addObject:item];
    tbar.items = array;
    [self setToolbarItems:array];

#else
    //UIToolbar中加入的按钮都是UIBarButtonItem类型
    UIBarButtonItem * item0 = [[UIBarButtonItem alloc] initWithTitle:@"上一页" style:UIBarButtonItemStyleDone target:self action:nil];
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStyleDone target:self action:nil];
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc] initWithTitle:@"下一页" style:UIBarButtonItemStyleDone target:self action:nil];
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //spaceItem是一个弹簧按钮(UIBarButtonSystemItemFlexibleSpace)，
    tbar.items = [NSArray arrayWithObjects:item0, spaceItem, item1, spaceItem, item2, nil];
    //要达到相同的效果，也可以插入一个button，button的类型为Custom，enabled设置为NO。
    
    [self.view addSubview: tbar];
#endif
}

- (void)switchShowType:(BOOL)byFile {
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    deviceManager = appDelegate.deviceManager;
    
    if(byFile)
    {
        showByFile = byFile;
        
        if ([fileArrary count] == 0) {
            fileQueryParam.startDate = [[NSDate alloc]initWithTimeIntervalSinceNow:-86400*7];
            fileQueryParam.EndDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
            [self loading:TRUE];
            [deviceManager queryFiles:fileQueryParam];
        }
        
    }else{
        
        showByFile = byFile;
        if ([alertArrary count] == 0) {

            alertQueryParam.startDate = [[NSDate alloc]initWithTimeIntervalSinceNow:-86400*7];
            alertQueryParam.EndDate = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
        
            [deviceManager queryAlerts:alertQueryParam];
        }
    }
    //
    //[self.tableView reloadData];
    NSIndexSet * datasection =[[NSIndexSet alloc] initWithIndex:0];
    [self.tableView reloadSections:datasection withRowAnimation:TRUE];
}

-(void)cellBtnAction:(int)tag action: (int)action {

    ubiaFileNode * fileInfo = [fileArrary objectAtIndex:tag];
    NSLog(@"action from %d action %d [%@]",tag,action,fileInfo.fileName);
    switch (action) {
        case FILE_ACTION_TAG_EXPAND:
            break;
        case FILE_ACTION_TAG_DOWNLOAD:
        {
            fileInfo.pathName = currentDevice.uid;
            fileInfo.subDirType = UTIL_DEVICE_DOWNLOAD;
            
            fileInfo.status = FILE_STATUS_PENDING;

#if 1
            //fileNode.isExpandCell = !fileNode.isExpandCell;
            ubiaRecordTabBarViewController * tabbarview =  (ubiaRecordTabBarViewController *)self.parentViewController;
            MMTransferTableViewController * transferview = (MMTransferTableViewController *)[tabbarview.viewControllers objectAtIndex:1];
            
            //[transferview.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",[deviceManager.downloadingArray count]]];
            
            [transferview addDownloadItem:fileInfo];

#endif
        }
            break;
        case FILE_ACTION_TAG_SHARE:
            
            break;
        case FILE_ACTION_TAG_DELETE:
            
            break;
        case FILE_ACTION_TAG_MORE:
            
            break;
        default:
            break;
    }
   
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([sender isKindOfClass:[UISegmentedControl class]])
         return  FALSE;
    else {
        if(showByFile) return FALSE;
             else return TRUE;
    }
}

@end
