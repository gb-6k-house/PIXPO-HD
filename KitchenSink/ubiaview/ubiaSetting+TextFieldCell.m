//
//  ubiaSetting+TextFieldCell.m
//  P4PCamLive
//
//  Created by Maxwell on 13-5-15.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import "ubiaSetting+TextFieldCell.h"

@implementation ubiaSetting_TextFieldCell
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

- (IBAction)updateValue:(id)sender {
    return;
    NSLog(@"label [%@] value change to %@", attrLabel.text, attrValue.text);

    NSString *tmpKey = attrLabel.text;
    
    NSString *tmpValue = attrValue.text;
    
    NSArray *myKeys = [NSArray arrayWithObjects:tmpKey,nil];

    NSArray *myObjects = [NSArray arrayWithObjects: tmpValue,nil];
    NSDictionary *myTestDictionary = [NSDictionary dictionaryWithObjects:myObjects forKeys:myKeys];

    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"ubiaDeviceSettingNotification" object:nil userInfo: myTestDictionary];

    
}
@end
