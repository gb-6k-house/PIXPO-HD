//
//  MMDeviceSettingController.m
//  P4PLive
//
//  Created by Maxwell on 14-7-24.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//
#import "QuickDialog.h"
#import <objc/runtime.h>

#import "MMDeviceSettingStorageController.h"
#import "MMDeviceSettingAdvanceController.h"

#import "ubiaDeviceManager.h"
#import "ubiaWifiApInfo.h"

#import "ubiaDevice.h"
#import "ubiaClient.h"
#import "Utilities.h"

extern char * ioctrlRecvBuf;

@interface MMDeviceSettingStorageController ()

@end

@implementation MMDeviceSettingStorageController{
    ubiaWifiApInfo * selectedAPInfo;
    NSMutableArray * aplistArray;
    NSMutableArray * apssidlist;
    BOOL gotWifiInfo;
}

@synthesize currentDevice;

+ (MMDeviceSettingStorageController *)initWithDevice:(ubiaDevice *)device {

    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"settingtitle", nil);
    root.grouped = YES;
    root.controllerName = @"MMDeviceSettingStorageController";
    
    QSection *section0 = [[QSection alloc]init];

    
    QLabelElement *qle_total_space = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"total_space", nil) Value:[Utilities formatFileSize:device.settings.storageCapacity * 1024* 1024]];
    QLabelElement *qle_free_space = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"free_space", nil) Value:[Utilities formatFileSize:device.settings.storageFree * 1024 * 1024]];
    
    [section0 addElement:qle_total_space];
    [section0 addElement:qle_free_space];
    
    QSection *section1 = [[QSection alloc] init];
    
    //section1.title = NSLocalizedString(@"device_info", nil);
    
    QButtonElement *qle_format_btn = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"format_storage_btn", nil)];
    qle_format_btn.appearance.buttonAlignment = NSTextAlignmentCenter;
    qle_format_btn.controllerAction = @"onFormatStorage:";
    qle_format_btn.key = @"format_btn_key";
    [section1 addElement:qle_format_btn];
    
    [root addSection:section0];
    [root addSection:section1];

    MMDeviceSettingStorageController * settingController = (MMDeviceSettingStorageController * )[QuickDialogController controllerForRoot:root];
    settingController.currentDevice = device;
  
    return settingController;
}

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        gotWifiInfo = FALSE;

    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUbicSessionStatusNotification:) name:@"ubiaSessionStatusNotification" object:nil];
   
    [self.root elementWithKey:@"format_btn_key"].appearance = self.root.appearance.copy;
    [self.root elementWithKey:@"format_btn_key"].appearance.backgroundColorEnabled = [Utilities btnBackgroundColor];
    [self.root elementWithKey:@"format_btn_key"].appearance.entryTextColorEnabled = [Utilities textColor];
    [self.root elementWithKey:@"format_btn_key"].appearance.buttonAlignment = NSTextAlignmentCenter;
    
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

- (void)onFormatStorage:(QButtonElement *)buttonElement {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                            message:NSLocalizedString(@"note_for_sure_format_storage", nil)
                                            delegate:self
                                            cancelButtonTitle:NSLocalizedString(@"format_storage_btn", nil)
                                            otherButtonTitles:NSLocalizedString(@"close_btn", nil), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
// An alert view delegate callback that's called when the alert is dismissed.
// As we only use the alert view to display errors, we also respond to this
// by failing (calling -_clientIdentityResolvedWithIdentity: with nil).
{
#pragma unused(alertView)
#pragma unused(buttonIndex)
    //assert(alertView == self.alertView);
    //assert(buttonIndex == 0);
    if (buttonIndex == 0) {
        NSLog(@"Sure to format");
        [currentDevice formatStorage:0];
    }else{
        NSLog(@"cancel to format");
    }
    
}


@end
