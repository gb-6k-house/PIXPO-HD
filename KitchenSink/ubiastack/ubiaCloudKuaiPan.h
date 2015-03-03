//
//  ubiaCloudKuaiPan.h
//  P4PLive
//
//  Created by Maxwell on 14-7-1.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ubiaCloudKuaiPan : NSObject

@property (nonatomic, assign) int auth_type; /* 1:kuaipan, 2:KS3*/
@property (nonatomic, retain) NSString *auth_url;

@property (nonatomic, retain) NSString *consumer_key; /*developer ID of Open API*/
@property (nonatomic, retain) NSString *consumer_secret; /*developer ID of Open API*/
@property (nonatomic, retain) NSString *private_token;
@property (nonatomic, retain) NSString *private_secret;

@property (nonatomic, retain) NSString *public_token;
@property (nonatomic, retain) NSString *public_secret;

@property (nonatomic, retain) NSString *nonce;
@property (nonatomic, retain) NSString *timestamp;

-(void) get_cloud_info;
-(void) get_file_info:(NSString *) path;
-(void) download_file:(NSString *) path;
-(NSString *) generate_download_url :(NSString *) path;

@end
