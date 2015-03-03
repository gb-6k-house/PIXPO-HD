//
//  ubiaLabel+TextFieldCell.m
//  P4PCamLive
//
//  Created by Maxwell on 13-5-14.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import "ubiaLabel+TextFieldCell.h"

@implementation ubiaLabel_TextFieldCell
@synthesize attrLabel;
@synthesize attrValue;

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
