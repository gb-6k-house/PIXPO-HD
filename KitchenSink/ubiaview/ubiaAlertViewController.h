//
//  ubiaAlertViewController.h
//  P4PCamLive
//
//  Created by work on 13-4-17.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMExampleTableViewController.h"
#import "MMDeviceFileCell.h"
#import "MMDeviceFileCmdCell.h"
#import "ubiaQueryInfo.h"

@class ubiaDevice;

@interface ubiaAlertViewController : MMExampleTableViewController<MMDeviceFileCellDelegate, MMDeviceFileCmdCellDelegate>

//UITableViewController

@property (strong, nonatomic) ubiaDevice *currentDevice;
@property (strong, nonatomic) NSMutableArray *alertArrary;
@property (strong, nonatomic) NSMutableArray *fileArrary;
@property (strong, nonatomic) NSIndexPath *selectedIndex;
@property (strong, nonatomic) ubiaQueryInfo *fileQueryParam;
@property (strong, nonatomic) ubiaQueryInfo *alertQueryParam;

@property (assign, nonatomic) int header_height;

- (void)switchShowType:(BOOL)byFile ;
//-(NSDate *) GMTNow;

@end
