//
//  ubiaSecurityCodeViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 13-6-27.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  ubiaDevice;

@interface ubiaSecurityCodeViewController : UITableViewController
@property (nonatomic, strong) NSString *oldpassword;
@property (strong, nonatomic) ubiaDevice *currentDevice;

@end
