//
//  ubiaDeviceSettings.h
//  P4PCamLive
//
//  Created by Maxwell on 13-5-15.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "include/AVIOCTRLDEFs.h"
#import "include/AVFRAMEINFO.h"

#import "ubiaDeviceChannelSettings.h"

@interface ubiaDeviceSettings : NSObject

/*
 // Defined bits are listed below:
 //----------------------------------------------
 // bit		fuction
 // 0		Audio in, from Device to Mobile
 // 1		Audio out, from Mobile to Device
 // 2		PT function
 // 3		Event List function
 // 4		Play back function (require Event List function)
 // 5		Wi-Fi setting function
 // 6		Event Setting Function
 // 7		Recording Setting function
 // 8		SDCard formattable function
 // 9		Video flip function
 // 10		Environment mode
 // 11		Multi-stream selectable
 // 12		Audio out encoding format
 */
@property (nonatomic, assign) UInt32 serviceType;

@property (nonatomic, strong) NSString    *wifiSSID;
@property (nonatomic, strong) NSString    *wifiPassword;
@property (nonatomic, assign) ENUM_AP_MODE wifiApMode;
@property (nonatomic, assign) ENUM_AP_ENCTYPE wifiApEncType;
@property (nonatomic) UInt8             wifiSignal;
@property (nonatomic) UInt8             wifiStatus;

@property (nonatomic, assign) int totalChannels; //1,2,4,8,16, total nums support by the device
@property (nonatomic, strong) NSMutableArray * chnSettings;
@property (nonatomic, strong) NSString    *model;
@property (nonatomic, strong) NSString    *vendor;
@property (nonatomic, strong) NSString    *version;
@property (nonatomic) UInt32    storageCapacity; /*MBytes, -1=unformat*/
@property (nonatomic) UInt32    storageFree; /*MBytes*/
@property (nonatomic) UInt32    lastUpdateDeviceInfo; /*上一次更新设备信息时间*/

@end
