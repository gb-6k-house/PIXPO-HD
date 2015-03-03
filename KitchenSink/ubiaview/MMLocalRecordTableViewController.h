//
//  MMLocalRecordTableViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 14/12/23.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ubiaDevice;

@interface MMLocalRecordTableViewController : UITableViewController

@property (strong, nonatomic) ubiaDevice *currentDevice;
@property (strong, nonatomic) NSMutableArray *itemArrary;
- (void)switchShowType:(BOOL)byFile;

@end
