//
//  MMDeviceFileCmdCell.m
//  P4PCamLive
//
//  Created by Maxwell on 14/12/30.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMDeviceFileCmdCell.h"
#import "UIButton+Create.h"

@implementation MMDeviceFileCmdCell
@synthesize delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)btnAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSLog(@">>>>>>>>>>click cell.tag=%d, btn.tag=%d",self.tag,btn.tag);
    if (delegate) {
        [delegate cellBtnAction:self.tag action: btn.tag];  //将UILabel的内容传递到消息接收者
    }
}
@end
