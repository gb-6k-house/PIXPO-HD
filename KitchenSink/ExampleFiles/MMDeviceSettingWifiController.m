//
//  MMDeviceSettingController.m
//  P4PLive
//
//  Created by Maxwell on 14-7-24.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//
#import "QuickDialog.h"
#import <objc/runtime.h>

#import "MMDeviceSettingWifiController.h"
#import "MMDeviceSettingAdvanceController.h"

#import "ubiaDeviceManager.h"
#import "ubiaWifiApInfo.h"

#import "ubiaDevice.h"
#import "ubiaClient.h"
#import "Utilities.h"

extern char * ioctrlRecvBuf;

@interface MMDeviceSettingWifiController ()

@end

@implementation MMDeviceSettingWifiController{
    ubiaWifiApInfo * selectedAPInfo;
    NSMutableArray * aplistArray;
    NSMutableArray * apssidlist;
    BOOL gotWifiInfo;
}

@synthesize currentDevice;

+ (MMDeviceSettingWifiController *)initWithDevice:(ubiaDevice *)device {

    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"settingtitle", nil);
    root.grouped = YES;
    root.controllerName = @"MMDeviceSettingWifiController";
    
    QSection *section0 = [[QSection alloc]init];
    
#if 0
    QRadioElement *qle_ssid = [[QRadioElement alloc] initWithTitle: NSLocalizedString(@"ap_ssid", nil) Value:nil];
    qle_ssid.key = @"ssid_key";
    qle_ssid.controllerAction = @"onSelectWifiAP:";
    
    QLabelElement * qle_rssi = [[QLabelElement alloc] initWithTitle: NSLocalizedString(@"ap_rssi", nil) Value:nil];
    qle_rssi.key = @"rssi_key";
    QLabelElement * qle_secmode = [[QLabelElement alloc] initWithTitle: NSLocalizedString(@"ap_secmode", nil) Value:nil];
    qle_secmode.key = @"secmode_key";
    
    [section0 addElement:qle_ssid];
    [section0 addElement:qle_rssi];
    [section0 addElement:qle_secmode];
#endif
    
    QSection *section1 = [[QSection alloc] init];
    
    //section1.title = NSLocalizedString(@"device_info", nil);
    
    QEntryElement *qle_wifi_password = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"ap_key", nil) Value:@"" Placeholder:NSLocalizedString(@"ap_pwd_placeholder", nil)];
    
    qle_wifi_password.key = @"wifi_password_key";
    qle_wifi_password.secureTextEntry = YES;
    QBooleanElement *show_pwd_qle = [[QBooleanElement alloc] initWithTitle:NSLocalizedString(@"ap_showpwd", nil) BoolValue:false];
    show_pwd_qle.bind=@"boolValue:bool";
    show_pwd_qle.key = @"qle_show_pwd_key";
    //show_pwd_qle.onImage = [UIImage imageNamed:@"imgOn"];
    //show_pwd_qle.offImage = [UIImage imageNamed:@"imgOff"];
    show_pwd_qle.controllerAction = @"onShowPassword:";
    
    [section1 addElement:qle_wifi_password];
    [section1 addElement:show_pwd_qle];

    QSection *section2 = [[QSection alloc] init];
    QButtonElement * qle_apply_btn = [[QButtonElement alloc] initWithTitle: NSLocalizedString(@"apply_button_txt", nil) Value:nil];
    
    qle_apply_btn.appearance.buttonAlignment = NSTextAlignmentCenter;
    qle_apply_btn.controllerAction = @"onSetWifiAPConfig:";
    qle_apply_btn.key = @"apply_btn_key";
    
    [section2 addElement:qle_apply_btn];
    
    [root addSection:section0];
    [root addSection:section1];
    [root addSection:section2];
    
    MMDeviceSettingWifiController * settingController = (MMDeviceSettingWifiController * )[QuickDialogController controllerForRoot:root];
    settingController.currentDevice = device;
  
    return settingController;
}

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        gotWifiInfo = FALSE;
        //QAppearance *fieldsAppearance = [self.root.appearance copy];
        
        //fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
        
        //fieldsAppearance.valueAlignment = NSTextAlignmentLeft;
        //[self.root elementWithKey:@"dev_uid_qlabel"].appearance = fieldsAppearance;
        
        //[self.root elementWithKey:@"dev_name_qlabel"].appearance = fieldsAppearance;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUbicSessionStatusNotification:) name:@"ubiaSessionStatusNotification" object:nil];
    if (FALSE == gotWifiInfo) {
        [self loading:YES];
        [NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
    }
    
    [self.root elementWithKey:@"apply_btn_key"].appearance = self.root.appearance.copy;
    [self.root elementWithKey:@"apply_btn_key"].appearance.backgroundColorEnabled = [Utilities btnBackgroundColor];
    [self.root elementWithKey:@"apply_btn_key"].appearance.entryTextColorEnabled = [Utilities textColor];
    [self.root elementWithKey:@"apply_btn_key"].appearance.buttonAlignment = NSTextAlignmentCenter;
    
    //[self.quickDialogTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
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
            [currentDevice startclient];
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
                    
                    SMsgAVIoctrlListWifiApResp * pRsp = (SMsgAVIoctrlListWifiApResp *)(pIOMsg + 1);
                    if(pRsp->number > 0 && pRsp->number < 32){
                        aplistArray = [[NSMutableArray alloc] initWithCapacity:pRsp->number];
                        for(int i=0; i < pRsp->number; i++)
                        {
                            ubiaWifiApInfo * apInfo = [[ubiaWifiApInfo alloc] init];
                            apInfo.ssid = [NSString stringWithUTF8String:pRsp->stWifiAp[i].ssid];
                            apInfo.mode = pRsp->stWifiAp[i].mode;
                            apInfo.enctype = pRsp->stWifiAp[i].enctype;
                            apInfo.signal = pRsp->stWifiAp[i].signal;
                            apInfo.status = pRsp->stWifiAp[i].status;
                            [aplistArray addObject:apInfo];
                            NSLog(@"SSID:[%@] RSSI:[%d%%] STATUS:[%d]",apInfo.ssid,apInfo.signal,apInfo.status);
                        }
                    }
                    [self performSelectorOnMainThread:@selector(getAPListCompleted) withObject:nil waitUntilDone:NO];
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

- (void)getAPListCompleted {
    NSLog(@"getAPListCompleted==>");

    [self loading:NO];
    gotWifiInfo = TRUE;
    
    QRadioElement * qle_ssid_list = (QRadioElement *) [[self root] elementWithKey:@"ssid_key"];
    apssidlist = [[NSMutableArray alloc] initWithCapacity:[aplistArray count]];
    int i = 0, connected = 0;
    for (i = 0; i < [aplistArray count]; i++) {
        ubiaWifiApInfo * apInfo = [aplistArray objectAtIndex:i];
        if (apInfo.status == 1) {
            connected = i;
            [qle_ssid_list setValue:apInfo.ssid];
        }
        [apssidlist addObject:apInfo.ssid];
    }
    
#if  1
    QSection * section0 = [[self.root sections] objectAtIndex:0];
    
    QRadioElement *qle_ssid = [[QRadioElement alloc] initWithItems: apssidlist selected:0 title:NSLocalizedString(@"ap_ssid", nil)];
    
    qle_ssid.key = @"ssid_key";
    qle_ssid.controllerAction = @"onSelectWifiAP:";

    ubiaWifiApInfo * apInfo  = [aplistArray objectAtIndex:connected];

    QLabelElement * qle_rssi = [[QLabelElement alloc] initWithTitle: NSLocalizedString(@"ap_rssi", nil) Value:[NSString stringWithFormat:@"%d%%",apInfo.signal]];
    qle_rssi.key = @"rssi_key";
    QLabelElement * qle_secmode = [[QLabelElement alloc] initWithTitle: NSLocalizedString(@"ap_secmode", nil) Value:nil];
    qle_secmode.key = @"secmode_key";
    
    if (apInfo.enctype != 1) {
        [qle_secmode setValue:[NSString stringWithFormat:@"SEC"]];
    }else{
        [qle_secmode setValue:[NSString stringWithFormat:@"NONE"]];
    }
    
    [qle_ssid_list setSelected:0];
    
    [section0 addElement:qle_ssid];
    
    [section0 addElement:qle_rssi];
    [section0 addElement:qle_secmode];
    
    [qle_ssid_list setItems:apssidlist];
    
    qle_ssid_list.parentSection = section0;

#endif
    
    //NSMutableDictionary *dataDict = [NSMutableDictionary new];
    //[dataDict setValue:@"Obj Date" forKey:@"ssid_key"];

    //[self.root bindToObject:dataDict];
    [self.quickDialogTableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,2)] withRowAnimation:UITableViewRowAnimationFade];
    
    //[self.quickDialogTableView reloadCellForElements:qle_ssid_list, nil];
    
    //[self.quickDialogTableView reloadData];
    NSLog(@"getAPListCompleted<==");

}


- (void)onSetWifiAPConfig:(QButtonElement *)buttonElement {
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    QRadioElement * qle_ssid_list = (QRadioElement *)[self.root elementWithKey:@"ap_ssid"];
    
    QEntryElement * qle_wifi_password = (QEntryElement *)[self.root elementWithKey:@"wifi_password_key"];
    NSString * password = [qle_wifi_password textValue];
    
    if (password && (FALSE == [password isEqualToString:@""])) {
        //[self loading:YES];
        [currentDevice setWIFIAPInfo:[aplistArray objectAtIndex:[qle_ssid_list selected]] withKey:password];
    }
    //[NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:NO];
}

- (void)onSelectWifiAP:(QRadioElement *)radioElement {
    
    QLabelElement * qle_rssi = (QLabelElement *)[self.root elementWithKey:@"rssi_key"];
    QLabelElement * qle_secmode = (QLabelElement *)[self.root elementWithKey:@"secmode_key"];
    
    int selected = [radioElement selected];
    ubiaWifiApInfo * apInfo  = [aplistArray objectAtIndex:selected];
    
    [qle_rssi setValue:[NSString stringWithFormat:@"%d%%",apInfo.signal]];
    
    if (apInfo.enctype != 1) {
        [qle_secmode setValue:[NSString stringWithFormat:@"SEC"]];
    }else{
        [qle_secmode setValue:[NSString stringWithFormat:@"NONE"]];
    }
   [self.quickDialogTableView reloadCellForElements:qle_rssi,qle_secmode, nil];

}
- (void)onShowPassword:(QBooleanElement *)boolElement {
    QEntryElement * qle_wifi_password = (QEntryElement *)[self.root elementWithKey:@"wifi_password_key"];

    if ([boolElement boolValue]) {
        qle_wifi_password.secureTextEntry = NO;
    }else{
        qle_wifi_password.secureTextEntry = YES;
    }
    [self.quickDialogTableView reloadCellForElements:qle_wifi_password, nil];
}

- (BOOL)QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Should change characters");
    return YES;
}

- (void)QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Editing changed");
}


- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Must return");
    
}

@end
