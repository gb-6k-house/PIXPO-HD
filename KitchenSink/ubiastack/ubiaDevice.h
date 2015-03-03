//
//  ubiaDevice.h
//  P4PCamLive
//
//  Created by Maxwell on 13-4-20.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ubiaDeviceSettings.h"
#import "ubiaDeviceChannelSettings.h"

#import "ubiaClient.h"
#import "IOTCAPIs.h"
#import "AVAPIs.h"
#import "IOTCAPIs_ubia_addon.h"
#import "AVAPIs_ubia_addon.h"

#import "AVIOCTRLDEFs.h"
#import "VideoFrameExtractor.h"
#import "ubiaFileNode.h"
#import "ubiaQueryInfo.h"

//@class ubiaP4PController;
//@class VideoFrameExtractor;
@class ubiaDeviceSettings;
@class ubiaAlert;
@class ubiaWifiApInfo;
@class ubiaOperation;
@class ubiaDeviceManager;
// Device Status
// < 0: err
// 0: initial state
// 1: on connecting
// 2: online
// ch0 为控制通道，在IOTC_Connect之后立即avClientStart ch0以便控制通道可以工作
// ch0 为子码流，ch1为主码流，ch2为回放码流
//

#define MAX_FILE_TRANS_PKT_SIZE  1280
#define MAX_FILE_TRANS_CHANNEL   4

#define MAX_PENDING_IOTCRL_MSG  16
#define UBIA_DEVICE_CONNECT_RETRIES 3

@interface ubiaDevice : NSObject{

}

@property(nonatomic,weak) ubiaDeviceManager * deviceManager;
@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *ipaddr;
@property (nonatomic, assign)short port;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *location;

@property (nonatomic, copy) NSString *loginID;
@property (nonatomic, copy) NSString *password;


@property (nonatomic) Boolean isOwner; // current login account is the owner of this device
@property (nonatomic) Boolean isShare; // current login account is the friend of this device
@property (nonatomic) Boolean isPublic; // this is a public device
@property (nonatomic) NSDate *lastActiveTime;
@property (nonatomic) int timeZone;

@property (nonatomic, assign) int status; //online or not
@property (nonatomic, assign) int mode;   //P2P, RLY, LAN
@property (nonatomic, assign) int sessionID;

//@property (nonatomic, assign) int avIndex;
//@property (nonatomic, assign) int avChnNum; //the current selected channel,default is zero


//@property (nonatomic, assign) int avReplayChn; //the current selected channel,default is zero
//@property (nonatomic, assign) int avIndexReplay;

//@property (nonatomic, assign) int avTalkChn; //the current selected channel, totalchn+2
//@property (nonatomic, assign) int avIndexTalk;

@property (nonatomic, strong) ubiaDeviceSettings * settings;

@property (nonatomic, assign) BOOL isWaitIOResp;
@property (nonatomic, assign) BOOL isPendingIOControl;

//@property (atomic, weak) UIImage *currentImage;

//@property (weak, nonatomic) VideoFrameExtractor *video;
@property (nonatomic, weak) UITableViewCell * cell;

@property (nonatomic,strong) ubiaClient *client;

@property (nonatomic,strong) dispatch_queue_t serialQueue;

@property (nonatomic,strong) NSOperationQueue *operationQueue;

@property (nonatomic, strong) ubiaOperation *connectOperation;
@property (nonatomic, strong) ubiaOperation *streamOperation;
@property (nonatomic, strong) ubiaOperation *stopOperation;
@property (nonatomic, strong) ubiaOperation *ioctlOperation;

@property (nonatomic, strong) NSMutableArray *ioctrlOutmsgQ;
@property (nonatomic, strong) NSMutableArray *ioctrlInmsgQ;
@property (nonatomic, assign) BOOL isClientActive;



-(void) startclient_sync;
-(void) startclient;

-(void) stopclient;
-(void) clientStatusRecovery;

-(void) start_video_stream:(int) chn;
-(void) stop_video_stream:(int) chn;
//-(void) start_listen_audio_stream;
//-(void) stop_listen_audio_stream;

-(void) start_talk_audio_server;
-(void) stop_talk_audio_server;

-(void) start_talk_audio_stream;
-(void) stop_talk_audio_stream;

-(void) startPlayRecord: (ubiaAlert *) alert;
-(void) stopPlayRecord;
-(void) pausePlayRecord;

-(int) get_replay_video_frame;

-(unsigned char *) get_audio_frame;

//-(int) send_audio_packet:(AVPacket *) audioPacket;
-(int) send_audio_packet:(char *) pktBuf length: (int) pktSize codec:(unsigned short) codec_id;

-(void) switchchannel:(int)newchn;

-(void) send_ptz_cmd:(int) cmd;

-(void) queryEventList:(ubiaQueryInfo *) queryInfo;

-(void) requestDeviceEnvMode;
-(void) requestDeviceInfo;
-(void) requestVideoMode;
-(void) requestVideoQuality;
-(void) requestRecordMode;
-(void) requestMDSensitivity;
-(void) requestSupportStream;
-(void) requestTimeZone;
-(void) setDeviceEnvMode;
-(void) setVideoMode;
-(void) setVideoQuality;
-(void) setRecordMode:(int) recordType;
-(void) setMDSensitivity;
-(void) setPassword:(NSString *)newpassword withOldPassword:(NSString *)oldpassword;
-(void) setTimeZone:(int)newTZ;

-(void) requestWIFIAPList;
-(void) requestWIFIAPInfo;
-(void) setWIFIAPInfo:(ubiaWifiApInfo *)apInfo withKey:(NSString *)key;

-(void) formatStorage:(unsigned int)storageIndex;
-(void) updateFirmware;
-(void) rebootDevice;

-(void) requestAudioSensitivity;
-(void) setAudioSensitivity;
-(void) requestTempSensitivity;
-(void) setTempSensitivity;
-(void) requestIFrame;

-(void) requestAlarmMode;
-(void) setAlarmMode;

-(void) requestFileList:(ubiaQueryInfo *) queryParm;

-(void) startDownLoad: (ubiaFileNode *) fileNode;
-(void) stopDownload:(ubiaFileNode *) fileNode;
-(void) pauseDownLoad:(ubiaFileNode *) fileNode;
-(void) resumeDownLoad:(ubiaFileNode *)fileNode;
-(void) sendFileTransReport:(ubiaFileNode *)fileNode;
-(void) sendFileTransNak:(ubiaFileNode *)fileNode;

-(void) startRecord;
-(void) stopRecord;

@end

