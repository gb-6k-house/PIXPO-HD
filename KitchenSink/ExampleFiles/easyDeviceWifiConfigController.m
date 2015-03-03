

#import "MMAppDelegate.h"
#import "easyDeviceWifiConfigController.h"
#import "easyBindDeviceController.h"
#import "WifiSetupInfo.h"


#import "ubiaRestClient.h"
#import "ubiaDeviceList.h"
#import "ubiaDevice.h"
#import "ubiaDeviceManager.h"

#import "ubiaClient.h"
#import "ubiaWifiApInfo.h"

#import "WiFiDirectConfig.h"

#import <SystemConfiguration/CaptiveNetwork.h>



@interface easyDeviceWifiConfigController (){
    int configstatus;
    short srcport;
    ubiaDeviceList * responseDevlist;
    ubiaRestClient * restClient;
}
@end

@implementation easyDeviceWifiConfigController
@synthesize deviceUID, ssid, wifiKey;
@synthesize selectedAPInfo;


#if 1
- (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
     NSDictionary * info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return info;
}
#endif
- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        //self.root.appearance.tableGroupedBackgroundColor =  [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];
        ((QEntryElement *)[self.root elementWithKey:@"ap_ssid"]).delegate = self;
        
        QAppearance *fieldsAppearance = [self.root.appearance copy];

        fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
        
        [self.root elementWithKey:@"ap_key"].appearance = fieldsAppearance;
        
        [self.root elementWithKey:@"set_button_key"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"set_button_key"].appearance.backgroundColorEnabled = [UIColor colorWithRed:0.4 green:0.8104 blue:0.7991 alpha:1.0000];
  
        [self.root elementWithKey:@"set_button_key"].appearance.buttonAlignment  = NSTextAlignmentCenter;
        responseDevlist = [[ubiaDeviceList alloc] init];
        MMAppDelegate * appDelegate = (MMAppDelegate *) [[UIApplication  sharedApplication] delegate];
        restClient = appDelegate.deviceManager.restClient;
        
        
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
#if 1
    NSDictionary *ifs = [self fetchSSIDInfo];
    //ssid = [[ifs objectForKey:@"SSID"] lowercaseString];
    ssid = [ifs objectForKey:@"SSID"];
    
    QEntryElement *ssidEntry = (QEntryElement *)[self.root elementWithKey:@"ap_ssid"];
    ssidEntry.textValue = ssid;
#endif
    
    [self.quickDialogTableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    WDC_StopConfig();
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void) viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWDCStatusNotification:) name:@"WDCStatusNotification" object:nil];
}

-(void) handleWDCStatusNotification:(NSNotification *)note{
    NSString *responseUID = [[note userInfo] objectForKey:@"responseID"];
    int errCode = [[[note userInfo] objectForKey:@"wdcErrorCode"] intValue];
    
    if(IOTCER_NoERROR == errCode){
        NSLog(@"handleWDCStatusNotification receive [UID:%@] WDC sucess",responseUID);
    }
    deviceUID = responseUID;
    //[responseDevlist addDevice:responseUID];
    [self performSelectorOnMainThread:@selector(onSetWifiAPConfigCompleted) withObject:nil waitUntilDone:NO];
    
}


void easyDeviceConfigCB(int status,char * uid){

    //NSLog(@"ubiaSessionStatusCB UID: SID:%d status change to %d",nIOTCSessionID,nErrorCode);

    NSNumber *errorCode = [[NSNumber alloc] initWithInt:status];
    NSString *responseUID = [NSString stringWithUTF8String:uid];
    
    NSArray *myKeys = [NSArray arrayWithObjects:@"responseID",@"wdcErrorCode",nil];
    NSArray *myObjects = [NSArray arrayWithObjects: responseUID,errorCode,nil];
    
    NSDictionary *myDictionary = [NSDictionary dictionaryWithObjects:myObjects forKeys:myKeys];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"WDCStatusNotification" object:nil userInfo: myDictionary];
    
}


- (void)onSetWifiAPConfig:(QButtonElement *)buttonElement {

    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
 
    WifiSetupInfo *info = [[WifiSetupInfo alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:info];
    
    if (info.uid != nil && [info.uid length] > 0) {
        //update user input
        deviceUID = info.uid;
    }
    if (info.ssid != nil && [info.ssid length] > 0) {
        //update user input
        ssid = info.ssid;
    }
    wifiKey = info.key;
    
    int total_len = 1 + [ssid length] + 1 + [wifiKey length] + 2 + 4;
    
    if (wifiKey == nil || [wifiKey length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                            message:NSLocalizedString(@"easy_input_wifi_key_txt", nil)
                                            delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (ssid == nil || [ssid length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                            message:NSLocalizedString(@"wifi_ssid_no_input", nil)
                                            delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    if (total_len > 0x7f) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                            message:NSLocalizedString(@"too_many_bytes", nil)
                                            delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    [self loading:YES];
    
    WDC_StartConfigWithCB(NULL, [ssid UTF8String], [wifiKey UTF8String], easyDeviceConfigCB);
    
    //[NSThread detachNewThreadSelector:@selector(sendConfigtoCamera) toTarget:self withObject:NO];
    //[NSThread detachNewThreadSelector:@selector(runFeedbackCheckJob) toTarget:self withObject:NO];
    
}


- (void)onSetWifiAPConfigCompleted{
    //
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self loading:NO];
    if (appDelegate != nil && appDelegate.deviceManager !=nil
            && appDelegate.deviceManager.restClient != nil) {
        
        ubiaDevice * device = nil;
        
        if (appDelegate.deviceManager.restClient.myDeviceList != nil) {
            device = [appDelegate.deviceManager.restClient.myDeviceList getDeviceByUID:deviceUID];
        }
        
        if (device == nil) {
            //this a new device
            [self easySetupCameraBinding];
        }else{
            //device already in mydevicelist
            [self.navigationController popToRootViewControllerAnimated:YES];
            [device stopclient];
            [device startclient];
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
    
    //destViewController.toBindDeviceList = responseDevlist;
    destViewController.deviceUID = deviceUID;
    //[responseDevlist getDeviceByIndex:0].uid;

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
