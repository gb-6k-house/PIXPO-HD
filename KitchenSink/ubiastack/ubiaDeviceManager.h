//
//  ubiaDeviceManager.h
//  P4PLive
//
//  Created by Maxwell on 14-4-21.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ubiaAQPlayController.h"
#import "ubiaAQRecordController.h"
//#import "ubiaRingBuffer.h"
//#import "ubiaRingBufferBlock.h"
//#import "ubiaPThreadQueue.h"
//#import "ubiaQueueItem.h"

#import "ubiaDevice.h"
#import "ubiaDeviceList.h"

#import "ubiaRestClient.h"
#import "VideoFrameExtractor.h"
#import "ubiaPlatform.h"
#import "ubiaLocalConfig.h"

#import "ubiaAlert.h"
#import "MMImageViewer.h"
#import "ubiaQueryInfo.h"

#define ENABLE_AUTO_CONNECT 1
#define USING_AS_STANDALONE     1
//#define ON_PERFORMACE_TUNNING   1

#define MAX_TRANSFERING_ITEM 256

#define MAX_ALERT_INARRARY 256
enum{
    UBIA_DM_TIMER_ACTION_NONE,
    UBIA_DM_TIMER_ACTION_TOBESILENT,
    UBIA_DM_TIMER_ACTION_EXITSILENT
};

/*Define Device manager local notification*/
#define kUbia_DM_DEVICE_STATUS_UPDATE "KUBIA_DM_DEVICE_STATUS_UPDATE"


@interface ubiaDeviceManager : NSObject{

}
@property (nonatomic, assign) BOOL isMyDeviceView;
@property (nonatomic, assign) BOOL isPublicView;

@property (nonatomic, assign) BOOL isManagerKilling;

@property (strong,nonatomic) ubiaLocalConfig *localConfig;
@property (nonatomic,strong) NSTimer * nightModeTimer;
@property (nonatomic,assign) BOOL inNoftiyMode;
@property (nonatomic,assign) int badgeNum;

@property (strong,nonatomic) ubiaRestClient *restClient;
@property (strong,nonatomic) VideoFrameExtractor *video;
@property (strong,nonatomic) ubiaPlatform * p4pPlatform;

@property (nonatomic,strong) ubiaAQPlayController *  uAQPlayer;
@property (nonatomic,strong) ubiaAQRecordController * uAQRecord;
@property (nonatomic,assign) char audioPlayRoute; //0:receiver, 1: speaker
//@property (nonatomic, strong) ubiaRingBuffer * audioInRingBuffer;

//@property (nonatomic, strong) ubiaPThreadQueue * audioSendQueue;
//@property (nonatomic, strong) ubiaRingBuffer * audioSendRingBuffer;

//@property (nonatomic, strong) ubiaPThreadQueue * ioctrlSendQueue;
//@property (nonatomic, strong) ubiaRingBuffer * ioctrlSendRingBuffer;

@property (nonatomic,weak) ubiaDevice *  currentDevice;
@property (nonatomic,weak) MMImageViewer * imageView;
@property (nonatomic, assign) bool  onceDecodeSucess;
//for cache the query result
@property (nonatomic,strong) NSMutableArray * queriedAlerts;
@property (nonatomic,strong) NSMutableArray * queriedFiles;
//@property (strong, nonatomic) ubiaDeviceList *myDeviceList;
//@property (strong, nonatomic) ubiaDeviceList *publicList;

//@property (nonatomic, assign) BOOL isPlatformReadyForRun;
//@property (nonatomic, assign) BOOL isPlatformReadyForExit;

@property (nonatomic, assign) int videoOutputWidth;
@property (nonatomic, assign) int videoOutputHeight;

@property (nonatomic,strong) NSMutableArray * downloadingArray;
@property (nonatomic,strong) NSMutableArray * uploadingArray;
@property (nonatomic,assign) BOOL autoStartListen; //auto enable listen as 

- (void)resignFromActive;
- (void)restoreToActive;

-(void) startVideo;
-(void) stopVideo;
-(BOOL) getDeviceInfo;



-(void) startPlayback:(ubiaAlert *)alert;
-(void) stopPlayback;


-(void) startDownLoadFile:(ubiaFileNode *)fileNode;
-(void) stopDownLoadFile:(ubiaFileNode *)fileNode;
-(void) pauseAllDownloadFile;
-(BOOL) pauseFileDownload:(int) index;
-(BOOL) resumeFileDownload:(int)index;


- (void)playAudio:(id)sender;
- (void)stopAudio;
- (void)startListen;
- (void)startTalk;

- (void)changePlayAudioRoute:(char) route;

- (void) queryAlerts:(ubiaQueryInfo *)queryInfo;

- (void) queryFiles:(ubiaQueryInfo *) queryParam;

- (void)startIOCTRLThread;

- (void)enterMyDeviceView;
- (void)leaveMyDeviceView;
- (void)enterPublicDeviceView;
- (void)leavePublicDeviceView;

- (void)saveSnapShot;

-(void) handleSlientMode:(int) mode;
-(void) setAudioNotification:(BOOL) status;
-(void) setAlertNotification:(BOOL) status;

- (void)scheduleNotificationWithItem:(int)minutesBefore;

+(BOOL) isReadyForRun;
+(BOOL) isReadyForExit;

@end
