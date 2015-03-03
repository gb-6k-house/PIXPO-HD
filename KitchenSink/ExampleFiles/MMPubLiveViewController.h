//
//  MMPubLiveViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 13-5-18.
//  Copyright (c) 2013年 ubia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class VideoFrameExtractor;
//@class ubiaP4PController;
@class ubiaDevice;
@class MMImageViewer;
#import "MMExampleViewController.h"

#include "REMenu.h"

@interface MMPubLiveViewController : MMExampleViewController{
	CFStringRef		recordFilePath;
    BOOL isBackgroundThreadRunning;
 //   NSLock * liveViewLock;
 //   NSData *pngData;
}
@property (strong, nonatomic) IBOutlet MMImageViewer *imageView;

@property (strong, nonatomic) ubiaDevice *currentDevice;
//@property (weak, nonatomic)   VideoFrameExtractor *video;
//@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (strong, nonatomic) id preViewController;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeft;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRight;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeUp;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeDown;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapped;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *listenBarItem;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) IBOutlet UIImageView *statusImage;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSString *timeString;

@property (strong, nonatomic) IBOutlet UIButton *playbackBtn;

@property (strong, nonatomic) IBOutlet UIButton *goLiveBtn;

@property (nonatomic, assign) BOOL  inBackground;
@property (nonatomic, assign) BOOL  showNavBar;

@property (strong, nonatomic) REMenu *menu;

- (void)registerForBackgroundNotifications;

- (void)configureView;
@end
