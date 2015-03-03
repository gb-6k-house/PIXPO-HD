//
//  Hmac_sha1.h
//
//
//  Created by user on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "sha1.h"

int URLEncode(const char*, const int, char*, const int);

@interface Hmac_sha1 : NSObject

//+ (NSString *)hmac_sha1:(NSString *)key text:(NSString *)text;

+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key;

@end
