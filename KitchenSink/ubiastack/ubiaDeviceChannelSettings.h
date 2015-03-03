//
//  ubiaDeviceChannelSettings.h
//  P4PCamLive
//
//  Created by Maxwell on 13-6-6.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "include/AVIOCTRLDEFs.h"
#import "include/AVFRAMEINFO.h"

@interface ubiaDeviceChannelSettings : NSObject

@property (nonatomic, assign) UInt16 channel;
@property (nonatomic, assign) UInt16 index;

@property (nonatomic, assign) ENUM_QUALITY_LEVEL videoQuality;
@property (nonatomic, assign) ENUM_RECORD_TYPE recordMode;
@property (nonatomic, assign) ENUM_VIDEO_MODE flipMirror;
@property (nonatomic, assign) ENUM_ENVIRONMENT_MODE envMode;
@property (nonatomic, assign) UInt8 irSwitch; /*0=off 1=on*/
@property (nonatomic, assign) ENUM_CODECID audioCodec;
@property (nonatomic, assign) UInt8 audioVolume; /*0=off, 255=max*/

@property (nonatomic, assign) UInt8 alarmMode; /*0=silent, 1=voice, 2=vibrate, 3=both*/

@property (nonatomic) UInt8    mdSensitivity; /*0-4*/
@property (nonatomic) UInt8    audioSensitivity; /*0-4*/
@property (nonatomic) UInt8    tempSensitivity; /*0-4*/

//@property (nonatomic) UInt8    mdEnable; /*1=on 2=off*/
@property (nonatomic) UInt8    mdGop; /*1-50*/
//@property (nonatomic) UInt8    mdBitmap[15]; /*LSB 20bits 20*25 blocks/

@property (nonatomic) UInt8   coverEnable; /*1=on 2=off*/

/*mainstream*/
@property (nonatomic) UInt8     mFlowType;  /*1=cbr,2=vbr*/
@property (nonatomic) UInt8     mFrameRate; /*1-60fps*/
@property (nonatomic) UInt8     mFlowRateMulti32K;
@property (nonatomic) UInt16    mWidth;
@property (nonatomic) UInt16    mHeight;

/*substream*/
@property (nonatomic) UInt8     sFlowType;  /*1=cbr,2=vbr*/
@property (nonatomic) UInt8     sFrameRate; /*1-60fps*/
@property (nonatomic) UInt8     sFlowRateMulti32K;
@property (nonatomic) UInt16    sWidth;
@property (nonatomic) UInt16    sHeight;


@end
