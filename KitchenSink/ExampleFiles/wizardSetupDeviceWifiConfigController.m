

#import "MMAppDelegate.h"
#import "wizardSetupDeviceWifiConfigController.h"
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

@interface wizardSetupDeviceWifiConfigController (){
    int retry_connect;

}

- (void)onSetWifiAPConfig:(QButtonElement *)buttonElement;

@end

@implementation wizardSetupDeviceWifiConfigController
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
    
    [self loading:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
