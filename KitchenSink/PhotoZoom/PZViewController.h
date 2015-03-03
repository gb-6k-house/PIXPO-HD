//
//  PZViewController.h
//  PhotoZoom
//
//  Created by Brennan Stehling on 10/27/12.
//  Copyright (c) 2012 SmallSharptools LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ubiaDevice.h"
#import "PZPagingScrollView.h"
#import "PZPhotoView.h"

@interface PZViewController : UIViewController <PZPagingScrollViewDelegate, UIScrollViewDelegate, PZPhotoViewDelegate, UITabBarDelegate>

@property (strong, nonatomic) ubiaDevice *currentDevice;

@property (strong, nonatomic) IBOutlet PZPagingScrollView *pagingScrollView;

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UIButton *playbackBtn;
@property (weak, nonatomic) IBOutlet UIButton *goLiveBtn;

@property (weak, nonatomic) IBOutlet UIImageView *record_indicator;

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (weak, nonatomic) IBOutlet UIButton *temperaturemeter;

@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSString *timeString;

@end
