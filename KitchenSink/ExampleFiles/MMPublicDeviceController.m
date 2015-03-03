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


#import "MMPublicDeviceController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMLogoView.h"
#import "MMCenterTableViewCell.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
#import "MMNavigationController.h"

#import "MMAppDelegate.h"
#import "ubiaDevice.h"

#import "ubiaDeviceList.h"

//#import "MMPubLiveViewController.h"
#import "ubiaDeviceTableViewCell.h"

//#import "ubiaAudioController.h"
#import "ubiaRestClient.h"
#import "ubiaDeviceManager.h"
#import "Utilities.h"

#import "QuickDialog.h"
#import "PZViewController.h"
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, MMCenterViewControllerSection){
    MMCenterViewControllerSectionLeftViewState,
    MMCenterViewControllerSectionLeftDrawerAnimation,
    MMCenterViewControllerSectionRightViewState,
    MMCenterViewControllerSectionRightDrawerAnimation,
};

@interface MMPublicDeviceController ()

@end

@implementation MMPublicDeviceController{
    __weak ubiaDeviceManager * deviceManager;
    BOOL backgroudJobRunning;
}
@synthesize restClient;
@synthesize deviceList;
//@synthesize detailViewController;

- (id)init
{
    self = [super init];
    if (self) {
        [self setRestorationIdentifier:@"MMPublicDeviceControllerRestorationKey"];
    }
    return self;
}

- (void)stopTheBackgroundJob {
    
    backgroudJobRunning = FALSE;
}
- (void)startTheBackgroundJob {
    
    backgroudJobRunning = TRUE;

    
    [self performSelectorOnMainThread:@selector(makeDeviceStatusUpdate) withObject:nil waitUntilDone:NO];
}

- (void)makeDeviceStatusUpdate {
    
    if (backgroudJobRunning == FALSE) {
        return;
    }
    
    if(deviceList == nil){
        [NSThread sleepForTimeInterval:1];
    }else {
        
        NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *visibleIndexPath in indexPaths) {
            //NSLog(@"makeDeviceStatusUpdate==>visiableIndex row:%d",[visibleIndexPath row]);
            MMCenterTableViewCell *deviceCell = (MMCenterTableViewCell *)[self.tableView cellForRowAtIndexPath:visibleIndexPath];
            ubiaDevice *device  = [deviceList getDeviceByIndex:[visibleIndexPath row]];
            //status updated
            //NSLog(@"StatusUpdate==>[%d->%d][%@][%p :internalvisible:%d]",device.status, device.client.status,device.uid,deviceCell,deviceCell.snapImageView.internalVisible);
            
            if ((device.client.status == UBIA_CLIENT_STATUS_CONNECTED) || (device.client.status == UBIA_CLIENT_STATUS_AUTHORIZED)) {
                deviceCell.play_statusView.hidden = FALSE;
                deviceCell.play_statusView.image = [UIImage imageNamed:@"play_white.png"];
                
                [[deviceCell.snapImageView.subviews lastObject] removeFromSuperview];
                
                deviceCell.snapImageView.image = [Utilities loadImageFile:@"snap.png" withUID:device.uid];
                
                if(nil == deviceCell.snapImageView.image){
                    deviceCell.snapImageView.image = [UIImage imageNamed:@"usnap_bg.png"];
                }
            }else{
                if (device.client.isRunning == FALSE) {
                    //deviceCell.snapImageView.image = [UIImage imageNamed:@"usnap_bg2.png"];
                    [device startclient];
                }
                deviceCell.play_statusView.hidden = TRUE;
            }
            
            //NSLog(@"StatusUpdate==<[%d->%d][%@][%p :internalvisible:%d]",device.status, device.client.status,device.uid,deviceCell,deviceCell.snapImageView.internalVisible);
            
            //[deviceCell setNeedsDisplayInRect:[deviceCell.snapImageView.image r]];
            //break;
            
        }
        
    }
    //NSLog(@"makeDeviceStatusUpdate %@ count=%d", deviceList, [deviceList count]);
    //checkStatusTimer =
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(makeDeviceStatusUpdate) userInfo:nil repeats:NO];
}

-(void) loadView{
    [super loadView];
    //Add by Maxwell to init P4PController
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    deviceManager = appDelegate.deviceManager;
    restClient = deviceManager.restClient;
    deviceList = restClient.publicList;
    
    if(deviceList == nil){
        deviceList = [[ubiaDeviceList alloc] init];
    }
    
    [self startTheBackgroundJob];
    
    NSLog(@"--- %@",NSLocalizedStringFromTable(@"loading",@"ubiaLocalizable", nil));
    //NSLog(@"+++ %@",NSLocalizedString(@"loading",nil));
    self.navigationItem.title = NSLocalizedString(@"featured_cameras_txt", nil);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    //MMLogoView * logo = [[MMLogoView alloc] initWithFrame:CGRectMake(0, 0, 29, 31)];
    //[self.navigationItem setTitleView:logo];
    //[self.navigationController.view.layer setCornerRadius:10.0f];
    
    //UIView *backView = [[UIView alloc] init];
    //[backView setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0  blue:208.0/255.0 alpha:1.0]];
    //UILabel * label = [[UILabel alloc] init];
    //label.text = @"No Any Featured Cameras";
    
    //[backView addSubview:label];
    //[self.tableView setBackgroundView:backView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restClientComplete:) name: @"ubiaRestClientCompleteNotification" object:nil];
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    deviceManager = appDelegate.deviceManager;
    restClient = deviceManager.restClient;
    deviceList = restClient.publicList;
    
    appDelegate.rotationEnabled = FALSE;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"MMPublicDeviceController will appear");
    [self.navigationController setToolbarHidden:TRUE animated:FALSE];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restClientComplete:) name: @"ubiaRestClientCompleteNotification" object:nil];
    
    [deviceManager enterPublicDeviceView];
    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"MMPublicDeviceController did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"MMPublicDeviceController will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"MMPublicDeviceController did disappear");
}

- (void) AllDeviceinloading{
    
    int count = [deviceList count];
    MMCenterTableViewCell * cell;
    for (int i = 0; i < count; i++) {
        NSIndexPath * index = [NSIndexPath indexPathForRow:i inSection:0];
        cell = (MMCenterTableViewCell *) [self.tableView cellForRowAtIndexPath:index];
        [cell.snapImageView loading:YES];
    }
    
}

- (void)restClientComplete:(NSNotification *)note{
    //ubiaDevice * device = nil;
    NSString *command = [[note userInfo] objectForKey:@"RestCommand"];
    
    if([command isEqualToString:@"GET_PUBLICLIST"]){
        //[deviceList stopAllDevice];
        //deviceList = restClient.publicList;
        //[self AllDeviceinloading];
        [deviceList startAllDevice];
        [self.tableView reloadData];
    }
}


- (void) appWillEnterForegroundNotification{
    
    NSLog(@"MMPublicDeviceController trigger event when will enter foreground.");
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    restClient = appDelegate.deviceManager.restClient;
    NSLog(@"%@ ", restClient);

    
}
- (void) appWillResignActiveNotification{
    
    //NSLog(@"MMPublicDeviceController trigger event when will Resign Active.");

}

-(void)setupLeftMenuButton{
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.deviceManager.restClient.hasLogin){
        MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
        [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
    }else{
        self.navigationController.navigationBar.tintColor = nil;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back_txt", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onBackButtonPress:)];
        
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"about_txt", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onAbout)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(setupWififorCamera)];
    }
}


-(void)setupWififorCamera{
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"initial_camera_txt", nil);
    root.grouped = YES;
    root.controllerName = @"ConnectDeviceSoftAPController";
    
    //QSection *section = [[QSection alloc] init];
    //section.title = @"Awesome Login Form";
    //section.headerImage = @"logo";
    //section.footer = @"";
    
    //[root addSection:section];
    
    QSection *subsection2 = [[QSection alloc] init];
    
    subsection2.title = NSLocalizedString(@"init_camera_notify_txt", nil);
    
    QButtonElement *myButton = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"init_camera_step1_txt", nil)];
    //QButtonElement *myButton = [[QButtonElement alloc] initWithTitle:@"Setup Device Wifi Config"];
    
    myButton.controllerAction = @"onConnect:";
    myButton.key = @"button_key";
    
    [subsection2 addElement:myButton];
    [root addSection:subsection2];
    
    [self.navigationController pushViewController:[QuickDialogController controllerForRoot:root] animated:YES];
}


#if 0
-(void)setupRightMenuButton{
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}
#endif

-(void)contentSizeDidChange:(NSString *)size{
    [self.tableView reloadData];
}

-(void)handleData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm:ss a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    [self reConnect:self];
    [self.refreshControl endRefreshing];

}

-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing data..."];
        
        //[restClient get_public_device_list];
        
        [self.tableView reloadData];
        [self performSelector:@selector(handleData) withObject:nil afterDelay:2];
    }
}

- (void) reConnect:(id) sender{
    //[self performSegueWithIdentifier:@"gotoAddDevice"sender:self];
    for (int i = 0; i < [deviceList count]; i++) {
        ubiaDevice * device = (ubiaDevice *) [deviceList getDeviceByIndex:i];
        if(!(device.client.status == UBIA_CLIENT_STATUS_CONNECTED || device.client.status == UBIA_CLIENT_STATUS_AUTHORIZED)){
            //ubiaDeviceTableViewCell * cell = (ubiaDeviceTableViewCell *)device.cell;
            //cell.statusLabel.text = NSLocalizedString(@"pending", nil) ;
            MMCenterTableViewCell * cell = (MMCenterTableViewCell *) device.cell;
            [cell.snapImageView loading:YES];
            [device stopclient];
            [device startclient];
        }
    }
}

#pragma mark - Table view data source

//- (NSArray *) visibleCells{}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [deviceList count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //MMCenterTableViewCell  *cell = (MMCenterTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        int row = [indexPath row];
        ubiaDevice * device = [deviceList getDeviceByIndex:row];
        
        [device stopclient];
        [restClient device_op:device operate:DEVICE_OP_DEL];
        [deviceList removeDevice:device];
        device = nil;
        [self.tableView reloadData];

    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    ubiaDevice *device = [deviceList getDeviceByIndex:row];
    
    if(nil == device.client.loginID){
    	device.client.loginID = @"admin";
    }
    if(nil == device.client.password){
    	device.client.password = @"admin";
    }
    
    MMCenterTableViewCell *deviceCell = (MMCenterTableViewCell *) cell;
    //deviceCell.snapImageView.image = [device load_lastsnap];
    deviceCell.snapImageView.image = [Utilities loadImageFile:@"snap.png" withUID:device.uid];
    NSString *name = device.name;
    if(nil == name){
        name = device.uid;
    }
    deviceCell.nameLabel.text = name;

    if(nil == deviceCell.snapImageView.image){
        //NSString* imageName = [[NSBundle mainBundle] pathForResource:@"Page" ofType:@"jpg"];
        //deviceCell.snapImageView.image =  [[UIImage alloc] initWithContentsOfFile:imageName];
        deviceCell.snapImageView.image = [UIImage imageNamed:@"usnap_bg.png"];
    }
    device.cell = cell;

    if (device.client.status != UBIA_CLIENT_STATUS_AUTHORIZED && device.client.status != UBIA_CLIENT_STATUS_CONNECTED) {
        
        //deviceCell.play_statusView.hidden = YES;
        //[deviceCell.snapImageView loading:YES];
        
        UIActivityIndicatorView *activeIndicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [deviceCell.snapImageView addSubview:activeIndicatorView];//[UIImage imageNamed:@"process.png"];
        
        [[deviceCell.snapImageView.subviews lastObject] startAnimating];
        [[deviceCell.snapImageView.subviews lastObject] setFrame:CGRectMake(0, 0, deviceCell.snapImageView.frame.size.width, deviceCell.snapImageView.frame.size.height)];
        [deviceCell.snapImageView bringSubviewToFront:activeIndicatorView];
        
        activeIndicatorView.alpha = 1;
        
        deviceCell.snapImageView.image = [UIImage imageNamed:@"usnap_bg.png"];//设置一个default图片，要不然activityindicator不会显示
        
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    int row = [indexPath row];
    ubiaDevice * device = [deviceList getDeviceByIndex:row];
    MMCenterTableViewCell * cell = (MMCenterTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if(device.client.status != UBIA_CLIENT_STATUS_CONNECTED && device.client.status != UBIA_CLIENT_STATUS_AUTHORIZED){
        
        cell.play_statusView.hidden = TRUE;
        [cell.snapImageView loading:YES];
        
        [device startclient];
        
    }else{
        //self.detailViewController.currentDevice = device;
        NSLog(@"Device[%@] is in [%d]",device.uid,device.client.status);
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifer = [segue identifier];
    NSLog(@"id:%@",identifer);
    
    if ([[segue identifier] isEqualToString:@"goPubLiveView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        NSLog(@"segue prepare to %@",[segue identifier]);
        
        ubiaDevice * device = [deviceList getDeviceByIndex:[indexPath row]];
#if 0
        //MMCenterTableViewCell  *cell = (MMCenterTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        MMPubLiveViewController * view = (MMPubLiveViewController *)[segue destinationViewController];
        MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.deviceManager.currentDevice = device;
#else
        PZViewController * view = (PZViewController *)[segue destinationViewController];
        MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appDelegate.deviceManager.currentDevice = device;
        view.pagingScrollView.pagingViewDelegate = view;
        
                
#endif
        [view setCurrentDevice:device];

    }
}

#pragma rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations {
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    if(!appDelegate.rotationEnabled){
        return UIInterfaceOrientationMaskPortrait;
    }else{
        return UIInterfaceOrientationMaskAll;
    }
}

/***===========================***/

#pragma mark - Button Handlers
-(void)onBackButtonPress:(id)sender{
    //didn't login just view public
    //[[NSNotificationCenter defaultCenter] postNotificationName: @"backTutorialPageNotification" object: nil];
    [self dismissViewControllerAnimated:YES completion:^{
   
        deviceManager.isPublicView = FALSE;
        NSLog(@"Exit PublicView");
    }];
    
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


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL retVal = FALSE;
    //NSLog(@"shouldPerformSegueWithIdentifier: identifer=%@", identifier);
    MMCenterTableViewCell *cell = (MMCenterTableViewCell *)sender;
    
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    
    ubiaDevice *device = [deviceList getDeviceByIndex:index.row];
    
    if ([identifier isEqualToString:@"goPubLiveView"]) {
        
        //ubiaDevice * device = [deviceList getDeviceByUID:cell.uid];
        
        if( UBIA_CLIENT_STATUS_CONNECTED == device.client.status ||
           UBIA_CLIENT_STATUS_AUTHORIZED == device.client.status)
        {
            retVal = TRUE;
        }
        
    }
    return retVal;
}


@end
