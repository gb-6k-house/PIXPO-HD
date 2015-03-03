

#import "MMAppDelegate.h"
#import "ConnectDeviceSoftAPController.h"
#import "DeviceWifiAPListController.h"
#import "LoginInfo.h"

#import "ubiaDeviceManager.h"
#import "ubiaRestClient.h"
#import "ubiaDevice.h"
#import "ubiaClient.h"
#import "ubiaWifiApInfo.h"


extern char * ioctrlRecvBuf;
extern char * ioctrlSendBuf;

@interface ConnectDeviceSoftAPController (){
    BOOL isSearchDoing;
    BOOL isSearchFinished;
    struct st_LanSearchInfo foundDevicelist[4];
    int numofFoundDevice;
    NSMutableArray * aplistArray;
    int retry_connect;
}

- (void)onConnect:(QButtonElement *)buttonElement;
@end

@implementation ConnectDeviceSoftAPController
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

        //restClient = [[ubiaRestClient alloc] init];
        aplistArray = [NSMutableArray arrayWithCapacity:32];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back_txt", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    
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

- (void)loginCompleted:(LoginInfo *)info {
    [self loading:NO];
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:[NSString stringWithFormat: @"Hi %@, I hope you're loving QuickDialog! Here's your pass: %@", info.login, info.password] delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:nil];
    //[alert show];
    
    [restClient persistSaveAccountInfo];
    restClient.hasLogin = TRUE;
    NSArray *myKeys = [NSArray arrayWithObjects:@"restClient",nil];
    
    NSArray *myObjects = [NSArray arrayWithObjects: restClient,nil];
    NSDictionary *myTestDictionary = [NSDictionary dictionaryWithObjects:myObjects forKeys:myKeys];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"loginSuccessNotification" object:nil userInfo: myTestDictionary];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName: @"loginSuccessNotification" object: restClient];
    
}
-(void) handleUbicSessionStatusNotification:(NSNotification *)note{
    int sessionID = [[[note userInfo] objectForKey:@"ubicSessionID"] intValue];
    int errCode = [[[note userInfo] objectForKey:@"ubicErrorCode"] intValue];
    
    [self loading:NO];
    
    if(IOTCER_NoERROR == errCode){
        NSLog(@"receive [%@][SID:%d] Connect sucess [status:%d]", currentDevice.uid, sessionID,currentDevice.client.status);
        
        [NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
        
        //[self performSelectorOnMainThread:@selector(onSetupDeviceWifiConfig:) withObject:nil waitUntilDone:NO];

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

- (void)startTheBackgroundJob {
    
    NSLog(@"[%@] startTheBackgroundJob...",currentDevice.uid);
    
    [NSThread setThreadPriority:0.1];
    
#if 1
    int retry = 0;
    int retVal = 0;
    if (currentDevice.client.status == UBIA_CLIENT_STATUS_CONNECTED) {
        [currentDevice.client loginToDevice];
    }
    if (currentDevice.client.status != UBIA_CLIENT_STATUS_AUTHORIZED) {
        NSLog(@"isnot loginToDevice, get wifilist fail, exit thread");
        return;
    }
    
    BACKEND_IOCTL_MSG * pIOMsg = (BACKEND_IOCTL_MSG *) ioctrlRecvBuf;
    
    [currentDevice requestWIFIAPList];
    
    currentDevice.isWaitIOResp = true;
    
    while (currentDevice.isWaitIOResp) {
        
        if(currentDevice.isPendingIOControl){
            [NSThread sleepForTimeInterval:0.5];
        }else{
            
            retVal = [currentDevice.client recvIOControl:currentDevice.client.avid withTimeout:2000 withbuf:ioctrlRecvBuf];
            if (retVal > 0){
                if(pIOMsg->cmdType == IOTYPE_USER_IPCAM_LISTWIFIAP_RESP){
                    [aplistArray removeAllObjects];
                    SMsgAVIoctrlListWifiApResp * pRsp = (SMsgAVIoctrlListWifiApResp *)(pIOMsg + 1);
                    if(pRsp->number > 0 && pRsp->number < 32){
                        
                        for(int i=0; i < pRsp->number; i++)
                        {
                            ubiaWifiApInfo * apInfo = [[ubiaWifiApInfo alloc] init];
                            apInfo.ssid = [NSString stringWithUTF8String:pRsp->stWifiAp[i].ssid];
                            apInfo.mode = pRsp->stWifiAp[i].mode;
                            apInfo.enctype = pRsp->stWifiAp[i].enctype;
                            apInfo.signal = pRsp->stWifiAp[i].signal;
                            apInfo.status = pRsp->stWifiAp[i].status;
                            [aplistArray addObject:apInfo];
                            
                        }
                        
                    }
                    [self performSelectorOnMainThread:@selector(getAPListCompleted:) withObject:nil waitUntilDone:NO];
                    break;
                }
                
            }else{
                if (AV_ER_TIMEOUT == retVal || AV_ER_DATA_NOREADY == retVal) {
                    [currentDevice requestWIFIAPList];
                    retry++;
                }else{
                    break;
                }
            }
            if(retry > 3) break;
        }
    }
    
    currentDevice.isWaitIOResp = false;
#endif
    NSLog(@"[%@] startTheBackgroundJob...Exit",currentDevice.uid);
}

- (void)getAPListCompleted:(LoginInfo *)info {
    NSLog(@"getAPListCompleted==>");
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"init_camera_step2_txt", nil);
    root.grouped = YES;
    root.controllerName = @"DeviceWifiAPListController";
    
    QSection *section = [[QSection alloc] initWithTitle:@"Wifi AP List"];
    section.title = @"Wifi Config";
    //section.headerImage = @"logo";
    section.footer = NSLocalizedString(@"please_choose_wifi_txt", nil);
    
    int i  = 0;
    for (i=0; i< [aplistArray count]; i++) {
        
        ubiaWifiApInfo *wifiApInfo = [aplistArray objectAtIndex:i];
        
        NSString  * signal = [NSString  stringWithFormat:@"%d",wifiApInfo.signal];
        
        QBadgeElement *badge3 = [[QBadgeElement alloc] initWithTitle:wifiApInfo.ssid Value:signal];
        
        badge3.badgeColor = [UIColor colorWithRed:0.9518 green:0.3862 blue:0.4113 alpha:1.0000]; //[UIColor purpleColor];
        
        badge3.controllerAction = @"onSelectWifiAP:";
        badge3.key = @"wifi_ap_key";

        [section addElement:badge3];
    }
    
    [root addSection:section];
    
    DeviceWifiAPListController * destViewController = (DeviceWifiAPListController * )[QuickDialogController controllerForRoot:root];
    destViewController.currentDevice = currentDevice;
    destViewController.aplistArray = aplistArray;
    NSLog(@"getAPListCompleted<==");
    [self.navigationController pushViewController:destViewController animated:YES];
}

- (void)doSearchBackground{
    
    int retry = 3;
    Boolean deviceInList = FALSE;
    
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
    
    //[self performSelectorOnMainThread:@selector(makeUpdateTableofFoundDevice) withObject:nil waitUntilDone:NO];
    
}

- (void)onConnect:(QButtonElement *)buttonElement {

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self loading:YES];
    retry_connect = 0;
    isSearchDoing = TRUE;
    isSearchFinished = FALSE;
    memset(foundDevicelist,0,sizeof(struct st_LanSearchInfo)*4);
    [NSThread detachNewThreadSelector:@selector(doSearchBackground) toTarget:self withObject:NO];
}

- (void) onSetupDeviceWifiConfig:(QButtonElement *)buttonElement {
    NSLog(@"onSetupDeviceWifiConfig==>");
    
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"init_camera_step2_txt", nil);
    root.grouped = YES;
    root.controllerName = @"setupDeviceWifiConfigController";
    
    QSection *section = [[QSection alloc] init];
    section.title = @"Wifi Config";
    //section.headerImage = @"logo";
    section.footer = @"Please type your credentials.";
    
#if 0
    
    QEntryElement *pwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"password", nil) Value:@"" Placeholder:NSLocalizedString(@"password", nil)];
    pwdEntry.bind=@"textValue:password";
    pwdEntry.key = @"password_key";
    pwdEntry.secureTextEntry = true;
    
    [root addSection:section];
    [section addElement:loginEntry];
    [section addElement:pwdEntry];
#endif
    
    QSection *subsection = [[QSection alloc] init];
    QButtonElement *myGetButton = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"init_camera_step2_txt", nil)];
    myGetButton.controllerAction = @"onGetWifiAPList:";
    myGetButton.key = @"get_button_key";
    
    [subsection addElement:myGetButton];
    
    //QSection *subsection1 = [[QSection alloc] init];
    //[subsection3 addElement:mySetButton];
    
    [root addSection:subsection];

    //QuickDialogNavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
    
    //[self.navigationController presentViewController:navigation animated:YES completion:^{
    //    NSLog(@"Register completion");
    //}];
    DeviceWifiAPListController * destViewController = (DeviceWifiAPListController * )[QuickDialogController controllerForRoot:root];
    destViewController.currentDevice = currentDevice;
    NSLog(@"onSetupDeviceWifiConfig<==");
    [self.navigationController pushViewController:destViewController animated:YES];
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
