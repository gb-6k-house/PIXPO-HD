//
//  ubiaLocalDeviceConfig.h
//  P4PCamLive
//
//  Created by Maxwell on 14-9-5.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ubiaClient;
@class ubiaDevice;
@class ubiaRestClient;

@interface ubiaLocalDeviceConfig : NSObject < NSFetchedResultsControllerDelegate >
{
    
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, assign) int silentMode;
@property (nonatomic, assign) int silentBegin;
@property (nonatomic, assign) int silentDuration;
@property (nonatomic, strong) NSString * lastWebaccount;


- (void)persistSaveConfigInfo;
- (void)loadLocalDeviceConfig : (ubiaRestClient *) restClient;
- (void)addNewDevice:(ubiaDevice *)device;
- (void)deleteDevice: (ubiaDevice *)device;
- (void)updateDevice:(ubiaDevice *)device;
@end
