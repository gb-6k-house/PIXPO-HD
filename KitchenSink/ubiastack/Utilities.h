//
//  Utilities.h
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
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

#import "ubiaFileNode.h"
#import "MMAppDelegate.h"

#define UTIL_LOCAL_PICT_DIR      "Snapshot"
#define UTIL_DEVICE_FILE_DIR     "OnDevice"
#define UTIL_DEVICE_DOWNLOAD_DIR "DevDownload"
#define UTIL_DEVICE_UPLOAD_DIR   "DevUpload"
#define UTIL_CLOUD_FILE_DIR      "OnCloud"
#define UTIL_CLOUD_DOWNLOAD_DIR  "CldDownload"
#define UTIL_CLOUD_UPLOAD_DIR    "CldUpload"
#define UTIL_LOCAL_FILE_DIR      "AtLocal"

enum {
    UTIL_LOCAL_PICT,
    UTIL_DEVICE_DOWNLOAD,
    UTIL_DEVICE_UPLOAD,
    UTIL_DEVICE_FILE,
    UTIL_CLOUD_DOWNLOAD,
    UTIL_CLOUD_UPLOAD,
    UTIL_CLOUD_FILE,
    UTIL_LOCAL_FILE
};

enum{
    DATE_FORMAT_CHS,
    DATE_FORMAT_YMD,
    DATE_FORMAT_DMY
};

@interface Utilities : NSObject {
    NSString * baseDir;
}

+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;
//+(NSString *)checkDocumentsPathwithCreate:(NSString *)dirPaths;
+(NSString *)checkDocumentsPathwithCreate:(NSString *)dirPaths withType:(int)type;
+(NSString *)checkDocumentsBasewithCreate:(NSString *)basePaths;
+(NSMutableArray *)getAllPictFilesUnderBaseDir;
+(NSString *) getSubDirNameByType:(int) type;

+(NSArray *)getFilesByUID:(NSString *) uid attr:(int)type;

+(UIImage *)loadImageFile:(ubiaFileNode *) node;
+(UIImage *)loadImageFile:(NSString * )fileName withUID:(NSString *) uid;
+(BOOL)deleteImageFile:(ubiaFileNode *) node;
+(BOOL)deleteFile:(NSURL *) storeURL;

+(UIImage *) load_lastsnap :(NSString *) uid;
+(void) save_lastsnap: (NSString *) uid withImage:(UIImage *)image;
+(void) capture_snapshot: (NSString *) uid withImage:(UIImage *)image;


+(BOOL)copyFile:(NSURL *) destStoreURL from:(NSURL *) sourceStoreURL;
+(long)getFileAttributes:(NSString *)filename;
+(NSString *) utctimeToString:(unsigned int) timesince1970;

+(NSString *) utctimeToDateString:(unsigned int) timesince1970 withFmt:(int)format;
+(NSString *) utctimeToTimeString:(unsigned int) timesince1970;
+(NSString *) dateToDateString:(NSDate *) stDate withFmt:(int)format;
+(NSString *) dateToTimeString:(NSDate *) stDate;

+(unsigned int)UbiaGetTickCount;

+(NSString *) formatFileSize:(long) size;

+(NSData *) getMD5Digest:(NSString *)filename;
+(NSData *) getSHA1Digest:(NSString *)filename;
+(void) dumpHexData:(NSData *) srcData;

+(UIColor *)btnTextColor;
+(UIColor *)btnBackgroundColor;
+(UIColor *)viewBackgroundColor;
+(UIColor *)defaultFrontColor;
+(UIColor *)textColor;
+(UIFont *)textFont;

+(NSString *) gen_Nonce;
+(NSString *) gen_Time;
+(NSString * )url_safe_base64_encode:(NSString *) plainString;
+(NSString * )url_safe_base64_decode:(NSString *) base64String;
+(NSString *)hmacsha1:(NSString *)data secret:(NSString *)key;
+(NSString *)kuaipan_hmacsha1:(NSString *)data secret:(NSString *)key;
int URLEncode(const char* str, const int strSize, char* result, const int resultSize);
int KuaiPan_PathEncode(const char* str, const int strSize, char* result, const int resultSize);
@end
