//
//  Hmac_sha1.m
//
//
//  Created by user on 12-10-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Hmac_sha1.h"
#import "Base64.h"

int URLEncode(const char* str, const int strSize, char* result, const int resultSize)
{
    int i;
    int j = 0;//for result index
    char ch;
    
    if ((str==NULL) || (result==NULL) || (strSize<=0) || (resultSize<=0))
    {
        return 0;
    }
    //printf("URLEncode str=%s\n", str);
    for ( i=0; (i<strSize)&&(j<resultSize); ++i)
    {
        ch = str[i];
        if (((ch>='A') && (ch<='Z')) ||
            ((ch>='a') && (ch<='z')) ||
            ((ch>='0') && (ch<='9')))
        {
            result[j++] = ch;
        }
        else if (ch == ' ')
        {
            result[j++] = '+';
        }
        else if (ch == '.' || ch == '-' || ch == '_' || ch == '*')
        {
            result[j++] = ch;
        }
        else
        {
            if (j+3 < resultSize)
            {
                sprintf(result+j, "%%%02X", (unsigned char)ch);
                j += 3;
            }
            else
            {
                return 0;
            }
        }
    }
    
    result[j] = '\0';
    //printf("URLEncode result=%s\n", result);
    return j;
}

@implementation Hmac_sha1

+ (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];

#if 0
//    NSString *hash = [HMAC base64String];
    //NSString *baseStr=[Base64 encode:HMAC];
    NSString *baseStr = [Base64 stringByEncodingData:HMAC];
    
    NSLog(@"base64encode : %@", baseStr);
    char r_hmac[1024] = {0};
    int iUrl=URLEncode([baseStr UTF8String], [baseStr length], r_hmac, 1024);
    NSString *hmac=[NSString stringWithFormat:@"%s", r_hmac];
    NSLog(@"iurl=%d , hmac_sha1=%@",iUrl,hmac);
#else
    NSString *hmac = [Base64 stringByWebSafeEncodingData:HMAC padded:TRUE];
    NSLog(@"stringByWebSafeEncodingData : %@", hmac);

    NSString *base64String = [HMAC base64EncodedStringWithOptions:0];
    
    base64String = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    base64String = [base64String stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    base64String = [base64String stringByReplacingOccurrencesOfString:@"=" withString:@","];
    NSLog(@"base64EncodedStringWithOptions : %@", base64String);
    
#endif
    
    return hmac;
}


@end
