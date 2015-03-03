//
//  MMTransferTableViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 14/12/29.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMExampleTableViewController.h"
#import "ubiaDevice.h"
#import "CircularProgressView.h"

#define MAX_TRANSFER_ITEM_IN_LIST 128

@class ubiaFileNode;
@interface MMTransferTableViewController : MMExampleTableViewController<CircularProgressViewDelegate>

@property (strong, nonatomic) ubiaDevice *currentDevice;
@property (strong, nonatomic) NSMutableArray *finshedItemArrary;
@property (strong, nonatomic) NSMutableArray *downloadingItemArrary;
@property (strong, nonatomic) NSMutableArray *uploadingItemArrary;
@property (assign, nonatomic) int badgeNum;

- (void) addTabBarBadge:(int) num;
- (void) addDownloadItem:(ubiaFileNode *) fileNode;
- (void) addUploadItem:(ubiaFileNode *) fileNode;

- (void) playerDidFinishPlaying;
- (void) updateProgressViewWithPlayer:(AVAudioPlayer *)player;
@end
