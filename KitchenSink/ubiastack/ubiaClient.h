//
//  ubiaClient.h
//  P4PCamLive
//
//  Created by Maxwell on 14-1-18.
//  Copyright (c) 2014年 ubia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "ubiaPlatform.h"

#import "IOTCAPIs_ubia_addon.h"
#import "AVAPIs_ubia_addon.h"

#import "IOTCAPIs.h"
#import "AVAPIs.h"


//#import "ubiaPThreadQueue.h"
//#import "ubiaQueueItem.h"
//#import "ubiaRingBuffer.h"
//#import "ubiaRingBufferBlock.h"

enum{
    CONNECTION_STATE_NONE = 0,
    CONNECTION_STATE_CONNECTING = 1,
    CONNECTION_STATE_CONNECTED = 2,
    CONNECTION_STATE_DISCONNECTED = 3,
    CONNECTION_STATE_UNKNOWN_DEVICE = 4,
    CONNECTION_STATE_WRONG_PASSWORD = 5,
    CONNECTION_STATE_TIMEOUT = 6,
    CONNECTION_STATE_UNSUPPORTED = 7,
    CONNECTION_STATE_CONNECT_FAILED = 8,
};

enum{
    UBIA_CLIENT_STATUS_NULL = 0,
    UBIA_CLIENT_STATUS_CONNECTING = 1,
    UBIA_CLIENT_STATUS_CONNECTED = 2,
    UBIA_CLIENT_STATUS_AUTHORIZED = 3,
    UBIA_CLIENT_STATUS_PENDINGTO_DISCONNECT = 4,
    UBIA_CLIENT_STATUS_PENDINGTO_STOPSTREAM = 5,
    UBIA_CLIENT_STATUS_DISCONNECTED = 6,
    UBIA_CLIENT_STATUS_UNKNOWN_DEVICE = 7,
    UBIA_CLIENT_STATUS_WRONG_PASSWORD = 8,
    UBIA_CLIENT_STATUS_TIMEOUT = 9,
    UBIA_CLIENT_STATUS_UNSUPPORTED = 10,
    UBIA_CLIENT_STATUS_CONNECT_FAILED = 11,
    UBIA_CLIENT_STATUS_ERROR = 12,
};

enum{
    P2PLIB_VER_NULL = 0,
    P2PLIB_VER_UBIA_V1,
    P2PLIB_VER_UBIA_V2,
    P2PLIB_VER_UBIA_V3,
    P2PLIB_VER_UBIA_V4,
    P2PLIB_VER_TUTK=255
};


enum{
    CHN_LAYOUT_SUBSTREAM  = 0, /* 640x360 */
    CHN_LAYOUT_MAINSTREAM = 1, /* 1280x720 */
    CHN_LAYOUT_PLAYBACK   = 2, /* 1280x720 */
    CHN_LAYOUT_TALKAUDIO  = 3,
    CHN_LAYOUT_FILETRANS  = 4,
    CHN_LAYOUT_FILETRANS_S1  = 5,
    CHN_LAYOUT_FILETRANS_S2  = 6,
    CHN_LAYOUT_FILETRANS_S3  = 7
};

#define UBIA_INVALID_VALUE -1

typedef struct ioctrlMsg{
    unsigned short cmdType;
    unsigned short msgSize;
}BACKEND_IOCTL_MSG;


@interface ubiaClient : NSObject

@property (nonatomic, assign) unsigned char p2pLibVer;

@property (nonatomic, assign) char mode;  // 1:P2P, 2:RELAY, 3:LAN
@property (nonatomic, assign) int  status; // 0: initialize; 1:pending to run; 2:connecting; 3:connected;4: pending to exit; 5: error
@property (nonatomic, assign) int  errCode;

@property (nonatomic, assign) NSString *uid;

@property (nonatomic, assign) unsigned short vid;
@property (nonatomic, assign) unsigned short pid;
@property (nonatomic, assign) unsigned short gid;

@property (nonatomic, assign) int sid;
@property (nonatomic, assign) int activechn;
@property (nonatomic, assign) int avid;

@property (nonatomic, assign) int serverStreamIndex;

@property (nonatomic, assign) int replaychn;
@property (nonatomic, assign) int replayavid;

@property (nonatomic, assign) int talkchn;
@property (nonatomic, assign) int talkavid;
@property (nonatomic, assign) int talktimestamp;

@property (nonatomic, assign) int gotIFrame;
@property (nonatomic, copy) NSString *loginID;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) int isVideoStreamIn;
@property (nonatomic, assign) int isVideoStreamOut;
@property (nonatomic, assign) int isAudioStreamIn;
@property (nonatomic, assign) int isAudioStreamOut;

@property (nonatomic, assign) int logLevel;

@property (atomic,assign) BOOL isKilled;
@property (atomic,assign) BOOL isRunning;

@property (atomic,assign) int audioInBufferOffset;
@property (atomic,assign) int audioInBufferBytes;
@property (atomic,assign) int audioOutBufferOffset;
@property (atomic,assign) int audioOutBufferBytes;

//@property (nonatomic, strong) ubiaPThreadQueue * audioSendQueue;
//@property (nonatomic, strong) ubiaRingBuffer * audioSendRingBuffer;

@property (nonatomic, strong) NSThread * AudioSendThread;
@property (nonatomic, strong) NSThread * AudioRecvThread;
@property (nonatomic, strong) NSThread * VideoRecvThread;
@property (nonatomic, strong) NSThread * AVSyncPlayThread;

@property (nonatomic,strong) UIImageView *destImageView; //this object is set by external

@property (nonatomic,assign) int secondSince1970;
@property (nonatomic,assign) int deviceTimeZone;

@property (nonatomic,assign) char infoValidBit;
@property (nonatomic,assign) char recordstatus;
@property (nonatomic,assign) short temperature;

@property (nonatomic,assign) int gotFrames;
@property (nonatomic,assign) int lostFrames;
@property (nonatomic,assign) int partialFrames;

@property (nonatomic,assign) int ReceiveVideoTimestamp;
@property (nonatomic,assign) int ReceiveAudioTimestamp;

@property (nonatomic, assign) BOOL isClientListening;
@property (nonatomic, assign) BOOL isClientTalkinging;
@property (nonatomic, assign) BOOL isClientRecording;

@property (nonatomic, assign) BOOL enableClientRecord;

-(int) getP2PLibVer:(NSString *)devUID;


- (void) runConnectThread;

- (void) connect;
- (void) loginToDevice;
- (void) logoutDevice;

- (void) disconnect;

-(int) startVideoStream:(int) chn;
-(int) stopVideoStream:(int) chn;

-(int) clientStartListen;
-(int) clientStopListen;

-(int) clientStartTalk;
-(int) clientStopTalk;

-(int) receiveStreamData:(int) avIndex withbuf:(char *)recvBuf;
//-(int) receiveAudioData:(int) avIndex withbuf:(char *)recvBuf;
-(int) receiveAudioData:(int) avIndex withbuf:(char *)recvBuf with:(int) bufSize info: (char *) infobuf infosize: (int) infoBufSize;

-(int) recvIOControl:(int) avIndex withTimeout: (unsigned int) nTimeout withbuf:(char *)recvbuf;
-(int) sendIOControl:(int) avIndex withbuf:(char *)sendbuf;
-(void) UBIA_CLIENT_LOG:(NSString *) str withLevel: (int) level;
-(NSString *) parseIOTCErrCode;
- (void) stopPendingIO;

-(int) startRecord:(NSString *)fileName width:(int)width height:(int)height sampleDuration:(int)duration;
-(int) stopRecord;

-(int) receivePacketData:(int) avIndex withbuf:(char *)recvBuf withinfo:(char *)infoBuf infSize:(int *) infoSize;
-(BOOL) supportRealtimeTemperature;
-(BOOL) supportRealtimeRecordStatus;
/*===========================================*/
//-(BOOL) setImageView:(UIImageView *)imageView;

@end
