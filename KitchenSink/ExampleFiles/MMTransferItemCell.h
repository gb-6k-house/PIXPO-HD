//
//  MMTransferItemCell.h
//  P4PCamLive
//
//  Created by Maxwell on 14/12/28.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMTableViewCell.h"
#import "CircularProgressView.h"
#import "ToggleButton.h"
#import "ubiaFileNode.h"

@interface MMTransferItemCell : MMTableViewCell<FileNodeDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *FileIcon;
@property (weak, nonatomic) IBOutlet UILabel *FileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TransferStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *TransferSpeedLabel;
@property (weak, nonatomic) IBOutlet CircularProgressView *progressView;
@property (weak, nonatomic) IBOutlet ToggleButton *StartOrPauseButton;
@property (assign, nonatomic) BOOL onTransfering;

@end
