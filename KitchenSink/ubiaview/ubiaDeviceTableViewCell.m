//
//  ubiaDeviceTableViewCell.m
//  P4PCamLive
//
//  Created by Maxwell on 13-5-5.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import "ubiaDeviceTableViewCell.h"

@implementation ubiaDeviceTableViewCell
@synthesize nameLabel;
@synthesize statusLabel;
@synthesize snapImageView;
@synthesize uid;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
