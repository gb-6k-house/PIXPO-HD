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


#import "MMExampleCenterTableViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMLogoView.h"
#import "MMCenterTableViewCell.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
#import "MMNavigationController.h"

#import "MMAppDelegate.h"

#import "KxMenu.h"
#import "ubiaAddDeviceTableViewController.h"
#import "ubiaDevice.h"

#import "ubiaDeviceList.h"

//#import "ubiaDetailViewController.h"
#import "ubiaDeviceTableViewCell.h"

#import "ubiaDeviceManager.h"
#import "ubiaRestClient.h"
#import "Utilities.h"
#import "MMImageViewer.h"

#import "setupDeviceWifiConfigController.h"
#import "easyDeviceWifiConfigController.h"
//#import "easySelectDeviceController.h"
#import "wizardDeviceSoftAPController.h"

#import "QuickDialog.h"
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, MMCenterViewControllerSection){
    MMCenterViewControllerSectionLeftViewState,
    MMCenterViewControllerSectionLeftDrawerAnimation,
    MMCenterViewControllerSectionRightViewState,
    MMCenterViewControllerSectionRightDrawerAnimation,
};

@interface MMExampleCenterTableViewController ()

@end


@implementation MMExampleCenterTableViewController
{
   // UIButton *addBtn;
    NSString *QRScanResult;
    __weak ubiaDeviceManager * deviceManager;
    __weak ubiaRestClient * restClient;
    BOOL backgroudJobRunning;
}
@synthesize deviceList;

//@synthesize checkStatusTimer;

- (void)stopTheBackgroundJob {
    
    // wait for 3 seconds before starting the thread, you don't have to do that. This is just an example how to stop the NSThread for some time
    //[NSThread sleepForTimeInterval:3];
    backgroudJobRunning = FALSE;

}
- (void)startTheBackgroundJob {
	
    backgroudJobRunning = TRUE;
	// wait for 3 seconds before starting the thread, you don't have to do that. This is just an example how to stop the NSThread for some time
    //[NSThread sleepForTimeInterval:3];
    
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
#if ENABLE_AUTO_CONNECT
                    [device startclient];
#endif
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


- (id)init
{
    self = [super init];
    if (self) {
        [self setRestorationIdentifier:@"MMExampleCenterControllerRestorationKey"];
    }
    return self;
}

-(void) loadView{
    [super loadView];
    //Add by Maxwell to init P4PController
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    deviceManager = appDelegate.deviceManager;
    restClient = deviceManager.restClient;
    deviceList = restClient.myDeviceList;
    
    if(deviceList == nil){
        deviceList = [[ubiaDeviceList alloc] init];
    }
    
    
    NSLog(@"--- %@",NSLocalizedStringFromTable(@"loading",@"ubiaLocalizable", nil));
    //NSLog(@"+++ %@",NSLocalizedString(@"loading",nil));
    self.navigationItem.title = NSLocalizedString(@"my_cameras_txt", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"center table viewDidLoad");
    
#if 1
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
#endif
    
    //_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //[self.tableView setDelegate:self];
    //[self.tableView setDataSource:self];
    //[self.view addSubview:self.tableView];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer * twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerDoubleTap:)];
    [twoFingerDoubleTap setNumberOfTapsRequired:2];
    [twoFingerDoubleTap setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:twoFingerDoubleTap];
    

    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
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
    
    //iosAudio = [[ubiaAudioController alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //NSLog(@"Center will appear");
    
    [self startTheBackgroundJob];
    
    self.navigationController.toolbar.hidden = TRUE;
    [self.navigationController setToolbarHidden:TRUE animated:FALSE];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFunc:) name: @"ubiaMasterViewNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restClientComplete:) name: @"ubiaRestClientCompleteNotification" object:nil];
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    deviceManager = appDelegate.deviceManager;
    restClient = deviceManager.restClient;
    deviceList = restClient.myDeviceList;
    
    [deviceManager enterMyDeviceView];
    
    //[checkStatusTimer setFireDate:[NSDate distantPast]];
    
    self.mm_drawerController.closeDrawerGestureModeMask =  MMCloseDrawerGestureModePanningNavigationBar |MMCloseDrawerGestureModeTapNavigationBar| MMCloseDrawerGestureModeTapCenterView;
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningNavigationBar;
    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"Center did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    self.mm_drawerController.closeDrawerGestureModeMask =  MMCloseDrawerGestureModeAll;
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    
    [super viewWillDisappear:animated];
    NSLog(@"Center will disappear");
    //[checkStatusTimer setFireDate:[NSDate distantFuture]];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"Center did disappear");

}

- (void)restClientComplete:(NSNotification *)note{
    //ubiaDevice * device = nil;
    NSString *command = [[note userInfo] objectForKey:@"RestCommand"];
    NSLog(@"restClientComplete ==>:%@  %@ num[%d]", command, deviceList,[deviceList count]);
    if([command isEqualToString:@"GET_MYLIST"] || [command isEqualToString:@"DEVICE_OP_ADD"]){
        deviceList = deviceManager.restClient.myDeviceList;
        [deviceList startAllDevice];
    }else if([command isEqualToString:@"DEVICE_OP_DEL"]){
        deviceList = deviceManager.restClient.myDeviceList;
    }

    NSLog(@"restClientComplete <== :%@  %@ num[%d]", command, deviceList,[deviceList count]);

    [self.tableView reloadData];
    
}

- (void)handleFunc:(NSNotification *)note{
    NSLog(@"Received Local notification: %@", note);
    ubiaDevice *device = [[note userInfo] objectForKey:@"ubiaDevice"];
#if 1
    [restClient device_op:device operate:DEVICE_OP_MODIFY];
#else
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSArray  *fetchedObjects = [[self fetchedResultsController] fetchedObjects];
    NSManagedObject *object;
    NSString *uid;
    for(int i=0; i < [fetchedObjects count]; i++){
        object = fetchedObjects[i];
        uid = [[object valueForKey:@"devUID"] description];
        if(uid == device.uid){
            [object setValue:device.client.password forKey:@"devPwd"];
            [object setValue:device.name forKey:@"devName"];
            [object setValue:device.client.loginID forKey:@"devLoginID"];
            
            NSError *error;
            [context save:&error];
            break;
        }
    }
#endif
    
}

-(void)handleData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm:ss a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
   
    [self reConnect:self];
    [self.refreshControl endRefreshing];
    
    //[self.tableView reloadData];
}


-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing data..."];

        [self.tableView reloadData];
        [self performSelector:@selector(handleData) withObject:nil afterDelay:0];
    }
}

- (void) reConnect:(id) sender{
    //[self performSegueWithIdentifier:@"gotoAddDevice"sender:self];
    for (int i = 0; i < [deviceList count]; i++) {
        ubiaDevice * device = (ubiaDevice *) [deviceList getDeviceByIndex:i];
        if(device.client.status != UBIA_CLIENT_STATUS_CONNECTED && device.client.status != UBIA_CLIENT_STATUS_AUTHORIZED){
            MMCenterTableViewCell * cell = (MMCenterTableViewCell *)device.cell;
            //cell.statusLabel.text = NSLocalizedString(@"pending", nil) ;
            [cell.snapImageView loading:YES];

            [device stopclient];
            [device startclient];
        }
    }
}


- (void)easySetupCamera {
    
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"easy_setup_step2_txt", nil);
    root.grouped = YES;
    root.controllerName = @"easyDeviceWifiConfigController";
    
    QSection *section0 = [[QSection alloc] initWithTitle:@"Wifi AP List"];
    section0.title = NSLocalizedString(@"easy_setup_note_txt", nil);
    //section0.headerImage = @"logo";
    section0.footer = @"";
    
    [root addSection: section0];
    
    QSection *section = [[QSection alloc] initWithTitle:@"Wifi AP List"];
    section.title = NSLocalizedString(@"easy_input_wifi_key_txt", nil);
    //section.headerImage = @"logo";
    section.footer = @"";
    
    QEntryElement *ssidEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"ap_ssid", nil) Value:@"" Placeholder:NSLocalizedString(@"ap_ssid", nil)];
    
    ssidEntry.key = @"ap_ssid";
    ssidEntry.bind=@"textValue:ssid";
    
    QEntryElement *pwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"ap_key", nil) Value:@"" Placeholder:NSLocalizedString(@"ap_key", nil)];
    pwdEntry.bind=@"textValue:key";
    pwdEntry.key = @"ap_key";
    pwdEntry.secureTextEntry = true;
    
    [section addElement:ssidEntry];
    [section addElement:pwdEntry];
    [root addSection:section];
    
    QSection *section1 = [[QSection alloc] init];
    QButtonElement *myGetButton = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"easy_setup_apply_txt", nil)];
    myGetButton.controllerAction = @"onSetWifiAPConfig:";
    myGetButton.key = @"set_button_key";
    
    [section1 addElement:myGetButton];
    
    [root addSection:section1];
    
    easyDeviceWifiConfigController * destViewController = (easyDeviceWifiConfigController * )[QuickDialogController controllerForRoot:root];
    
    [self.navigationController pushViewController:destViewController animated:YES];
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

-(void)wizardSetupCamera{
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"initial_camera_txt", nil);
    root.grouped = YES;
    root.controllerName = @"wizardDeviceSoftAPController";
    
    QSection *subsection2 = [[QSection alloc] init];
    
    subsection2.title = NSLocalizedString(@"init_camera_notify_txt", nil);
    
    QButtonElement *myButton = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"init_camera_step1_txt", nil)];
    
    myButton.controllerAction = @"onConnect:";
    myButton.key = @"button_key";
    
    [subsection2 addElement:myButton];
    [root addSection:subsection2];
    
    [self.navigationController pushViewController:[QuickDialogController controllerForRoot:root] animated:YES];
}

- (void)showMenu:(UIBarButtonItem *)sender
{
    NSArray *menuItems =
    @[
      
#if 1
      [KxMenuItem menuItem:NSLocalizedString(@"by_setup_wifi_txt", nil)
                     image:[UIImage imageNamed:@"wifi24x24"]
                    target:self
                    action:@selector(wizardSetupCamera)],
#else
      [KxMenuItem menuItem:NSLocalizedString(@"by_wifi_direct_txt", nil)
                     image:[UIImage imageNamed:@"quick"]
                    target:self
                    action:@selector(easySetupCamera)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"by_setup_wifi_txt", nil)
                     image:[UIImage imageNamed:@"wifi24x24"]
                    target:self
                    action:@selector(wizardSetupCamera)],
#endif
      [KxMenuItem menuItem:NSLocalizedString(@"by_search_txt", nil)
                     image:[UIImage imageNamed:@"search_icon"]
                    target:self
                    action:@selector(addDeviceByUID:)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"by_scan_qrcode_txt", nil)
                     image:[UIImage imageNamed:@"scan_icon"]
                    target:self
                    action:@selector(QRScanButtonTapped:)],
      ];
    
    //KxMenuItem *first = menuItems[0];
    //first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    //first.alignment = NSTextAlignmentCenter;
    

    UIView *targetView = (UIView *)[self.navigationItem.rightBarButtonItem performSelector:@selector(view)];
    CGRect rect = targetView.frame;
    rect.origin.y += 30;
    
    [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
}

- (void) QRScanButtonTapped:(id)sender
{
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    //[self presentModalViewController: reader animated: YES];
    [self presentViewController: reader animated:YES completion:(void (^)(void))nil];
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    //ubiaLabel_TextFieldCell * cell = (ubiaLabel_TextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    //cell.attrValue.text = symbol.data;
    
    QRScanResult = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    //resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    [self performSegueWithIdentifier:@"gotoAddDevice" sender:self];

}

- (void) pushMenuItem:(id)sender
{
    NSLog(@"%@", sender);

    
}

- (void) addDeviceByUID:(id)sender{
    QRScanResult = @"";
    [self performSegueWithIdentifier:@"gotoAddDevice" sender:self];
}

- (void) appWillEnterForegroundNotification{
    
    NSLog(@"MMExampleCenterTableViewController trigger event when will enter foreground.");
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //restClient = appDelegate.restClient;
    deviceManager = appDelegate.deviceManager;
    restClient = deviceManager.restClient;
    
    
    //[checkStatusTimer setFireDate:[NSDate distantPast]];
    
}
- (void) appWillResignActiveNotification{
    
    NSLog(@"MMExampleCenterTableViewController trigger event when will Resign Active.");

    //[checkStatusTimer setFireDate:[NSDate distantFuture]];
    
}


-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton{
   //MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];

    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMenu:)];
    
    
    //addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[addBtn setFrame:CGRectMake(60, self.view.frame.size.height-16-25, 25, 25)];
    //[addBtn setImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
    //[addBtn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *addBarBtn = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    //[addBtn setShowsTouchWhenHighlighted:YES];//设置发光
    [self.navigationItem setRightBarButtonItem:rightButton animated:YES];
    
}

-(void)contentSizeDidChange:(NSString *)size{
    [self.tableView reloadData];
}

- (IBAction)tapAddButton:(id)sender {
    [ self showMenu:sender];
}

/***+++++++++++++++++++++++++++***/
- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) insertNewObject:(ubiaDevice *)device
{

    if (nil == [deviceList getDeviceByUID:device.uid]) {
        if([restClient.myDeviceList count] < MAX_SESSION){
            [restClient device_op:device operate:DEVICE_OP_ADD];
            [device startclient];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"reach_max_device", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }


}


#pragma mark - Table View

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"centerCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //MMCenterTableViewCell  *cell = (MMCenterTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        int row = [indexPath row];
        ubiaDevice * device = [deviceList getDeviceByIndex:row];
        
        [device stopclient];
        [restClient device_op:device operate:DEVICE_OP_DEL];
        //[deviceList removeDevice:device];
        device = nil;
        [self.tableView reloadData];
    
        //NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        //[context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
   
        //NSLog(@"segue prepare to %@",[segue identifier]);

        //[deviceList getDeviceByUID:[[object valueForKey:@"devUID"] description]];
        //delSession([device.uid UTF8String]);
       
        //[deviceList removeDeviceByUID:device.uid];
#if 0
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
#endif
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = [[object valueForKey:@"devUID"] description];
    //cell.detailTextLabel.text = @"unknown";
    
   
    int row = [indexPath row];
    ubiaDevice *device = [deviceList getDeviceByIndex:row];
    
    if(nil == device.client.loginID){
    	device.client.loginID = @"admin";
    }
    if(nil == device.client.password){
    	device.client.password = @"admin";
    }
    
    MMCenterTableViewCell *deviceCell = (MMCenterTableViewCell *) cell;

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
    //NSLog(@"configureCell==> [%p] %@[%d] internalvisible:%d", deviceCell,device.uid,device.client.status, deviceCell.snapImageView.internalVisible);
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
    //NSLog(@"configureCell==< [%p] %@ internalvisible:%d", deviceCell, device.uid, deviceCell.snapImageView.internalVisible);
    
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
        
        [cell.snapImageView loading:YES];
        cell.play_statusView.hidden = TRUE;
        
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
    
    if ([[segue identifier] isEqualToString:@"gotoLive"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSLog(@"segue prepare to %@",[segue identifier]);
        
        ubiaDevice * device = [deviceList getDeviceByIndex:[indexPath row]];
        //MMCenterTableViewCell  *cell = (MMCenterTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        deviceManager.currentDevice = device;
        deviceManager.autoStartListen = TRUE;
        
        [[segue destinationViewController] setCurrentDevice:device];
        
    }else if ([[segue identifier] isEqualToString:@"gotoAddDevice"]) {
        
        ubiaAddDeviceTableViewController *addView = [segue destinationViewController];
        [addView setDeviceUID:QRScanResult];
        
    }else if ([[segue identifier] isEqualToString:@"gotoDeviceDetail"]) {

    }
}

/***===========================***/

#pragma mark - Table view data source

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
    switch (section) {
        case MMCenterViewControllerSectionLeftDrawerAnimation:
            return @"Left Drawer Animation";
        case MMCenterViewControllerSectionRightDrawerAnimation:
            return @"Right Drawer Animation";
        case MMCenterViewControllerSectionLeftViewState:
            return @"Left Drawer";
        case MMCenterViewControllerSectionRightViewState:
            return @"Right Drawer";
        default:
            return nil;
            break;
    }
}
#pragma mark - Table view delegate


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

/*
 In response to a swipe gesture, show the image view appropriately then move the image view in the direction of the swipe as it fades out.
 */
- (IBAction)handleGestureforLongPress:(id)sender {
    NSLog(@"long press");

}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL retVal = FALSE;

    MMCenterTableViewCell *cell = (MMCenterTableViewCell *)sender;
    
    NSIndexPath * index = [self.tableView indexPathForCell:cell];
    
    ubiaDevice *device = [deviceList getDeviceByIndex:index.row];
    
    if ([identifier isEqualToString:@"gotoLive"]) {
        
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
