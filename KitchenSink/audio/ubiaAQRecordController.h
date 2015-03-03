//
//  ubiaAQRecordController.h
//  P4PCamLive
//
//  Created by Maxwell on 13-6-3.
//  Copyright (c) 2013年 ubia. All rights reserved.
//
#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>
#include <Foundation/Foundation.h>
#include <libkern/OSAtomic.h>

#define kNumberRecordBuffers	3
#define kRecordBufferDurationSeconds 0.04

@class  ubiaDevice;
@class ubiaDeviceManager;

@interface ubiaAQRecordController : NSObject
{
    CFStringRef					mFileName;
    AudioQueueRef				mQueue;
    AudioQueueBufferRef			mBuffers[kNumberRecordBuffers];
    AudioFileID					mRecordFile;
    SInt64						mRecordPacket; // current packet number in record file

    AudioStreamBasicDescription mRecordFormat;
    __weak ubiaDeviceManager * deviceManager;
}
@property (nonatomic, assign) Boolean mIsRunning;
//@property (nonatomic, strong) ubiaDevice *currentDevice;
-(int) ComputeRecordBufferSize:(const AudioStreamBasicDescription *)format withSecond: (float) seconds;
-(void) SetupAudioFormat:(UInt32)inFormatID;
-(void) StartRecord:(CFStringRef) inRecordFile;
-(void) StopRecord;

@end
