
#import "MMAppDelegate.h"
#import "wizardBindDeviceController.h"
#import "wizardWifiAPListController.h"
#import "BindDeviceInfo.h"
//#import "SVHTTPRequest.h"

#import "ubiaRestClient.h"
#import "ubiaDeviceList.h"
#import "ubiaDevice.h"
#import "ubiaDeviceManager.h"

#import "ubiaClient.h"
#import "ubiaWifiApInfo.h"
#import "LoginInfo.h"

extern char * ioctrlRecvBuf;
extern char * ioctrlSendBuf;

@interface wizardBindDeviceController (){
    NSMutableArray * aplistArray;
    int retry_connect;
}
@end

@implementation wizardBindDeviceController
@synthesize deviceUID;
@synthesize isKilled;
@synthesize toBindDeviceList;
@synthesize currentDevice;

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        //self.root.appearance.tableGroupedBackgroundColor =  [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];
        ((QEntryElement *)[self.root elementWithKey:@"login_key"]).delegate = self;
        
        QAppearance *fieldsAppearance = [self.root.appearance copy];

        fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
        [self.root elementWithKey:@"password_key"].appearance = fieldsAppearance;
        
        [self.root elementWithKey:@"set_button_key"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"set_button_key"].appearance.backgroundColorEnabled = [UIColor colorWithRed:0.4 green:0.8104 blue:0.7991 alpha:1.0000];
  
        [self.root elementWithKey:@"set_button_key"].appearance.buttonAlignment  = NSTextAlignmentCenter;
        
        aplistArray = [NSMutableArray arrayWithCapacity:32];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restClientAddDeviceComplete:) name: @"ubiaRestClientCompleteNotification" object:nil];
    
    [self.quickDialogTableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    isKilled = TRUE;
}
-(void) viewDidAppear:(BOOL)animated{
    isKilled = FALSE;
    [super viewDidAppear:animated];
}

- (void)onBindDevice{

    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
 
    BindDeviceInfo *info = [[BindDeviceInfo alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:info];
    
    
    if (info.login == nil && [info.login length] == 0) {
        //update user input
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                    message:NSLocalizedString(@"easy_input_device_login_txt", nil)
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    if (info.password == nil && [info.password length] == 0) {
        //update user input
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                    message:NSLocalizedString(@"easy_input_device_password_txt", nil)
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (deviceUID == nil || [deviceUID length] != UID_SIZE) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                            message:NSLocalizedString(@"uid_len_invalid", nil)
                                            delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    //couldn't change the login
    currentDevice.client.loginID = @"admin";
    currentDevice.loginID = @"admin";
    currentDevice.name = info.name;
    
    if (info.location == nil || [info.location length] == 0) {
        currentDevice.location= @"Default Location";
    }else{
        currentDevice.location = info.location;
    }
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    ubiaRestClient * restClient = appDelegate.deviceManager.restClient;

    [self loading:YES];
    
    if (FALSE == [info.password isEqualToString:@"admin"]) {
        [currentDevice setPassword:info.password withOldPassword:@"admin"];
        currentDevice.password = info.password;
        currentDevice.client.password = info.password;
    }
    [restClient device_op:currentDevice operate:DEVICE_OP_ADD];

}

- (void)restClientAddDeviceComplete:(NSNotification *)note{
    //ubiaDevice * device = nil;
    NSString *command = [[note userInfo] objectForKey:@"RestCommand"];

    if([command isEqualToString:@"DEVICE_OP_ADD"]){
        //[self.navigationController popToRootViewControllerAnimated:YES];
        [NSThread detachNewThreadSelector:@selector(getDeviceWifiList) toTarget:self withObject:nil];
        //[self getDeviceWifiList];
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

- (void)getDeviceWifiList {
    
    NSLog(@"[%@] getDeviceWifiList...",currentDevice.uid);
    
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
    NSLog(@"[%@] getDeviceWifiList...Exit",currentDevice.uid);
}

- (void)getAPListCompleted:(LoginInfo *)info {
    NSLog(@"getAPListCompleted==>");
    
    [self loading:NO];
    
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
    
    wizardWifiAPListController * destViewController = (wizardWifiAPListController * )[QuickDialogController controllerForRoot:root];
    destViewController.currentDevice = currentDevice;
    destViewController.aplistArray = aplistArray;
    NSLog(@"getAPListCompleted<==");
    [self.navigationController pushViewController:destViewController animated:YES];
}

@end
