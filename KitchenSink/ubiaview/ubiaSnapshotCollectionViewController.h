//
//  ubiaSnapshotCollectionViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 13-5-18.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ubiaDevice;
@interface ubiaSnapshotCollectionViewController : UICollectionViewController

@property (strong, nonatomic) ubiaDevice *currentDevice;
@property (strong, nonatomic) NSArray *snapList;

@end
