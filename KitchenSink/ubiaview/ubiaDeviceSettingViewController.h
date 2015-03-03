//
//  ubiaDeviceSettingViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 13-5-15.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ubiaDevice;

@interface ubiaDeviceSettingViewController : UITableViewController{
    UIBarButtonItem *addButton;
}

@property (strong, nonatomic) ubiaDevice *currentDevice;

@property (strong, nonatomic) NSArray *nameSectionArray;
@property (strong, nonatomic) NSArray *basicSectionArray;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *values;
@property (strong, nonatomic) NSIndexPath *selectCellPath;
@property (nonatomic) int newvalue;

@end
