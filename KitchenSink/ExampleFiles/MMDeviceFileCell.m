//
//  MMDeviceFileCell.m
//  P4PCamLive
//
//  Created by Maxwell on 14/12/25.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMDeviceFileCell.h"

@implementation MMDeviceFileCell
@synthesize delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryCheckmarkColor:[UIColor colorWithRed:13.0/255.0
                                                         green:88.0/255.0
                                                          blue:161.0/255.0
                                                         alpha:1.0]];

    }
    return self;
}

-(void)updateContentForNewContentSize{
    if([[UIFont class] respondsToSelector:@selector(preferredFontForTextStyle:)]){
        [self.textLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    }
}
- (IBAction)ClickExpandBtn:(id)sender {
    NSLog(@"click expand");
    if (delegate) {
        [delegate cellBtnAction:self.tag action: FILE_ACTION_TAG_EXPAND];  //将UILabel的内容传递到消息接收者
    }
}

@end
