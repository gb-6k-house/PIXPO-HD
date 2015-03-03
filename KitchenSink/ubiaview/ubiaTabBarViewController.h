//
//  ubiaTabBarViewController.h
//  P4PCamLive
//
//  Created by Maxwell on 13-5-6.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ubiaDevice.h"

@interface ubiaTabBarViewController : UITabBarController
{
    //ubiaDevice *currentDevice;
}

@property (strong, nonatomic) ubiaDevice *currentDevice;
//- (void) setDevice:(id)device;

@end
