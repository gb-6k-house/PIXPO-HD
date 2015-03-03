//
//  WifiSetupInfo.h
//  P4PLive
//
//  Created by Maxwell on 14-8-2.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiSetupInfo : NSObject{

@private

NSString *_uid;
NSString *_ssid;
NSString *_key;
}

@property(strong) NSString *uid;
@property(strong) NSString *ssid;
@property(strong) NSString *key;

@end
