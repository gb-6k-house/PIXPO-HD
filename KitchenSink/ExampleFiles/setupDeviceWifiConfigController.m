

#import "MMAppDelegate.h"
#import "setupDeviceWifiConfigController.h"
#import "easyBindDeviceController.h"
#import "LoginInfo.h"
#import "SVHTTPRequest.h"

#import "ubiaRestClient.h"
#import "ubiaDevice.h"
#import "ubiaClient.h"
#import "ubiaWifiApInfo.h"

#import "ubiaDeviceList.h"
#import "ubiaDeviceManager.h"


extern char * ioctrlRecvBuf;
extern char * ioctrlSendBuf;

@interface setupDeviceWifiConfigController (){
    int retry_connect;

}

- (void)onSetWifiAPConfig:(QButtonElement *)buttonElement;

@end

@implementation setupDeviceWifiConfigController
@synthesize currentDevice;
@synthesize selectedAPInfo;

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
        
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUbicSessionStatusNotification:) name:@"ubiaSessionStatusNotification" object:nil];
    retry_connect = 0;
    [self.quickDialogTableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) handleUbicSessionStatusNotification:(NSNotification *)note{
    int sessionID = [[[note userInfo] objectForKey:@"ubicSessionID"] intValue];
    int errCode = [[[note userInfo] objectForKey:@"ubicErrorCode"] intValue];
    
    [self loading:NO];
    
    if(IOTCER_NoERROR == errCode){
        NSLog(@"receive Connect sucess");
        
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
    
	// wait for 3 seconds before starting the thread, you don't have to do that. This is just an example how to stop the NSThread for some time
    //[NSThread sleepForTimeInterval:3];
    
#if 1
    int retry = 0;
    int retVal = 0;
    
    BACKEND_IOCTL_MSG * pIOMsg = (BACKEND_IOCTL_MSG *) ioctrlRecvBuf;
    
    LoginInfo *info = [[LoginInfo alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:info];
    
    [currentDevice setWIFIAPInfo:selectedAPInfo withKey:info.password];
    
    currentDevice.isWaitIOResp = true;
    
    while (currentDevice.isWaitIOResp) {
        
        if(currentDevice.isPendingIOControl){
            [NSThread sleepForTimeInterval:0.5];
        }else{

            retVal = [currentDevice.client recvIOControl:currentDevice.client.avid withTimeout:2000 withbuf:ioctrlRecvBuf];
            if (retVal > 0){
                if(pIOMsg->cmdType == IOTYPE_USER_IPCAM_SETWIFI_RESP){

                    SMsgAVIoctrlSetWifiResp * pRsp = (SMsgAVIoctrlSetWifiResp *)(pIOMsg + 1);
                    if(0 == pRsp->result){


                    }
                    
                    break;
                }
                
            }else{
                if (AV_ER_TIMEOUT == retVal || AV_ER_DATA_NOREADY == retVal) {
                    [currentDevice setWIFIAPInfo:selectedAPInfo withKey:info.password];                    retry++;
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
    [self performSelectorOnMainThread:@selector(onSetWifiAPConfigCompleted) withObject:nil waitUntilDone:NO];
}


- (void)onSetWifiAPConfig:(QButtonElement *)buttonElement {
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self loading:YES];
    LoginInfo *info = [[LoginInfo alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:info];
    [NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:NO];
}

- (void)onSetWifiAPConfigCompleted{
    //
    [currentDevice stopclient];
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self loading:NO];
    if (appDelegate != nil && appDelegate.deviceManager !=nil
        && appDelegate.deviceManager.restClient != nil) {
        
        ubiaDevice * device = nil;
        
        if (appDelegate.deviceManager.restClient.myDeviceList != nil) {
            device = [appDelegate.deviceManager.restClient.myDeviceList getDeviceByUID:currentDevice.uid];
        }
        if (device == nil) {
            [self easySetupCameraBinding];
        }else{
            //device already in mydevicelist
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    
}

- (void)easySetupCameraBinding {
    
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"easy_setup_step3_txt", nil);
    root.grouped = YES;
    root.controllerName = @"easyBindDeviceController";
    
    //QSection *section0 = [[QSection alloc] initWithTitle:@"Wifi AP List"];
    //section0.title = NSLocalizedString(@"easy_selected_uid_txt", nil);
    //section.headerImage = @"logo";
    //section0.footer = @"";
    
    //QEntryElement *uidEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"uid", nil) Value:deviceUID Placeholder:NSLocalizedString(@"uid", nil)];
    
    //uidEntry.key = @"device_uid";
    //uidEntry.bind=@"textValue:uid";
    
    //[section0 addElement: uidEntry];
    //[root addSection: section0];
    
    QSection *section1 = [[QSection alloc] init];
    section1.title = NSLocalizedString(@"easy_setup_device_auth_info", nil);
    //section.headerImage = @"logo";
    //section1.footer = @"";
    
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
    //section.headerImage = @"logo";
    //section2.footer = @"";
    
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
    
    easyBindDeviceController * destViewController = (easyBindDeviceController * )[QuickDialogController controllerForRoot:root];
    
    destViewController.deviceUID = currentDevice.uid;
    
    [self.navigationController pushViewController:destViewController animated:YES];
}


+ (QRootElement *)createDetailsForm {
    QRootElement *details = [[QRootElement alloc] init];
    details.presentationMode = QPresentationModeModalForm;
    details.title = @"Details";
    details.controllerName = @"AboutController";
    details.grouped = YES;
    QSection *section = [[QSection alloc] initWithTitle:@"Information"];
    [section addElement:[[QTextElement alloc] initWithText:@"Here's some more info about this app."]];
    [details addSection:section];

    return details;
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
