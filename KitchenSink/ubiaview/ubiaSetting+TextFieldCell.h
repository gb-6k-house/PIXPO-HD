//
//  ubiaSetting+TextFieldCell.h
//  P4PCamLive
//
//  Created by Maxwell on 13-5-15.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ubiaSetting_TextFieldCell : UITableViewCell
{
}

@property (strong, nonatomic) IBOutlet UILabel *attrLabel;

@property (strong, nonatomic) IBOutlet UITextField *attrValue;
- (IBAction)updateValue:(id)sender;

@end
