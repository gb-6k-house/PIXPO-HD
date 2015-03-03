// Copyright (c) 2013 UBIA (http://ubia.cn/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "MMExampleSideDrawerViewController.h"
#import "MMExampleCenterTableViewController.h"
#import "MMSideDrawerTableViewCell.h"
#import "MMSideDrawerSectionHeaderView.h"
#import "MMLogoView.h"
#import "MMNavigationController.h"

#import "ubiaAlertViewController.h"

#import "ubiaPlatform.h"
#import "VideoFrameExtractor.h"
#import "ubiaDeviceList.h"
#import "MMAppDelegate.h"
#import "ubiaDeviceManager.h"
#import "ubiaRestClient.h"
#import "TDBadgedCell.h"

//#define WITH_CLOUD_FUNCTION

#ifdef WITH_CLOUD_FUNCTION
enum {
    SIDE_NAV_INDEX_MYCAMERAS,
    SIDE_NAV_INDEX_PUBLICCAMERAS,
    SIDE_NAV_INDEX_SNAPSHOT,
    SIDE_NAV_INDEX_RECORD,
    SIDE_NAV_INDEX_ACTIVITY,
    SIDE_NAV_INDEX_BUDDY,
    SIDE_NAV_INDEX_SETTING,
    SIDE_NAV_INDEX_OTHER
};
#else
enum {
    SIDE_NAV_INDEX_MYCAMERAS,
    SIDE_NAV_INDEX_PUBLICCAMERAS,
    SIDE_NAV_INDEX_SNAPSHOT,
    SIDE_NAV_INDEX_ACTIVITY,
    SIDE_NAV_INDEX_SETTING,
    SIDE_NAV_INDEX_OTHER
};
#endif

@implementation MMExampleSideDrawerViewController{
    UINavigationController *nav[8];
    int currentIndex;
    BOOL hasCenterNav;
}

#define WITH_GSETTING 0

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(OSVersionIsAtLeastiOS7()){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    else {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    UIColor * tableViewBackgroundColor;
    if(OSVersionIsAtLeastiOS7()){
        tableViewBackgroundColor = [UIColor colorWithRed:110.0/255.0
                                                   green:113.0/255.0
                                                    blue:115.0/255.0
                                                   alpha:1.0];
    }
    else {
        tableViewBackgroundColor = [UIColor colorWithRed:77.0/255.0
                                                   green:79.0/255.0
                                                    blue:80.0/255.0
                                                   alpha:1.0];
    }
    [self.tableView setBackgroundColor:tableViewBackgroundColor];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0
                                                  green:69.0/255.0
                                                   blue:71.0/255.0
                                                  alpha:1.0]];
    
    UIColor * barColor = [UIColor colorWithRed:161.0/255.0
                                         green:164.0/255.0
                                          blue:166.0/255.0
                                         alpha:1.0];
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]){
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        [self.navigationController.navigationBar setTintColor:barColor];
    }


    NSDictionary *navBarTitleDict;
    UIColor * titleColor = [UIColor colorWithRed:55.0/255.0
                                           green:70.0/255.0
                                            blue:77.0/255.0
                                           alpha:1.0];
    navBarTitleDict = @{NSForegroundColorAttributeName:titleColor};
    [self.navigationController.navigationBar setTitleTextAttributes:navBarTitleDict];
    
    self.drawerWidths = @[@(160),@(200),@(240),@(280),@(320)];
    
    CGSize logoSize = CGSizeMake(58, 62);
    MMLogoView * logo = [[MMLogoView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.tableView.bounds)-logoSize.width/2.0,
         -logoSize.height-logoSize.height/4.0,
         logoSize.width,logoSize.height)];
    [logo setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
    [self.tableView addSubview:logo];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self.mm_drawerController
     setMaximumLeftDrawerWidth:200
     animated:YES
     completion:^(BOOL finished) {
     }];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfSections-1)] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)contentSizeDidChange:(NSString *)size{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
        case 1:
#ifdef WITH_CLOUD_FUNCTION
            return 4;
#else
            return 2;
#endif
        case 2:
            return 1;
        case 3:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[MMSideDrawerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:NSLocalizedString(@"my_cameras_txt", nil)];
                    cell.imageView.image = [UIImage imageNamed:@"Menu_My_Camera"];
                    break;
                    
                case 1:
                    [cell.textLabel setText:NSLocalizedString(@"featured_cameras_txt", nil)];
                    cell.imageView.image = [UIImage imageNamed:@"Menu_Public_Camera"];
                    break;
                default:
                    break;
            }
            //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
        case 1:
            //Implement in Subclass
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:NSLocalizedString(@"snapshot_txt", nil)];
                    cell.imageView.image = [UIImage imageNamed:@"Menu_My_Gallary"];
                    break;
#ifdef WITH_CLOUD_FUNCTION
                case 1:
                    [cell.textLabel setText:NSLocalizedString(@"cloudrecord_txt", nil)];
                    cell.imageView.image = [UIImage imageNamed:@"Menu_Cloud_Record"];
                    break;
                case 2:
                {
                    [cell.textLabel setText:NSLocalizedString(@"activity_txt", nil)];
                    cell.imageView.image = [UIImage imageNamed:@"Menu_Camera_Notification"];
                    //MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
                    //if(appDelegate.deviceManager.badgeNum)
                    //    [self addbadge:cell];
                }
                    break;

                case 3:
                {
                    [cell.textLabel setText:NSLocalizedString(@"buddy_txt", nil)];
                    cell.imageView.image = [UIImage imageNamed:@"Menu_My_friend"];
                    
                }
                    break;
#else
                case 1:
                {
                    [cell.textLabel setText:NSLocalizedString(@"activity_txt", nil)];
                    cell.imageView.image = [UIImage imageNamed:@"Menu_Camera_Notification"];
                    //MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
                    //if(appDelegate.deviceManager.badgeNum)
                    //    [self addbadge:cell];
                }
                    break;
#endif
                default:
                    break;
            }
            break;
        case 2:
            {
                cell.imageView.image = [UIImage imageNamed:@"Menu_More_Setting"];
                [cell.textLabel setText:NSLocalizedString(@"more_txt", nil)];
            }
            break;
#if 1
        case 3:
        {
            cell.imageView.image =[UIImage imageNamed:@"loading"];
            [cell.textLabel setText:@"新入口"];
            break;
            //[cell.textLabel setText:NSLocalizedString(@"logout_txt", nil)];
           // break;
            
            //[cell.textLabel setText:@"Record"];
            //if(self.mm_drawerController.showsShadow)
            //    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            //else
            //    [cell setAccessoryType:UITableViewCellAccessoryNone];
            //break;
        }
#endif
    }
    return cell;
}

- (void) addbadge:(UITableViewCell*) cell
{
    UIImageView * commentsViewBG;
    return;
    int totalCount =50;
    UILabel *commentsCount;
    if(totalCount < 10){
        commentsViewBG = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"counter1.png"]];
        commentsViewBG.frame = CGRectMake(
                                      commentsViewBG.frame.origin.x,
                                      commentsViewBG.frame.origin.y, 30, 20);
    
        commentsCount = [[UILabel alloc]initWithFrame:CGRectMake(10, -10, 40, 40)];
    }else if(totalCount < 100){
        commentsViewBG = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"counter2.png"]];
        commentsViewBG.frame = CGRectMake(
                                      commentsViewBG.frame.origin.x,
                                      commentsViewBG.frame.origin.y, 30, 20);
        commentsCount = [[UILabel alloc]initWithFrame:CGRectMake(5, -10, 40, 40)];
    }
    else if(totalCount < 1000)
    {
        commentsViewBG = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"counter3.png"]];
        
        commentsViewBG.frame = CGRectMake(
                                          commentsViewBG.frame.origin.x,
                                          commentsViewBG.frame.origin.y, 40, 20);
        commentsCount = [[UILabel alloc]initWithFrame:CGRectMake(5, -10, 40, 40)];
    }
    commentsCount.text = [NSString stringWithFormat:@"%ld",(long)totalCount];
    commentsCount.textColor = [UIColor whiteColor];
    commentsCount.backgroundColor = [UIColor clearColor];
    [commentsViewBG addSubview:commentsCount];

    cell.accessoryView = commentsViewBG;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return NSLocalizedString(@"lm_sect_title_device", nil);
        case 1:
            return NSLocalizedString(@"lm_sect_title_mgmt", nil);
        case 2:
            return NSLocalizedString(@"lm_sect_title_other", nil);
        default:
            return nil;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MMSideDrawerSectionHeaderView * headerView;
    if(OSVersionIsAtLeastiOS7()){
        headerView =  [[MMSideDrawerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 56.0)];
    }
    else {
        headerView =  [[MMSideDrawerSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 23.0)];
    }
    [headerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [headerView setTitle:[tableView.dataSource tableView:tableView titleForHeaderInSection:section]];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(OSVersionIsAtLeastiOS7()){
        if (section == 0) {
            return  56.0;
        }else{
            return 23.0;
        }
    }
    else {
        return 23.0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (hasCenterNav == NO) {
        //nav[0] = self.mm_drawerController.centerViewController;
        //nav[1] = nav[0];
        hasCenterNav = YES;
    }
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:appDelegate.storyboardName bundle:nil];
    
    switch (indexPath.section) {
        case 0:{
            //MMExampleCenterTableViewController * center = [[MMExampleCenterTableViewController alloc] init];
            
            //UINavigationController * nav = [[MMNavigationController alloc] initWithRootViewController:center];
            switch (indexPath.row) {
                case 0:
                    //Camera list
                    [appDelegate.deviceManager leavePublicDeviceView];
                    if(nav[SIDE_NAV_INDEX_MYCAMERAS] == nil)
                        nav[SIDE_NAV_INDEX_MYCAMERAS] = [storyboard instantiateViewControllerWithIdentifier:@"mainNavViewer"];
                    
                    currentIndex = SIDE_NAV_INDEX_MYCAMERAS;
                    break;
                case 1:
                    [appDelegate.deviceManager leaveMyDeviceView];
                    
                    if(nav[SIDE_NAV_INDEX_PUBLICCAMERAS] == nil)
                        nav[SIDE_NAV_INDEX_PUBLICCAMERAS] = [storyboard instantiateViewControllerWithIdentifier:@"publicNavViewer"];
                    
                    currentIndex = SIDE_NAV_INDEX_PUBLICCAMERAS;
                    //nav[indexPath.row].topViewController
                    
                     //NSLog(@"feature cameras");
                    break;
                default:
                    break;
            }
            break;
        }
            
        case 1:{
            //Implement in Subclass
            switch (indexPath.row) {
                case 0:
                    //Snapshot
                    if(nav[SIDE_NAV_INDEX_SNAPSHOT] == nil)
                        nav[SIDE_NAV_INDEX_SNAPSHOT] = [storyboard instantiateViewControllerWithIdentifier:@"snapNavViewer"];
                    
                    currentIndex = SIDE_NAV_INDEX_SNAPSHOT;
                    
                    // NSLog(@"Snapshot");
                    
                    break;
#ifdef WITH_CLOUD_FUNCTION
                case 1:
                    //video playback
                    if(nav[SIDE_NAV_INDEX_RECORD] == nil)
                        nav[SIDE_NAV_INDEX_RECORD] = [storyboard instantiateViewControllerWithIdentifier:@"recordNavViewer"];
                    
                    currentIndex = SIDE_NAV_INDEX_RECORD;
                    // NSLog(@"Records");
                    break;

                case 2:
                    //Activity
                    if(nav[SIDE_NAV_INDEX_ACTIVITY] == nil)
                        nav[SIDE_NAV_INDEX_ACTIVITY] = [storyboard instantiateViewControllerWithIdentifier:@"activityNavViewer"];
                    
                    currentIndex = SIDE_NAV_INDEX_ACTIVITY;
                    appDelegate.deviceManager.badgeNum = 0;
                    //[self.navigationController pushViewController: myController animated:YES];
                    //NSLog(@"Activity");
                    
                    break;
                    

                case 3:
                    if(nav[SIDE_NAV_INDEX_BUDDY] == nil){
                        nav[SIDE_NAV_INDEX_BUDDY] = [storyboard instantiateViewControllerWithIdentifier:@"buddyNavViewer"];
                        //QRootElement *root =    [[QRootElement alloc] initWithJSONFile:@"QDGeneralSetting"];// [[QRootElement alloc] init];
                        //root.title = @"General Settings";
                        //root.grouped = YES;
                        
                        //QuickDialogNavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
                        
                        //nav[SIDE_NAV_INDEX_BUDDY] = navigation;
                        
                    }
                    currentIndex = SIDE_NAV_INDEX_BUDDY;

                    break;
#else
                case 1:
                    //Activity
                    if(nav[SIDE_NAV_INDEX_ACTIVITY] == nil)
                        nav[SIDE_NAV_INDEX_ACTIVITY] = [storyboard instantiateViewControllerWithIdentifier:@"activityNavViewer"];
                    
                    currentIndex = SIDE_NAV_INDEX_ACTIVITY;
                    //appDelegate.deviceManager.badgeNum = 0;
                    //[self.navigationController pushViewController: myController animated:YES];
                    //NSLog(@"Activity");
                    break;
                    
#endif
                default:
                    break;
            }
        
            
            break;
        }
        case 2:{
            switch (indexPath.row) {
#if 1
                case 0:
                    //Settings

                    
                    if(nav[SIDE_NAV_INDEX_SETTING] == nil)
                        nav[SIDE_NAV_INDEX_SETTING] = [storyboard instantiateViewControllerWithIdentifier:@"settingsNavViewer"];
                    
                    currentIndex = SIDE_NAV_INDEX_SETTING;

#if 0
                        QRootElement *root =    [[QRootElement alloc] initWithJSONFile:@"QDGeneralSetting"];// [[QRootElement alloc] init];
                        root.title = @"General Settings";
                        root.grouped = YES;
                        
                        QuickDialogNavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
                        
                        nav[indexPath.row] = navigation;
#endif
                    // NSLog(@"Settings");
                    break;
#endif
                case 1:
                {
                    NSLog(@"Logout");
#if 0
                    MMNavigationController *navw = (MMNavigationController *) self.mm_drawerController.centerViewController;
                    
                    MMExampleCenterTableViewController * centerView = (MMExampleCenterTableViewController *) navw.topViewController;
                    //[centerView.p4pPlatform ubiaPlatformDeInitialize];
                    //[centerView.video destroyH264];
                    
                    centerView.deviceList = nil;
                    //[centerView.checkStatusTimer setFireDate:[NSDate distantFuture]];
#else
#ifdef WITH_CLOUD_FUNCTION
                    for (int i =0; i< 8; i++) {
                        nav[i] = nil;
                    }
#else
                    for (int i =0; i< 6; i++) {
                        nav[i] = nil;
                    }
#endif
                    
#endif
                    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
                    
                    [appDelegate.deviceManager.restClient.myDeviceList removeAllDevice];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName: @"backTutorialPageNotification" object: nil];
                }
                break;
                    
                default:
                    break;
            }
            if (currentIndex != 6) {
                [self.mm_drawerController setCenterViewController:nav[currentIndex]
                                               withCloseAnimation:YES // withFullCloseAnimation
                                                       completion:nil];
            }

            break;
        }
#if 1
        case 3:
            if(nav[SIDE_NAV_INDEX_OTHER] == nil)
                nav[SIDE_NAV_INDEX_OTHER] = [storyboard instantiateViewControllerWithIdentifier:@"NewMainEntry"];
            
            currentIndex = SIDE_NAV_INDEX_OTHER;
            break;
#endif
        default:
            break;
    }
    
    [self.mm_drawerController setCenterViewController:nav[currentIndex]
                                   withCloseAnimation:YES // withFullCloseAnimation
                                           completion:nil];
    
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
