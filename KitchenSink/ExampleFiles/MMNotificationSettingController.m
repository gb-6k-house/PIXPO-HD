//
//  MMNotificationSettingController.m
//  P4PLive
//
//  Created by Maxwell on 14-5-6.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMNotificationSettingController.h"
#import "MMAppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"

#import "ubiaLocalConfig.h"
#import "ubiaRestClient.h"
#import "ubiaDeviceManager.h"


@interface MMNotificationSettingController ()

@end

@implementation MMNotificationSettingController{
    __weak ubiaDeviceManager * deviceManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        //self.root.appearance.tableGroupedBackgroundColor =  [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];
        
        //MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        //restClient = appDelegate.deviceManager.restClient;
        
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    deviceManager = appDelegate.deviceManager;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onVoiceAction:(QBooleanElement *)buttonElement {
    [deviceManager setAudioNotification:[buttonElement boolValue]];
}
- (void)onVibrateAction:(QBooleanElement *)buttonElement {
    
    [deviceManager setAlertNotification:[buttonElement boolValue]];
    
#if 0
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
#endif
    
    
}

-(void)onNoDisturbAction:(QRadioElement *)buttonElement{
    NSLog(@"selected %d",[buttonElement selected] );
    [deviceManager handleSlientMode:[buttonElement selected]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
}

@end
