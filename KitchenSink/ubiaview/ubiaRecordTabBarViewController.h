//
//  ubiaRecordTabBarViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 14/12/20.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ubiaDeviceManager.h"
@class ubiaAlertViewController;
@class MMLocalRecordTableViewController;
@class MMTransferTableViewController;

@interface ubiaRecordTabBarViewController : UITabBarController<UITabBarControllerDelegate>

@property (nonatomic,weak) ubiaDeviceManager *deviceManager;
@property (nonatomic,assign) BOOL showByFile;
@property (nonatomic,strong) ubiaAlertViewController * deviceView;
@property (nonatomic,strong) MMLocalRecordTableViewController * cloudview;
@property (nonatomic,strong) MMTransferTableViewController * transferview;
@property (nonatomic,strong) MMLocalRecordTableViewController * localview;
@end
