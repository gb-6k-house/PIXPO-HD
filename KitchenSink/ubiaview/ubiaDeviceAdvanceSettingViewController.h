//
//  ubiaDeviceAdvanceSettingViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 13-6-7.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ubiaDevice.h"

@interface ubiaDeviceAdvanceSettingViewController : UITableViewController

@property (strong, nonatomic) ubiaDevice *currentDevice;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *values;
@property (strong, nonatomic) NSIndexPath *selectCellPath;
@property (nonatomic) int newvalue;

@end
