//
//  BindDeviceInfo.h
//  P4PLive
//
//  Created by Maxwell on 14-8-2.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BindDeviceInfo : NSObject{

@private
    NSString *_password;
    NSString *_login;
    NSString *_name;
    NSString *_location;
    BOOL isPublic;
}

@property(strong) NSString *login;
@property(strong) NSString *password;
@property(strong) NSString *name;
@property(strong) NSString *location;
@property(assign) BOOL isPublic;

@end
