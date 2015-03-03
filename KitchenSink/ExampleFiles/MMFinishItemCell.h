//
//  MMFinishItemCell.h
//  P4PCamLive
//
//  Created by Maxwell on 14/12/29.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMTableViewCell.h"

@interface MMFinishItemCell : MMTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *FileIcon;
@property (weak, nonatomic) IBOutlet UILabel *FileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *UpdataTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *FileSizeLabel;

@end
