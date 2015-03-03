//
//  MMDeviceFileCell.h
//  P4PCamLive
//
//  Created by Maxwell on 14/12/25.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMTableViewCell.h"
#import "ToggleButton.h"
enum{
    FILE_ACTION_TAG_EXPAND,
    FILE_ACTION_TAG_DOWNLOAD,
    FILE_ACTION_TAG_SHARE,
    FILE_ACTION_TAG_DELETE,
    FILE_ACTION_TAG_MORE
};

@protocol MMDeviceFileCellDelegate  <NSObject>
//创建一个当点击imagebutton时显示title的信息
-(void)cellBtnAction:(int)tag action:(int)action;

@end

@protocol MMDeviceFileCellDelegate;
@interface MMDeviceFileCell : MMTableViewCell

@property (nonatomic,assign) id <MMDeviceFileCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *FileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *UpdateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *FileSizeLabel;

@property (weak, nonatomic) IBOutlet ToggleButton *ExpandBtn;


@end
