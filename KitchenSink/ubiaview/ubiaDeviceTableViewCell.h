//
//  ubiaDeviceTableViewCell.h
//  P4PCamLive
//
//  Created by Maxwell on 13-5-5.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ubiaDeviceTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UIImageView *snapImageView;

@property (nonatomic,strong) NSString *uid;

@end
