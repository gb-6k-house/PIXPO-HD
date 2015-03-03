//
//  MMDeviceFileCmdCell.h
//  P4PCamLive
//
//  Created by Maxwell on 14/12/30.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMTableViewCell.h"


@protocol MMDeviceFileCmdCellDelegate  <NSObject>
//创建一个当点击imagebutton时显示title的信息
-(void)cellBtnAction:(int)tag action:(int)action;

@end

@protocol MMDeviceFileCellDelegate;

@interface MMDeviceFileCmdCell : MMTableViewCell<UITabBarControllerDelegate>
@property (nonatomic,assign) id <MMDeviceFileCmdCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITabBar *actionTabBar;

@end
