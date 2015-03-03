//
//  Video.h
//  iFrameExtractor
//
//  Created by lajos on 1/10/10.
//
//  Copyright 2010 Lajos Kamocsay
//
//  lajos at codza dot com
//
//  iFrameExtractor is free software; you can redistribute it and/or
//  modify it under the terms of the GNU Lesser General Public
//  License as published by the Free Software Foundation; either
//  version 2.1 of the License, or (at your option) any later version.
// 
//  iFrameExtractor is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  Lesser General Public License for more details.
//


#import <Foundation/Foundation.h>
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
#include "libavcodec/avcodec.h"
typedef struct audioCodec_Param{
    int bits_per_coded_sample;
    int av_codec_id;
    int channels;
    int frame_size;
    int sample_fmt;
    int sample_rate;
    int bit_rate;
    unsigned short ubia_codec_id;
    unsigned short resv;
} AUDIO_CODEC_PARAM;

@interface VideoFrameExtractor : NSObject {	
    int videoStream;
	int sourceWidth, sourceHeight;
	int outputWidth, outputHeight;
	//UIImage *currentImage;
	double duration;
    double currentTime;

}

/* Last decoded picture as UIImage */
//@property (nonatomic, readonly) UIImage *currentImage;

/* Size of video frame */
@property (nonatomic, readonly) int sourceWidth, sourceHeight;

/* Output image size. Set to the source size by default. */
@property (nonatomic) int outputWidth, outputHeight;

/* Length of video in seconds */
@property (nonatomic, readonly) double duration;

/* Current time of video in seconds */
@property (nonatomic, readonly) double currentTime;

@property (nonatomic, assign) BOOL isDecodingVideoFrame;
@property (nonatomic, assign) BOOL isDecodingAudioFrame;

@property (nonatomic, assign) AUDIO_CODEC_PARAM audioEncParam;
@property (nonatomic, assign) AUDIO_CODEC_PARAM audioDecParam;

/* Initialize with movie at moviePath. Output dimensions are set to source dimensions. */
-(id)initWithVideo:(NSString *)moviePath;
-(id)initWithH264;
-(void)destroyH264;

/* Read the next frame from the video stream. Returns false if no frame read (video over). */
-(BOOL)stepFrame;

/* Seek to closest keyframe near specified time */
-(void)seekTime:(double)seconds;
-(int)decodeAndShow : (char*) buf length:(int)len andTimeStamp:(unsigned long)ulTime;

//-(void)savePicture:(AVPicture)pFrame width:(int)width height:(int)height index:(int)iFrame;
-(unsigned char *) getPictureData;
-(UInt32) getPictureLinesize;
-(void)setupScaler;
-(void) clearPicture;

-(void)destoryAudioDecoder;
-(void)initAudioDecoder: (unsigned short) codec with: (unsigned char) flag;

-(void)destoryAudioEncoder;
-(void)initAudioEncoder: (unsigned short) codec with: (unsigned char) flag;

-(int)decodeAudio: (char*) inputBuf length:(int)inputBytes andTimeStamp:(unsigned long)ulTime outPacket:(char*) outputBuf length:(int)outputBufSize;
-(int)encodeAudio: (char*) inputBuf length:(int)inputBytes andTimeStamp:(unsigned long)ulTime outPacket:(char*) outputBuf length:(int)outputBufSize;

@end
