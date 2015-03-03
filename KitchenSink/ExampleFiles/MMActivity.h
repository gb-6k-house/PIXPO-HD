//
//  MMActivity.h
//  P4PLive
//
//  Created by Maxwell on 14-4-1.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    UBIA_ACTIVITY_TYPE_NULL,
    UBIA_ACTIVITY_TYPE_MOTION = 1,
    UBIA_ACTIVITY_TYPE_ALARM,
    UBIA_ACTIVITY_TYPE_SOUND,
    UBIA_ACTIVITY_TYPE_PIR,
    UBIA_ACTIVITY_TYPE_TEMP
};

@interface MMActivity : NSObject

@property (nonatomic, assign) short alertType;
@property (nonatomic, strong) NSString * devUID;
@property (nonatomic, strong) NSString * snapFile;
@property (nonatomic, strong) NSDate * timeStamp;
@property (nonatomic, assign) short timeZone;

@end
