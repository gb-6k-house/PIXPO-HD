//
//  ubiaAddDeviceTableViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 13-5-12.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#include "IOTCAPIs.h"

#import <UIKit/UIKit.h>
//#import "ZBarSDK.h"

#define LAN_SEARCH_MAX_NUM  32


@class ubiaDevice;
@interface ubiaAddDeviceTableViewController : UITableViewController {
    //NSMutableArray * searchResult;
    UIBarButtonItem *addButton;
    BOOL isSearchDoing;
    BOOL isSearchFinished;
    struct st_LanSearchInfo foundDevicelist[LAN_SEARCH_MAX_NUM];
    int numofFoundDevice;
}
@property (strong, nonatomic) IBOutlet UITableView *ubiaTableView;
@property (nonatomic, strong) NSArray *addSectionArray;
@property (nonatomic, strong) NSArray *actionSectionArray;
@property (nonatomic, strong) NSMutableArray *searchSectionArray;
@property (nonatomic, strong) ubiaDevice *foundDevice;

@property (retain, nonatomic) IBOutlet UIImageView *imageview;
@property (retain, nonatomic) IBOutlet UITextField *text;

- (void) setDeviceUID:(NSString*) uid;

@end
