//
//  ubiaRestClient.h
//  P4PLive
//
//  Created by Maxwell on 14-3-1.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#import "ubiaDeviceList.h"
#import "ubiaRestDef.h"
#import "ubiaLocalConfig.h"

#import <CoreData/CoreData.h>

#define REST_SERVICE_BASE "http://camera.kkmove.com/interface.php"
//#define REST_SERVICE_BASE "http://portal.ubia.cn/interface.php"

@class ubiaClient;
@class ubiaDevice;
@class AccountBasicInfo;
@class ubiaCloudKuaiPan;
@class ubiaBuddyList;
@class ubiaDeviceManager;
@class ubiaLocalDeviceConfig;

@interface ubiaRestClient : NSObject < NSFetchedResultsControllerDelegate >
{
    NSString *dateStr;
    NSString *timeStr;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, weak) ubiaDeviceManager *deviceManager;
@property (nonatomic, retain) NSString *Time;
@property (nonatomic, retain) NSString *Nonce;
@property (nonatomic, retain) NSString *user_loginID;
@property (nonatomic, retain) NSString *user_password;
@property (nonatomic, retain) NSString *user_safePassword;
@property (nonatomic, retain) NSDate *lastLogin;
@property (nonatomic, assign) BOOL autoLogin;
@property (nonatomic, assign) BOOL savePassword;
@property (nonatomic, assign) BOOL hasLogin;
@property (nonatomic, assign) UInt32 Seq;
@property (nonatomic, assign) BOOL pendingShare;
@property (nonatomic, retain) ubiaBuddyList *myBuddies;

@property (nonatomic, strong) ubiaLocalConfig *localConfig;

@property (nonatomic, assign) BOOL *isRequesting;

//@property (nonatomic) BOOL isShare;

/*Web Portal Info*/
@property (nonatomic, retain) NSString *user_token;
@property (nonatomic, retain) NSString *user_secret;

/*Cloud Auth Info*/
@property (nonatomic, retain) ubiaCloudKuaiPan  *kuaipan;
/*End of Cloud Auth Info*/

@property (strong,nonatomic) ubiaLocalDeviceConfig *localDeviceConfig;

@property (strong, nonatomic) ubiaDeviceList *myDeviceList;
@property (strong, nonatomic) ubiaDeviceList *publicList;

-(BOOL) device_op :(ubiaDevice *)device operate:(int) cmd;
-(BOOL) account_op : (AccountBasicInfo *)info  operate:(int) cmd;
-(BOOL) shareaccount_op : (AccountBasicInfo *)info operate:(int) cmd;

-(BOOL) query_account_cloudinfo;
-(BOOL) get_cloudinfo;

-(BOOL) get_device_password : (ubiaDevice *)device;

-(BOOL) get_public_device_list;
-(BOOL) get_my_device_list;

-(BOOL) get_virtual_device_list;

-(NSString *) request_newUID: (NSString *) macaddr withUID: (NSString *)UID;

- (BOOL)userLogin:(NSString *)account with: (NSString *) password;
- (BOOL)userRegister:(NSString *)account with:(NSString *) password with:(NSString *) checkcode;
- (BOOL)getCheckCode;

//-(NSString *)hmacsha1:(NSString *)data secret:(NSString *)key;
//-(NSString * )url_safe_base64_encode:(NSString *) plainString;
//-(NSString * )url_safe_base64_decode:(NSString *) base64String;
-(NSString *) parseErrCodetoStr:(NSInteger) errCode;

- (void)persistSaveAccountInfo;
- (void)loadDefaultAccountInfo;
- (void)loadLocalDeviceInfo;


@end
