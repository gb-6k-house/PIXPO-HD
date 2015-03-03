//
//  ubiaAudioQueueController.h
//  P4PCamLive
//
//  Created by Maxwell on 13-6-3.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>
#include <Foundation/Foundation.h>
#include <libkern/OSAtomic.h>

#define kNumberBuffers 3
#define kBufferDurationSeconds 0.04
#define UBIA_NET_BUF_NUM 25
#define PCMBUF_SIZE  640

struct myPlayBuf {
    UInt32 size;
    UInt32 flag;
    unsigned char buf[PCMBUF_SIZE];
};

@interface ubiaAQPlayController : NSObject
{
    AudioQueueRef					mQueue;
    AudioQueueBufferRef				mBuffers[kNumberBuffers];
    AudioFileID						mAudioFile;
    CFStringRef						mFilePath;

    AudioStreamBasicDescription     mDataFormat;
   
    UInt32							mNumPacketsToRead;
    SInt64							mCurrentPacket;
    //Add by Maxwell
    struct myPlayBuf                recvbuf[UBIA_NET_BUF_NUM];
    UInt32                          enqueueIndex;
    UInt32                          outqueueIndex;
    UInt32                          numDataBlocks;
    NSLock                          *_synthLock;
}

@property (nonatomic, assign)    Boolean	mIsInitialized;
@property (nonatomic, assign)    Boolean	mIsRunning;
@property (nonatomic, assign)    Boolean	mIsDone;
@property (nonatomic, assign)    Boolean	mIsLooping;
@property (nonatomic, assign)    Boolean    playbackWasPaused;
@property (nonatomic, assign)    Boolean    playbackWasInterrupted;
@property (nonatomic, assign)    Float32    gain;
@property (nonatomic, assign)    UInt32     BufferedBlocks;
@property (nonatomic, assign)    Boolean    mPlayoutEnabled;

-(Boolean) RecvUserData:(unsigned char *) buf withSize:(UInt32)size;
-(int) DequeueUserData: (unsigned char *) buf withSize:(UInt32) bufsize;
-(void) SetupNewQueue;
-(void) DisposeQueue:(Boolean) inDisposeFile;
-(void) CreateQueueForFile:(CFStringRef) inFilePath;
-(OSStatus) StartQueue:(BOOL)inResume;
-(OSStatus) PauseQueue;
-(OSStatus) StopQueue;
-(void) changePlayRoute:(char)route;
- (void)setGain:(Float32)gain;

@end
