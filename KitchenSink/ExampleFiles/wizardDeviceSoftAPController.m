

#import "MMAppDelegate.h"
#import "wizardDeviceSoftAPController.h"
#import "wizardBindDeviceController.h"
#import "LoginInfo.h"

#import "ubiaDeviceManager.h"
#import "ubiaRestClient.h"
#import "ubiaDevice.h"
#import "ubiaClient.h"
#import "ubiaWifiApInfo.h"


extern char * ioctrlRecvBuf;
extern char * ioctrlSendBuf;

@interface wizardDeviceSoftAPController (){
    BOOL isSearchDoing;
    BOOL isSearchFinished;
    struct st_LanSearchInfo foundDevicelist[4];
    int numofFoundDevice;
    int retry_connect;
}

- (void)onConnect:(QButtonElement *)buttonElement;
@end

@implementation wizardDeviceSoftAPController
@synthesize restClient;
@synthesize currentDevice;

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        //self.root.appearance.tableGroupedBackgroundColor =  [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];
        
        ((QEntryElement *)[self.root elementWithKey:@"login_key"]).delegate = self;

        QAppearance *fieldsAppearance = [self.root.appearance copy];

        fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
        
        [self.root elementWithKey:@"button_key"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"button_key"].appearance.backgroundColorEnabled = [UIColor colorWithRed:0.4 green:0.8104 blue:0.7991 alpha:1.0000];

  
        [self.root elementWithKey:@"button_key"].appearance.buttonAlignment  = NSTextAlignmentCenter;
        
        if (nil == currentDevice) {
            currentDevice = [[ubiaDevice alloc] init];
        }

    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUbicSessionStatusNotification:) name:@"ubiaSessionStatusNotification" object:nil];
    retry_connect = 0;
    //[self.quickDialogTableView reloadCellForElements:entry, nil];
    [self.quickDialogTableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewDidAppear:(BOOL)animated{
    [currentDevice stopclient];
}
-(void) viewDidLoad:(BOOL)animated{
  
}

-(void) handleUbicSessionStatusNotification:(NSNotification *)note{
    int sessionID = [[[note userInfo] objectForKey:@"ubicSessionID"] intValue];
    int errCode = [[[note userInfo] objectForKey:@"ubicErrorCode"] intValue];
    
    [self loading:NO];
    
    if(IOTCER_NoERROR == errCode){
        NSLog(@"receive [%@][SID:%d] Connect sucess [status:%d]", currentDevice.uid, sessionID,currentDevice.client.status);
        
        [NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
    }else{
        NSLog(@"receive disconnect err %d", errCode);
  
        if(sessionID == currentDevice.client.sid){
            //MMCenterTableViewCell * cell = (MMCenterTableViewCell *)device.cell;
            currentDevice.client.status = UBIA_CLIENT_STATUS_PENDINGTO_DISCONNECT;
            NSLog(@"CenterView handleUbicSessionStatusNotification UID: %@ SID:%d status change to %d",currentDevice.uid, sessionID,errCode);
            [currentDevice stopclient];
            if (retry_connect < UBIA_DEVICE_CONNECT_RETRIES) {

                [currentDevice startclient];
            }
            retry_connect++;
        }
    }
}

- (void) gotoBindDevice{
    
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"easy_setup_step3_txt", nil);
    root.grouped = YES;
    root.controllerName = @"wizardBindDeviceController";
    
    QSection *section1 = [[QSection alloc] init];
    section1.title = NSLocalizedString(@"easy_setup_device_auth_info", nil);
    
    QEntryElement *loginEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"device_login", nil) Value:@"admin" Placeholder:NSLocalizedString(@"device_login", nil)];
    
    loginEntry.key = @"login_key";
    loginEntry.bind=@"textValue:login";
    
    QEntryElement *pwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"device_password", nil) Value:@"admin" Placeholder:NSLocalizedString(@"device_password", nil)];
    pwdEntry.bind=@"textValue:password";
    pwdEntry.key = @"password_key";
    pwdEntry.secureTextEntry = true;
    
    [section1 addElement:loginEntry];
    [section1 addElement:pwdEntry];
    [root addSection:section1];
    
    QSection *section2 = [[QSection alloc] init];
    section2.title = NSLocalizedString(@"easy_setup_device_description", nil);
    
    QEntryElement *nameEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"device_name", nil) Value:@"Camera" Placeholder:NSLocalizedString(@"device_name", nil)];
    
    nameEntry.key = @"name_key";
    nameEntry.bind=@"textValue:name";
    
    QEntryElement *locationEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"device_location", nil) Value:@"" Placeholder:NSLocalizedString(@"device_location", nil)];
    locationEntry.bind=@"textValue:location";
    locationEntry.key = @"location_key";
    
    [section2 addElement:nameEntry];
    [section2 addElement:locationEntry];
    [root addSection:section2];
    
    QSection *section3 = [[QSection alloc] init];
    QButtonElement *myGetButton = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"easy_setup_apply_txt", nil)];
    myGetButton.controllerAction = @"onBindDevice";
    myGetButton.key = @"set_button_key";
    
    [section3 addElement:myGetButton];
    
    [root addSection:section3];
    
    wizardBindDeviceController * destViewController = (wizardBindDeviceController * )[QuickDialogController controllerForRoot:root];
    
    destViewController.deviceUID = currentDevice.uid;
    destViewController.currentDevice = currentDevice;
    
    [self.navigationController pushViewController:destViewController animated:YES];
}

- (void)startTheBackgroundJob {
    
    NSLog(@"[%@] startTheBackgroundJob...",currentDevice.uid);
    
    [NSThread setThreadPriority:0.1];
    
#if 1
    retry_connect = 0;
    while (retry_connect < 50 && currentDevice.client.isRunning) {
        [NSThread sleepForTimeInterval:0.2];
        retry_connect++;
    }
    
    if (currentDevice.client.status == UBIA_CLIENT_STATUS_CONNECTED) {
        [currentDevice.client loginToDevice];
    }
    if (currentDevice.client.status != UBIA_CLIENT_STATUS_AUTHORIZED) {
        NSLog(@"isnot loginToDevice, exit thread");
        return;
    }else{
        [self gotoBindDevice];
    }

#endif
    NSLog(@"[%@] startTheBackgroundJob...Exit",currentDevice.uid);
}


- (void)doSearchBackground{
    
    int retry = 3;
    
    while (retry-- > 0) {
        numofFoundDevice = UBIC_Lan_Search(foundDevicelist,4,3000);
        if (numofFoundDevice > 0) {
            NSLog(@"got num %d",numofFoundDevice);
   
            currentDevice.uid = [NSString  stringWithUTF8String: foundDevicelist[0].UID];
            currentDevice.ipaddr = [ NSString stringWithUTF8String:foundDevicelist[0].IP];
            currentDevice.port = foundDevicelist[0].port;
            NSLog(@"got uid:%@",currentDevice.uid);
            
            currentDevice.client.loginID = @"admin";
            currentDevice.client.password = @"admin";
            
            NSLog(@"Lan search: Device[%@] ProtoVer[%d]",currentDevice.uid, foundDevicelist[0].Reserved);
            if (foundDevicelist[0].Reserved == 4)
            {
                currentDevice.client.p2pLibVer = P2PLIB_VER_UBIA_V2;
            }else{
                currentDevice.client.p2pLibVer = P2PLIB_VER_UBIA_V1;
            }

            MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            if (appDelegate.deviceManager.restClient.myDeviceList != nil) {
                ubiaDevice *device = [appDelegate.deviceManager.restClient.myDeviceList getDeviceByUID:currentDevice.uid];
                if (device != nil) {
                    [device stopclient];
                }

            }
            
            [currentDevice startclient];
            
            break;
        }
    }
    
    isSearchDoing = FALSE;
    
    if(numofFoundDevice < 0) {
        NSLog(@" Lan Search err %d",numofFoundDevice);
    }else if(numofFoundDevice == 0){
        NSLog(@" Lan Search no device");
    }else{
        
    }
    isSearchFinished = TRUE;
}

- (void)onConnect:(QButtonElement *)buttonElement {

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (currentDevice.client.status == UBIA_CLIENT_STATUS_AUTHORIZED) {
        [self gotoBindDevice];
    }else{
        [self loading:YES];
        retry_connect = 0;
        isSearchDoing = TRUE;
        isSearchFinished = FALSE;
        memset(foundDevicelist,0,sizeof(struct st_LanSearchInfo)*4);
        [NSThread detachNewThreadSelector:@selector(doSearchBackground) toTarget:self withObject:NO];
    }
}

- (BOOL)QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Should change characters");
    return YES;
}

- (void)QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    //NSLog(@"Editing changed");
}


- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Must return");

}



@end
