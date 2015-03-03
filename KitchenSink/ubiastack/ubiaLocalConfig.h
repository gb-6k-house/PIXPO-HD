//
//  ubiaLocalConfig.h
//  P4PLive
//
//  Created by Maxwell on 14-3-1.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

enum{
    UBIA_LC_SILENT_MODE_ON,
    UBIA_LC_SILENT_MODE_NIGHT,
    UBIA_LC_SILENT_MODE_OFF,
};


@class ubiaClient;
@class ubiaDevice;


@interface ubiaLocalConfig : NSObject < NSFetchedResultsControllerDelegate >
{
    
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *fetchedAccountsController;

@property (nonatomic, retain) NSString *user_loginID;
@property (nonatomic, retain) NSString *user_password;
@property (nonatomic, retain) NSString *user_safePassword;
@property (nonatomic, assign) BOOL autoLogin;
@property (nonatomic, assign) BOOL savePassword;

@property (nonatomic, retain) NSString *user_token;
@property (nonatomic, retain) NSString *user_secret;

@property (nonatomic, retain) NSDate *lastLogin;
@property (nonatomic, assign) BOOL hasLogin;
@property (nonatomic, assign) int notificationType;
@property (nonatomic, assign) int silentMode;
@property (nonatomic, assign) int silentBegin;
@property (nonatomic, assign) int silentDuration;
@property (nonatomic, strong) NSString * lastWebaccount;
@property (nonatomic, assign) int cloudstatus;

- (void)persistSaveConfigInfo;
- (void)loadConfigInfo;

- (void)saveAccountInfo;
- (void)loadAccountInfo;


@end
