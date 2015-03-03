//
//  MMDeviceSettingController.m
//  P4PLive
//
//  Created by Maxwell on 14-7-24.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//
#import "QuickDialog.h"
#import "MMDeviceSettingController.h"
#import "MMDeviceSettingBasicController.h"
#import "MMDeviceSettingAdvanceController.h"

#import "ubiaDeviceManager.h"

#import "ubiaDevice.h"
#import "ubiaClient.h"

@interface MMDeviceSettingController ()

@end

@implementation MMDeviceSettingController{
    BOOL hasShowAlert;
}
@synthesize currentDevice;

+ (MMDeviceSettingController *)initWithDevice:(ubiaDevice *)device {

    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"settingtitle", nil);
    root.grouped = YES;
    root.controllerName = @"MMDeviceSettingController";
    
    QSection *section0 = [[QSection alloc]init];
    section0.title = NSLocalizedString(@"basic_info", nil);
    QLabelElement * dev_name = [[QLabelElement alloc] initWithTitle: NSLocalizedString(@"name", nil) Value:device.name];
    dev_name.key = @"dev_name_qlabel";
    QLabelElement * dev_uid  = [[QLabelElement alloc] initWithTitle: @"UID" Value:device.uid];
    dev_uid.key = @"dev_uid_qlabel";
    
    [section0 addElement:dev_name];
    [section0 addElement:dev_uid];
    
    //QSection *section1 = [[QSection alloc] init];
    
    //section1.title = NSLocalizedString(@"device_info", nil);
    
    //QLabelElement * dev_info = [[QLabelElement alloc] initWithTitle: NSLocalizedString(@"device_info", nil) Value:nil];
    QLabelElement * dev_model = [[QLabelElement alloc] initWithTitle: NSLocalizedString(@"model", nil) Value:nil];
    dev_model.key = @"dev_model_qlabel";
    
    QLabelElement * dev_firmware = [[QLabelElement alloc] initWithTitle: NSLocalizedString(@"firmware_version", nil) Value:nil];
    dev_firmware.key = @"dev_firmware_qlabel";
    
    QLabelElement * dev_vendor = [[QLabelElement alloc] initWithTitle: NSLocalizedString(@"vendor", nil) Value:nil];
    dev_vendor.key = @"dev_vendor_qlabel";
    
    [section0 addElement:dev_model];
    [section0 addElement:dev_firmware];
    [section0 addElement:dev_vendor];
    
    QSection *section2 = [[QSection alloc] init];
    section2.title = NSLocalizedString(@"configuration_info", nil);
    
    QLabelElement * qle_basic_setting = [[QLabelElement alloc] initWithTitle: NSLocalizedString(@"basic_settings", nil) Value:nil];
    qle_basic_setting.controllerAction = @"onBasicSetting";
    
    QLabelElement * qle_advance_setting = [[QLabelElement alloc] initWithTitle: NSLocalizedString(@"advanced_settings", nil) Value:nil];
    qle_advance_setting.controllerAction = @"onAdvanceSetting";

    [section2 addElement:qle_basic_setting];
    [section2 addElement:qle_advance_setting];
    
    [root addSection:section0];
    //[root addSection:section1];
    [root addSection:section2];
    
    MMDeviceSettingController * settingController = (MMDeviceSettingController * )[QuickDialogController controllerForRoot:root];
    settingController.currentDevice = device;
  
    return settingController;
}

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        
        QAppearance *fieldsAppearance = [self.root.appearance copy];
        
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
    
    QLabelElement * dev_name_qlabel = (QLabelElement *)[self.root elementWithKey:@"dev_name_qlabel"];
    
    [dev_name_qlabel setValue:currentDevice.name];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUbicSessionStatusNotification:) name:@"ubiaSessionStatusNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceIOCtrlComplete:) name:@"ubiaDeviceIOCtrlComplete" object:nil];
    
    if ([currentDevice.deviceManager getDeviceInfo]){
        [self loading:YES];
    }
    
    [self.quickDialogTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

-(void)updateDeviceInfo{
    
    QLabelElement * model = (QLabelElement *)[self.root elementWithKey:@"dev_model_qlabel"];
    QLabelElement * version = (QLabelElement *)[self.root elementWithKey:@"dev_firmware_qlabel"];
    QLabelElement * vendor = (QLabelElement *)[self.root elementWithKey:@"dev_vendor_qlabel"];
    
    [model setValue:currentDevice.settings.model];
    [version setValue:currentDevice.settings.version];
    [vendor setValue:currentDevice.settings.vendor];
    [self.quickDialogTableView reloadData];
    
    [self loading:NO];
    
    if (FALSE == hasShowAlert) {
        hasShowAlert = TRUE;
        if (currentDevice.settings.storageCapacity == -1) {
            //Notify
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"notify_format_storage", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"format_storage_btn", nil)
                                                  otherButtonTitles:NSLocalizedString(@"close_btn", nil),nil
                                  ];
            [alert show];
        }else if(currentDevice.settings.storageCapacity == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:NSLocalizedString(@"notify_no_storage", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"close_btn", nil)
                                                  otherButtonTitles:nil,nil
                                  ];
            [alert show];
        }
    }
    
}
-(void) handleDeviceIOCtrlComplete:(NSNotification *)note{
    [self performSelectorOnMainThread:@selector(updateDeviceInfo) withObject:self waitUntilDone:NO];
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

-(void)onBasicSetting{
    NSLog(@"%s ===>",__FUNCTION__);
    MMDeviceSettingBasicController * basicsetting = [MMDeviceSettingBasicController initWithDevice:currentDevice];
    [self.navigationController pushViewController:basicsetting animated:YES];
}

-(void)onAdvanceSetting{
    NSLog(@"%s ===>",__FUNCTION__);
    MMDeviceSettingAdvanceController * advsetting = [MMDeviceSettingAdvanceController initWithDevice:currentDevice];
    [self.navigationController pushViewController:advsetting animated:YES];
}

@end
