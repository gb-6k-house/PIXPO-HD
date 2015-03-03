//
//  ubiaVideoRecorder.h
//
//  Created by Maxwell on 12/13/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaFrame.h"


@interface ubiaVideoRecorder : NSObject
{
    BOOL _recording;
    NSMutableArray *_frameList;
    int m_uTimeStamp;
    long frameIndex;
    
    NSString* _filePath;
}

@property (nonatomic, readonly) BOOL recording;
@property (nonatomic, retain) NSString* filePath;

- (void)addFrame:(MediaFrame *)frame;
- (void)start:(NSString *)fileName width:(int)width height:(int)height sampleDuration:(int)duration;
- (void)stop;

@end
