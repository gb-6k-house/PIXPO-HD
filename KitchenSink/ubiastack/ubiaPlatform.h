//
//  ubiaPlatform.h
//  P4PCamLive
//
//  Created by Maxwell on 14-1-18.
//  Copyright (c) 2014年 ubia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOTCAPIs.h"
#import "AVAPIs.h"
#import "IOTCAPIs_ubia_addon.h"
#import "AVAPIs_ubia_addon.h"

#import "AVIOCTRLDEFs.h"
#import "AVFRAMEINFO.h"
#import <sys/time.h>

#define  UID_SIZE            20
#define  MAX_AUTH_STR_SIZE   24

#define  MAX_SESSION    16
#define  AUDIO_BUF_SIZE	640
#define  VIDEO_BUF_SIZE	2000000
#define  IOCTL_BUF_SIZE 1472
#define  IOCTL_RETRIES    3

@interface ubiaPlatform : NSObject
@property (nonatomic,assign) int maxClient;
@property (atomic,assign) BOOL isInitialized;

//@property (nonatomic,assign) char *videoFrameBuf;

//@property (nonatomic,assign) char * audioFrameBuf;

//@property (nonatomic,assign) char * audioTalkFrameBuf;

//@property (nonatomic,assign) char * ioctrlRecvBuf;

//@property (nonatomic,assign) char * ioctrlSendBuf;



-(BOOL) ubiaPlatformInitialize : (int) num;
-(void) ubiaPlatformDeInitialize;


@end
