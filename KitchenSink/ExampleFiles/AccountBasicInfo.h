//
//  AcountBasicInfo.h
//  P4PLive
//
//  Created by Maxwell on 14-4-8.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountBasicInfo : NSObject{
    
@private
    NSString *_repassword;
    NSString *_password;
    NSString *_login;
    NSString *_realname;
}

@property(strong) NSString *login;
@property(strong) NSString *password;
@property(strong) NSString *repassword;
@property(strong) NSString *realname;


@end
