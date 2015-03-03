//
//  ubiaSettingSheetViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 13-5-22.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ubiaSettingSheetViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray *itemArray;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,assign) int checkedIndex;

@end
