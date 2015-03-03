//
//  ubiaWifiApInfo.h
//  P4PLive
//
//  Created by Maxwell on 14-4-5.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ubiaWifiApInfo : NSObject

@property (strong,nonatomic) NSString *ssid; // WiFi ssid
@property (assign,nonatomic) char mode;   // refer to ENUM_AP_MODE
@property (assign,nonatomic) char enctype; // refer to ENUM_AP_ENCTYPE
@property (assign,nonatomic) char signal; // signal intensity 0--100%
@property (assign,nonatomic) char status;   // 0 : invalid ssid or disconnected
                                            // 1 : connected with default gateway
                                            // 2 : unmatched password
                                            // 3 : weak signal and connected
                                            // 4 : selected:password matched and disconnected or connected but not default gateway

@end
