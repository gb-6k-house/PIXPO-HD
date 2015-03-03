//
//  ubiaTabBarViewController.m
//  P4PCamLive
//
//  Created by Maxwell on 13-5-6.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import "ubiaTabBarViewController.h"
#import "ubiaDevice.h"

#import "ubiaAlertViewController.h"
#import "ubiaSnapshotCollectionViewController.h"
#import "ubiaDeviceSettingViewController.h"


@interface ubiaTabBarViewController ()

@end

@implementation ubiaTabBarViewController
@synthesize currentDevice;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
        
    ubiaAlertViewController *alertview = [self.viewControllers objectAtIndex:0];
    alertview.currentDevice = self.currentDevice;
    
    ubiaSnapshotCollectionViewController *snapView = [self.viewControllers objectAtIndex:1];
    snapView.currentDevice = self.currentDevice;
    
    ubiaDeviceSettingViewController *settingView = [self.viewControllers objectAtIndex:2];
    
    settingView.currentDevice = self.currentDevice;

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    int tabitem = tabBarController.selectedIndex;
    NSLog(@"didSelectViewController %d", tabitem);
    switch (tabitem) {
        case 3:
        {
            ubiaDeviceSettingViewController *setting = (ubiaDeviceSettingViewController *)[tabBarController.viewControllers objectAtIndex:tabitem];
            
            setting.currentDevice  =  currentDevice;
        }
        break;
            
        default:
            break;
    }
    
    [[tabBarController.viewControllers objectAtIndex:tabitem] popToRootViewControllerAnimated:YES];
}

@end
