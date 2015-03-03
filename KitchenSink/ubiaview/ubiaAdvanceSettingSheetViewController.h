//
//  ubiaAdvanceSettingSheetViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 13-6-14.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ubiaAdvanceSettingSheetViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *itemArray;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,assign) int checkedIndex;

@end
