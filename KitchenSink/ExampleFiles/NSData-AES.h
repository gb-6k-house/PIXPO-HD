//
//  NSData-AES.h
//  P4PLive
//
//  Created by Maxwell on 14-3-7.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

//@interface NSData (Encryption)


@interface NSData_AES : NSData

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密


@end

