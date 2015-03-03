//
//  MMDeviceSettingController.h
//  P4PLive
//
//  Created by Maxwell on 14-7-24.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "QuickDialogController.h"

@class ubiaDevice;

@interface MMDeviceSettingBasicController : QuickDialogController <QuickDialogEntryElementDelegate>

@property (nonatomic,strong) ubiaDevice * currentDevice;

+ (MMDeviceSettingBasicController *)initWithDevice:(ubiaDevice *)device;

@end
