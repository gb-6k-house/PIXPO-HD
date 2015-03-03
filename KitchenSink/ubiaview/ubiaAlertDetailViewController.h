//
//  ubiaAlertDetailViewController.h
//  P4PCamLive
//
//  Created by work on 13-4-17.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ubiaDevice;
@class ubiaAlert;
@class VideoFrameExtractor;
@class MMActivity;
@class MMImageViewer;

@interface ubiaAlertDetailViewController : UIViewController
{
    NSLock * liveViewLock;
}

@property (strong, nonatomic) ubiaDevice *currentDevice;
//@property (weak, nonatomic)   VideoFrameExtractor *video;

@property (weak, nonatomic) MMActivity *activity;
@property (strong, nonatomic) ubiaAlert *alert;
@property (strong, nonatomic) IBOutlet MMImageViewer *imageViewer;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *statusImage;
@property (strong, nonatomic) IBOutlet UIButton *playbackBtn;
//@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UILabel * detailInfoLabel;
@end
