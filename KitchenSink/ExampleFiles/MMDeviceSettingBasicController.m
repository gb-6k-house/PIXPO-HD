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

#import "ubiaDeviceManager.h"
#import "ubiaRestClient.h"
#import "ubiaDevice.h"
#import "ubiaClient.h"

#import "Utilities.h"

@interface MMDeviceSettingBasicController ()

@end

@implementation MMDeviceSettingBasicController
@synthesize currentDevice;

+ (MMDeviceSettingBasicController *)initWithDevice:(ubiaDevice *)device {

    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"settingtitle", nil);
    root.grouped = YES;
    root.controllerName = @"MMDeviceSettingBasicController";
    
    QSection *section0 = [[QSection alloc]init];
    section0.title = NSLocalizedString(@"basic_info", nil);
    
    QEntryElement *qle_dev_pwd = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"security_code", nil) Value:@"" Placeholder:NSLocalizedString(@"security_code_placeholder", nil)];
    
    qle_dev_pwd.key = @"dev_pwd_key";
    
    //qle_dev_pwd.controllerAction=@"ChangeDevicePassword:";
    
    QEntryElement *qle_dev_name = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"modify_name", nil) Value:@"" Placeholder:NSLocalizedString(@"modify_name_placeholder", nil)];
    
    qle_dev_name.enablesReturnKeyAutomatically = YES;
    qle_dev_name.key = @"dev_name_key";
    
    //qle_dev_name.controllerAction=@"ChangeDeviceName:";
    
    [section0 addElement:qle_dev_pwd];
    [section0 addElement:qle_dev_name];

    QSection *section1 = [[QSection alloc] init];
    QButtonElement *btn_apply = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"apply", nil)];
    btn_apply.key = @"btn_apply_key";
    btn_apply.controllerAction =@"onApplyBtn";
    [section1 addElement:btn_apply];
    
    [root addSection:section0];
    [root addSection:section1];

    MMDeviceSettingBasicController * settingController = (MMDeviceSettingBasicController * )[QuickDialogController controllerForRoot:root];
    settingController.currentDevice = device;
  
    return settingController;
}

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        
        QAppearance *fieldsAppearance = [self.root.appearance copy];
        
        //fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
        
        fieldsAppearance.valueAlignment = NSTextAlignmentLeft;
        [self.root elementWithKey:@"dev_pwd_key"].appearance = fieldsAppearance;
        
        [self.root elementWithKey:@"dev_name_key"].appearance = fieldsAppearance;
        
        [self.root elementWithKey:@"btn_apply_key"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"btn_apply_key"].appearance.backgroundColorEnabled = [Utilities btnBackgroundColor];
        [self.root elementWithKey:@"btn_apply_key"].appearance.entryTextColorEnabled = [Utilities textColor];
        [self.root elementWithKey:@"btn_apply_key"].appearance.buttonAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
    
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

-(void)onApplyBtn{
    QEntryElement * dev_pwd = (QEntryElement *)[self.root elementWithKey:@"dev_pwd_key"];
    QEntryElement * dev_name = (QEntryElement *)[self.root elementWithKey:@"dev_name_key"];
   
    NSString * newPassword = [dev_pwd textValue];
    NSString * newName = [dev_name textValue];
    
    if (FALSE == [newName isEqualToString:currentDevice.name]) {
        currentDevice.name = newName;
        [currentDevice.deviceManager.restClient device_op:currentDevice operate:DEVICE_OP_MODIFY];
    }
    
    if (FALSE == [newPassword isEqualToString:@""] && FALSE == [newPassword isEqualToString:currentDevice.client.password])
    {

        [currentDevice setPassword:newPassword withOldPassword:currentDevice.client.password];
        
        UIAlertView* mes=[[UIAlertView alloc] initWithTitle: nil
                                                    message: NSLocalizedString(@"device_password_change_ok", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [mes show];
    }
}

@end
