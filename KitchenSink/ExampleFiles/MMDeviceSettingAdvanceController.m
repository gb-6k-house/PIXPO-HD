//
//  MMDeviceSettingController.m
//  P4PLive
//
//  Created by Maxwell on 14-7-24.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//
#import "QuickDialog.h"
#import "MMDeviceSettingAdvanceController.h"
#import "MMDeviceSettingWifiController.h"
#import "MMDeviceSettingStorageController.h"
#import "ubiaDeviceManager.h"
#import "ubiaDeviceChannelSettings.h"
#import "ubiaDevice.h"
#import "ubiaClient.h"
#import "Utilities.h"

@interface MMDeviceSettingAdvanceController ()

@end

@implementation MMDeviceSettingAdvanceController
{
    ubiaDeviceChannelSettings * chnSetting;
}

@synthesize currentDevice;

+ (MMDeviceSettingAdvanceController *)initWithDevice:(ubiaDevice *)device {

    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"advanced_settings", nil);
    root.grouped = YES;
    root.controllerName = @"MMDeviceSettingAdvanceController";
    
    ubiaDeviceChannelSettings *chSetting = [device.settings.chnSettings objectAtIndex:0];
    
    QSection *section0 = [[QSection alloc] init];
    
    //section0.title = @"Wifi Config";
    
    QLabelElement *qle_dev_wifi = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"wifi_mgmt", nil) Value: device.settings.wifiSSID];
    qle_dev_wifi.controllerAction = @"onChangeDeviceWifi";
    qle_dev_wifi.key = @"dev_wifi_key";
    
    NSString *storageCapacity;
    if (device.settings.storageCapacity != -1) {
       storageCapacity = [Utilities formatFileSize:device.settings.storageCapacity * 1024 * 1024];
    }else{
        storageCapacity = NSLocalizedString(@"", nil);
    }
    
    QLabelElement *qle_dev_storage = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"storage_mgmt", nil) Value:
                                      storageCapacity];
    
    qle_dev_wifi.key = @"dev_storage_key";
    qle_dev_storage.controllerAction = @"onStorageManagement";
    
    [section0 addElement: qle_dev_storage];
    [section0 addElement:qle_dev_wifi];
    
    QSection *section1 = [[QSection alloc] init];

    NSArray * mirror_array = [NSArray arrayWithObjects:NSLocalizedString(@"normal", nil), NSLocalizedString(@"flip", nil), NSLocalizedString(@"mirror", nil),NSLocalizedString(@"flip_mirror", nil), nil];
    QRadioElement *qle_mirror_flip = [[QRadioElement alloc] initWithItems: mirror_array selected:chSetting.flipMirror title:NSLocalizedString(@"mirror_flip", nil)];
    qle_mirror_flip.key = @"flip_mirror_key";
    qle_mirror_flip.controllerAction = @"onFlipMirrorChange:";
    
    NSArray * envmode_array = [NSArray arrayWithObjects:NSLocalizedString(@"indoor", nil), NSLocalizedString(@"outdoor", nil)/*, NSLocalizedString(@"night_vision", nil)*/, nil];
    QRadioElement *qle_env_mode = [[QRadioElement alloc] initWithItems: envmode_array selected:chSetting.envMode title:NSLocalizedString(@"environment_mode", nil)];
    qle_env_mode.key = @"env_mode_key";
    qle_env_mode.controllerAction = @"onEnvModeChange:";
    
    [section1 addElement:qle_mirror_flip];
    [section1 addElement:qle_env_mode];
    
    QSection *section2 = [[QSection alloc] init];

    NSArray * mdlevel_array = [NSArray arrayWithObjects:NSLocalizedString(@"off", nil), NSLocalizedString(@"low", nil), NSLocalizedString(@"medium", nil),NSLocalizedString(@"high", nil),NSLocalizedString(@"max", nil), nil];
    QRadioElement *qle_motion_sensitivity = [[QRadioElement alloc] initWithItems: mdlevel_array selected:chSetting.mdSensitivity title:NSLocalizedString(@"motion_detection", nil)];
    qle_motion_sensitivity.key = @"motion_sensitivity_key";
    qle_motion_sensitivity.controllerAction = @"onMotionSensitivityChange:";
    
    NSArray * alarm_array = [NSArray arrayWithObjects:NSLocalizedString(@"alarm_silent", nil), NSLocalizedString(@"alarm_audio", nil), NSLocalizedString(@"alarm_vibrate", nil),NSLocalizedString(@"alarm_both", nil), nil];
    QRadioElement *qle_alarm_mode = [[QRadioElement alloc] initWithItems: alarm_array selected:chSetting.alarmMode title:NSLocalizedString(@"alarm_mode", nil)];
    qle_alarm_mode.key = @"alarm_mode_key";
    qle_alarm_mode.controllerAction = @"onAlarmModeChange:";
    
    [section2 addElement:qle_motion_sensitivity];
    [section2 addElement:qle_alarm_mode];
    
    NSArray * record_array = [NSArray arrayWithObjects:NSLocalizedString(@"no_record", nil), NSLocalizedString(@"full_time_record", nil), NSLocalizedString(@"alarm_trigger_record", nil)/*,NSLocalizedString(@"manual_trigger_record", nil)*/, nil];
    
    QRadioElement *qle_record_mode = [[QRadioElement alloc] initWithItems: record_array selected:chSetting.alarmMode title:NSLocalizedString(@"record_mode", nil)];
    qle_record_mode.controllerAction = @"onRecordModeChange:";
    qle_record_mode.key = @"record_mode_key";
    [section2 addElement:qle_record_mode];

    [root addSection:section0];
    [root addSection:section1];
    [root addSection:section2];
    
    MMDeviceSettingAdvanceController * settingController = (MMDeviceSettingAdvanceController * )[QuickDialogController controllerForRoot:root];
    settingController.currentDevice = device;
  
    return settingController;
}

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        
        QAppearance *fieldsAppearance = [self.root.appearance copy];
        
        fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = nil;
    chnSetting = [currentDevice.settings.chnSettings objectAtIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUbicSessionStatusNotification:) name:@"ubiaSessionStatusNotification" object:nil];
        
    [self.quickDialogTableView reloadData];
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

-(void)onStorageManagement{
    NSLog(@"%s ===>",__FUNCTION__);
    MMDeviceSettingStorageController * storagesetting = [MMDeviceSettingStorageController initWithDevice:currentDevice];
    [self.navigationController pushViewController:storagesetting animated:YES];
}

-(void)onChangeDeviceWifi{
    NSLog(@"%s ===>",__FUNCTION__);
    MMDeviceSettingWifiController * wifisetting = [MMDeviceSettingWifiController initWithDevice:currentDevice];
    [self.navigationController pushViewController:wifisetting animated:YES];
}

-(void)onFlipMirrorChange:(QRadioElement *) radioElement{
    NSLog(@"%s ===>[%d]",__FUNCTION__,[radioElement selected]);
    
    if (chnSetting.flipMirror != [radioElement selected]) {
        chnSetting.flipMirror = [radioElement selected];
        [currentDevice setVideoMode];
    }
}

-(void)onEnvModeChange:(QRadioElement *) radioElement{
    NSLog(@"%s ===>[%d]",__FUNCTION__,[radioElement selected]);
    
    if (chnSetting.envMode != [radioElement selected]) {
        chnSetting.envMode = [radioElement selected];
        [currentDevice setDeviceEnvMode];
    }
}

-(void)onMotionSensitivityChange:(QRadioElement *) radioElement{
    NSLog(@"%s ===>[%d]",__FUNCTION__,[radioElement selected]);
    
    if (chnSetting.mdSensitivity != [radioElement selected]) {
        chnSetting.mdSensitivity = [radioElement selected];
        [currentDevice setMDSensitivity];
    }
}

-(void)onAlarmModeChange:(QRadioElement *) radioElement{
    NSLog(@"%s ===>[%d]",__FUNCTION__,[radioElement selected]);
    
    if (chnSetting.alarmMode != [radioElement selected]) {
        chnSetting.alarmMode = [radioElement selected];
        [currentDevice setAlarmMode];
    }
}
-(void)onRecordModeChange:(QRadioElement *) radioElement{
    NSLog(@"%s ===>[%d]",__FUNCTION__,[radioElement selected]);
    
    if (chnSetting.recordMode != [radioElement selected]) {
        chnSetting.recordMode = [radioElement selected];
        [currentDevice setRecordMode:chnSetting.recordMode];
    }
}

- (void)onSelectWifiAP:(QButtonElement *)buttonElement {
    
    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSLog(@"onSelectWifiAP==>");
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"init_camera_step3_txt", nil);
    root.grouped = YES;
    root.controllerName = @"setupDeviceWifiConfigController";
    
    QSection *section = [[QSection alloc] initWithTitle:@"Wifi AP List"];
    section.title = @"Wifi Config";
    //section.headerImage = @"logo";
    section.footer = @"";
    
    QEntryElement *pwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"password", nil) Value:@"" Placeholder:NSLocalizedString(@"password", nil)];
    pwdEntry.bind=@"textValue:password";
    pwdEntry.key = @"password_key";
    pwdEntry.secureTextEntry = true;
    
    [section addElement:pwdEntry];
    [root addSection:section];
    
    QSection *section1 = [[QSection alloc] init];
    QButtonElement *myGetButton = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"init_camera_step3_txt", nil)];
    myGetButton.controllerAction = @"onSetWifiAPConfig:";
    myGetButton.key = @"set_button_key";
    
    [section1 addElement:myGetButton];
    
    [root addSection:section1];
    
    //setupDeviceWifiConfigController * destViewController = (setupDeviceWifiConfigController * )[QuickDialogController controllerForRoot:root];
    
    //[self.navigationController pushViewController:destViewController animated:YES];
}

- (BOOL)QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Should change characters");
    return YES;
}

- (void)QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"[%@] Editing changed to:[%@]", element.title, element.textValue);
}


- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Must return");
    
}



@end
