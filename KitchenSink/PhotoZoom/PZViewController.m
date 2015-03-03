//
//  PZViewController.m
//  PhotoZoom
//
//  Created by Brennan Stehling on 10/27/12.
//  Copyright (c) 2012 SmallSharptools LLC. All rights reserved.
//

#import "PZViewController.h"

#import "PZPagingScrollView.h"
#import "PZPhotoView.h"

#import "MMAppDelegate.h"
#import "ubiaDeviceManager.h"

#import "ubiaSettingViewController.h"
#import "ubiaAlertViewController.h"

#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "KxMenu.h"

#import "ubiaRecordTabBarViewController.h"
#import "QPickerElement.h"
#import "PeriodPickerValueParser.h"
#import "Utilities.h"


#import "MMTransferTableViewController.h"
#import "ubiaAlertViewController.h"
#import "MMLocalRecordTableViewController.h"

#import "MMDeviceSettingController.h"

@interface PZViewController () 

@property (strong, nonatomic) NSArray *images;

@end

enum{
    TABBAR_ITEM_SNAPSHOT,
    TABBAR_ITEM_RECORD,
    TABBAR_ITEM_TALK,
    TABBAR_ITEM_VIDEO,
    TABBAR_ITEM_SETTING
};

@implementation PZViewController{
    BOOL isPortraitOrientation;
    __weak ubiaDeviceManager * deviceManager;
    BOOL isListening;
    BOOL isRecording;
    BOOL isTalking;
    UIColor *defaultTintColor;
    UIColor *myGray;
    UIColor *myBlue;
    
    UIBarButtonItem *snapBarItem;

    UIBarButtonItem *recordBarItem;

    UIBarButtonItem *listenBarItem;
    UIBarButtonItem *talkBarItem;
    
    UIBarButtonItem *alertBarItem;
    UIBarButtonItem *settingsBarItem;
    
    UIButton * rightStreamBtn;
    UITabBar * myTabBar;
   // NSString *recordFile;
    NSTimer *recordIndicatorTimer;
    BOOL showCesTemp;
    BOOL enableShowTemp;
}
@synthesize currentDevice;
@synthesize pagingScrollView;
@synthesize dateLabel,timeLabel,dateString,timeString;



#pragma mark - View Lifecycle
#pragma mark -

- (void)awakeFromNib
{
    dateLabel.text = dateString;
    timeLabel.text = timeString;
    
    _record_indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_REC_on.png"]];
    
    [self.view addSubview:_record_indicator];
    [self.view bringSubviewToFront:_record_indicator];
    
    showCesTemp = TRUE;
    enableShowTemp = FALSE;
    
    myGray = [UIColor lightGrayColor]; //[UIColor colorWithRed:102/255 green:102/255 blue:102/255 alpha:0.600];
    //myBlue = [UIColor colorWithRed:0.2314 green:0.7922 blue:0.99 alpha:1.0000];
    myBlue = [Utilities defaultFrontColor];
    //myBlue = [UIColor colorWithHue:192/255 saturation:100/255 brightness:95/255 alpha:1.0000];
}

- (void)viewWillAppear:(BOOL)animated {
    DebugLog(@"PZViewController==>viewWillAppear");
    [super viewWillAppear:animated];
    
    self.navigationItem.title = currentDevice.name;
    
    [self setupRightMenuButton];
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.rotationEnabled = TRUE;
    deviceManager = appDelegate.deviceManager;
    
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    
    int orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(orientation)){
        [self setPortraitOrientation: FALSE];
    }else{
        [self setPortraitOrientation: TRUE];
    }
    
    _playbackBtn.hidden = TRUE;
    
    _goLiveBtn.hidden = TRUE;
    
#if  0
    NSDate * stDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    dateString = [dateFormatter stringFromDate:stDate];
    
    [dateFormatter setDateFormat:@"a hh:mm:ss"];
    //[dateFormatter setLocale:[NSLocale currentLocale]];
    
    timeString = [dateFormatter stringFromDate:stDate];
#else
    dateString = @"";
    timeString = @"";
#endif
    dateLabel.text = dateString;
    timeLabel.text = timeString;
    
#if 0
    self.navigationController.toolbar.translucent = TRUE;
    self.navigationController.toolbar.tintColor = [UIColor grayColor];
    self.navigationController.navigationBar.translucent = TRUE;
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
#endif
    
    //[self setToolbarItems:self.customToolbarItems animated:FALSE];
    self.navigationController.toolbar.hidden = TRUE;
    //[self.navigationController setToolbarHidden:FALSE animated:FALSE];

    self.navigationController.navigationBar.hidden = FALSE;
    [self.navigationController setNavigationBarHidden:FALSE animated:FALSE];

    
    self.images = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"usnap_bg.png"],nil];
    self.pagingScrollView.pagingViewDelegate = self;
    self.pagingScrollView.backgroundColor = [UIColor whiteColor];
    [self.pagingScrollView displayPagingViewAtIndex:0];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.pagingScrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    });

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleubiaDeviceTimeUpdateNotification) name:@"ubiaDeviceTimeUpdateNotification" object:nil];
    [self registerForBackgroundNotifications];
    
    if (deviceManager.currentDevice.client.serverStreamIndex == 1) {
        //current is  mainstream
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"mainstream_txt", nil)];

    }else{
        //current is substream
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"substream_txt", nil)];
    }
    
    PZPhotoView * photoView = (PZPhotoView * )self.pagingScrollView.visiblePageView;
    deviceManager.imageView = photoView.imageView;
    [deviceManager startVideo];  //move to displayimage

    //self.tabBarController.tabBar.hidden = TRUE;
    
#if 1
    
    myTabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0.0,self.view.bounds.size.height - 50,self.view.bounds.size.width,50)];
    
    UITabBarItem * photoItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"p1_tab_snap", nil) image:[UIImage imageNamed:@"photo_off"] selectedImage:[UIImage imageNamed:@"photo_on"]];
    
    photoItem.tag = TABBAR_ITEM_SNAPSHOT;
    
    UITabBarItem * recordItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"p1_tab_record", nil) image:[UIImage imageNamed:@"record_off"] selectedImage:[UIImage imageNamed:@"record_on"]];
    recordItem.tag = TABBAR_ITEM_RECORD;
    
    UITabBarItem * talkItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"p1_tab_talk", nil) image:[UIImage imageNamed:@"mic_off"] selectedImage:[UIImage imageNamed:@"mic_off"]];
    talkItem.tag = TABBAR_ITEM_TALK;
    
    UITabBarItem * videoItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"p1_tab_video", nil) image:[UIImage imageNamed:@"record_tap_off"] selectedImage:[UIImage imageNamed:@"record_tap_on"]];
    videoItem.tag = TABBAR_ITEM_VIDEO;
    
    UITabBarItem * settingItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"p1_tab_setting", nil) image:[UIImage imageNamed:@"setting_off"] selectedImage:[UIImage imageNamed:@"setting_on"]];
    settingItem.tag = TABBAR_ITEM_SETTING;

    if (deviceManager.isMyDeviceView) {
        myTabBar.items = @[photoItem,recordItem, talkItem,videoItem,settingItem];
    }else{
        myTabBar.items = @[photoItem,recordItem,videoItem];
    }

    [self.view addSubview:myTabBar];
    
    [myTabBar setBackgroundColor:[UIColor whiteColor]];
    [myTabBar setTintColor:myBlue];
    
    myTabBar.delegate = self;
#endif
    
    
    if(isRecording == FALSE){
        _record_indicator.hidden = TRUE;
    }
    
//    [self logLayout];
    DebugLog(@"PZViewController<==viewWillAppear");
}

-(void) viewWillDisappear:(BOOL)animated{
    DebugLog(@"PZViewController==>viewWillDisappear");
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDelegate.deviceManager stopVideo];
    [appDelegate.deviceManager stopAudio];

    //set global rotation lock to portrait
    appDelegate.rotationEnabled = FALSE;
    
    if(isRecording){
        isRecording = FALSE;
        
        [recordBarItem setTintColor:myGray];
        recordBarItem.image = [UIImage imageNamed:@"record_off"];
        [deviceManager.currentDevice stopRecord];
        _record_indicator.hidden = TRUE;
        
        [myTabBar setSelectedItem:nil];
        
        [recordIndicatorTimer invalidate];
        //}
        //ubia_av_file_close();
        //UISaveVideoAtPathToSavedPhotosAlbum (recordFile, nil, nil, nil);
        
    }

    [super viewWillDisappear:animated];
    DebugLog(@"PZViewController<==viewWillDisappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    
    [super viewDidDisappear:animated];
}


//#pragma mark background notifications
- (void)registerForBackgroundNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(appWillResignActiveNotification)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(appWillEnterForegroundNotification)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
}

- (void) appWillEnterForegroundNotification{
    
    NSLog(@"PZViewController appWillEnterForegroundNotification ==>");
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    deviceManager = appDelegate.deviceManager;
    
    [NSThread sleepForTimeInterval:0.6]; //make sure the old backgroundJob is exit
    
    [deviceManager startVideo];
    
    NSLog(@"PZViewController appWillEnterForegroundNotification <==");
    
}

- (void) appWillResignActiveNotification{
    NSLog(@"PZViewController appWillResignActiveNotification ==>");
    //[self.navigationController popToRootViewControllerAnimated:NO];
     NSLog(@"PZViewController appWillResignActiveNotification <==");
}


-(void) setPortraitOrientation:(BOOL) isPortrait{
    
    isPortraitOrientation = isPortrait;
    
    [self showTempIndictor];
    
    if(FALSE == isPortraitOrientation){

        self.navigationController.navigationBarHidden = TRUE;
        self.navigationController.toolbar.hidden = TRUE;
        
        self.statusImage.hidden = TRUE;
        self.dateLabel.hidden = TRUE;
        
        self.timeLabel.hidden = TRUE;
        self.playbackBtn.hidden = TRUE;
        self.goLiveBtn.hidden = TRUE;

        self.tabBarController.tabBar.hidden = TRUE;
        
        _record_indicator.hidden = TRUE;

    }else{

        self.navigationController.navigationBarHidden = FALSE;
        self.navigationController.toolbar.hidden = FALSE;
        
        self.statusImage.hidden = FALSE;
        self.dateLabel.hidden = FALSE;
        self.timeLabel.hidden = FALSE;
        //self.playbackBtn.hidden = FALSE;
        //self.goLiveBtn.hidden = FALSE;
        
        self.tabBarController.tabBar.hidden = FALSE;
        
        if (isRecording) {
            _record_indicator.hidden = FALSE;
        }
    }
    
}

-(void) showTempIndictor{
    
    if ([currentDevice.client supportRealtimeTemperature] == 0 ||
        isPortraitOrientation == FALSE || self.navigationController.navigationBar.alpha == 0) {
        _temperaturemeter.hidden = TRUE;
        _temperatureLabel.hidden = TRUE;
    }else{
        _temperaturemeter.hidden = FALSE;
        _temperatureLabel.hidden = FALSE;
    }
}

-(void) updateLabelText{
    
    timeLabel.text = timeString;
    dateLabel.text = dateString;
    
    NSString *tempstr;

    if ([currentDevice.client supportRealtimeTemperature]) {
        float temp = currentDevice.client.temperature*1.0/100;
        
        if (FALSE == showCesTemp) {
            temp = temp * 1.8 + 32;
        }
        
        if(temp >0){
            tempstr = [NSString stringWithFormat:@"+%0.1f",temp];
        }else{
            tempstr = [NSString stringWithFormat:@"%0.1f",temp];
        }
        [_temperatureLabel setText:tempstr];
        
        [self showTempIndictor];
    }

    //self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",dateString, timeString ];

    
}

-(void) handleubiaDeviceTimeUpdateNotification{
#if  0
    NSDate *stDate = [[NSDate alloc] initWithTimeIntervalSince1970:(currentDevice.client.secondSince1970-currentDevice.client.deviceTimeZone * 3600)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    dateString = [dateFormatter stringFromDate:stDate];
    
    [dateFormatter setDateFormat:@"a hh:mm:ss"];
    //[dateFormatter setLocale:[NSLocale currentLocale]];
    
    timeString = [dateFormatter stringFromDate:stDate];
#else
    dateString = [Utilities utctimeToDateString:(currentDevice.client.secondSince1970-currentDevice.client.deviceTimeZone * 3600) withFmt:DATE_FORMAT_DMY];
    timeString = [Utilities utctimeToTimeString:(currentDevice.client.secondSince1970-currentDevice.client.deviceTimeZone * 3600)];
    
#endif
    //NSLog(@"Date=%@ Time=%@", dateLabel.text, timeLabel.text);
    
    [self performSelectorOnMainThread:@selector(updateLabelText) withObject:nil waitUntilDone:NO];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    // suspend tiling while rotating
    self.pagingScrollView.suspendTiling = TRUE;

    if(UIDeviceOrientationIsPortrait(toInterfaceOrientation)){
        self.navigationItem.title = currentDevice.name;
        [self setPortraitOrientation:TRUE];
        
    }else if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)){
        self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",dateString, timeString ];
        [self setPortraitOrientation:FALSE];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    self.pagingScrollView.suspendTiling = FALSE;
    [self.pagingScrollView resetDisplay];
    //[self handleOrientationLayout];
}

-(void) handleOrientationLayout{
    
    //int orientation = [[UIDevice currentDevice] orientation];
    //CGSize screen_bounds = [[UIScreen mainScreen] bounds].size;
    
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    int tabbar_height = myTabBar.frame.size.height;
    
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        if( [[UIScreen mainScreen] bounds].size.height >= 568 || [[UIScreen mainScreen] bounds].size.width >= 568 )
        {
            //IPHONE 5/5C/5S
            if(isPortraitOrientation){
                
                //imageView.frame = CGRectMake(0, (height - width*9/16)/2, width, width*9/16);
                
                _statusImage.frame = CGRectMake(10, 70, 50, 24);
                dateLabel.frame = CGRectMake(0, 60, width, 44);
                timeLabel.frame = CGRectMake(48, height-90, width-96, 44);
                _playbackBtn.frame = CGRectMake(0, height-90, 44, 44);
                _goLiveBtn.frame = CGRectMake(width-44,height-90, 44, 44);
                
                //_record_indicator.frame = CGRectMake(width/2 - 30, (height - width*9/16)/2, 60, 20);
                
                //_toolbar.frame = CGRectMake(0,height-44, width, 44);
                
            }else{
                //imageView.frame = CGRectMake(0, 0, width, height);
                
                _statusImage.frame = CGRectMake(10, 20, 50, 24);
                dateLabel.frame = CGRectMake(0, 10, width, 44);
                timeLabel.frame = CGRectMake(48, height-44, width-96, 44);
                
                _playbackBtn.frame = CGRectMake(0, height-44, 44, 44);
                _goLiveBtn.frame = CGRectMake(width-44,height-44, 44, 44);
                
                //_toolbar.frame = CGRectMake(0,height-44, width, 44);
            }
        }
        else
        {
            //IPHONE 4S/4/IPOD
            if(isPortraitOrientation){
                //imageView.frame = CGRectMake(0, 96, 320, 180);
                
                _statusImage.frame = CGRectMake(10, 20, 50, 24);
                dateLabel.frame = CGRectMake(0, 10, 320, 44);
                
                _playbackBtn.frame = CGRectMake(0, height-70, 44, 44);
                timeLabel.frame = CGRectMake(48, height- 44 - tabbar_height, 224, 44);
                _goLiveBtn.frame = CGRectMake(224,height-74, 44, 44);
                
                //_toolbar.frame = CGRectMake(0,height-44, 320, 44);
                
            }else{
                
                //imageView.frame = CGRectMake(0, 0, width, height);
                
                //statusImage.frame = CGRectMake(10, 20, 50, 24);
                dateLabel.frame = CGRectMake(0, 10, width, 44);
                
                _playbackBtn.frame = CGRectMake(0, height-44, 44, 44);
                timeLabel.frame = CGRectMake(48, height-44, width-96, 44);
                _goLiveBtn.frame = CGRectMake(width-44,height-44, 44, 44);
                
                //_toolbar.frame = CGRectMake(0,height-44, width, 44);
                
            }
            
        }
    }
    
}


#pragma mark - User Actions
#pragma mark -

- (void)takePhotoAnimation:(UIView *)view
{
    CATransition *shutterAnimation = [CATransition animation];
    shutterAnimation.delegate = self;
    shutterAnimation.duration = 0.5f;
    shutterAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    //@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip" @"cameraIris";
    
    NSString * type = @"suckEffect";
    
    shutterAnimation.type = type;
    shutterAnimation.subtype = type;
    [view.layer addAnimation:shutterAnimation forKey:type];
}

- (IBAction)captureSnapShot:(UITabBarItem *)sender {
    NSLog(@"click captureSnapShot");
    //[self.view setTintColor:[UIColor redColor]];
    [deviceManager saveSnapShot];
    
    [self takePhotoAnimation:deviceManager.imageView];
}


- (IBAction)saveSnapShot:(UIBarButtonItem *)sender {
    NSLog(@"click snapshot");
    snapBarItem.image = [UIImage imageNamed:@"photo_on"];
    [deviceManager saveSnapShot];
    snapBarItem.image = [UIImage imageNamed:@"photo_off"];
}

-(void) toggleRecordIndicator{
    static int index;
    if (0 == (index++ % 2)) {
        _record_indicator.image = [UIImage imageNamed:@"record_REC_on"];

    }else{
        _record_indicator.image = [UIImage imageNamed:@"record_REC_off"];
    }
}

- (IBAction)handleClickRecordBtn:(UIBarButtonItem *)sender {
    if(isRecording){
        isRecording = FALSE;
        
        [recordBarItem setTintColor:myGray];
        recordBarItem.image = [UIImage imageNamed:@"record_off"];
        [deviceManager.currentDevice stopRecord];
        _record_indicator.hidden = TRUE;
        
        [myTabBar setSelectedItem:nil];
        
        [recordIndicatorTimer invalidate];
        //}
        //ubia_av_file_close();
        //UISaveVideoAtPathToSavedPhotosAlbum (recordFile, nil, nil, nil);
        
    }else{
        isRecording = TRUE;
        [recordBarItem setTintColor:myBlue];
        recordBarItem.image = [UIImage imageNamed:@"record_on"];
        [deviceManager.currentDevice startRecord];
        

        _record_indicator.hidden = FALSE;
        
        recordIndicatorTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(toggleRecordIndicator) userInfo:nil repeats:YES];
        [recordIndicatorTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        
        [self.pagingScrollView bringSubviewToFront:_record_indicator];
        //_record_indicator.frame = CGRectMake(120.0, deviceManager.imageView.frame.origin.y+10, 60, 20);
        
    }
    NSLog(@"click Record");
    
}

- (IBAction)handleClickListenBtn:(UIBarButtonItem *)sender {
    if(isListening){

        //if (deviceManager.audioPlayRoute == 0) {
        //    [listenBarItem setTintColor:[UIColor redColor]];
         //   listenBarItem.image = [UIImage imageNamed:@"sound_on"];
            
        //    [deviceManager changePlayAudioRoute:1];
       // }else{
            isListening = FALSE;
            [deviceManager changePlayAudioRoute:0];
            //[listenBarItem setTintColor:defaultTintColor];
            [listenBarItem setTintColor:myGray];
            listenBarItem.image = [UIImage imageNamed:@"sound_off"];
            [deviceManager startListen];
        //}
        
    }else{
        isListening = TRUE;
        [listenBarItem setTintColor:myBlue];
        listenBarItem.image = [UIImage imageNamed:@"sound_on"];
        [deviceManager changePlayAudioRoute:1];
        [deviceManager startListen];

    }

    NSLog(@"click listen");

}

- (IBAction)handleClickTalkBtn:(UIBarButtonItem *)sender {
    
    if(isTalking){
        [talkBarItem setTintColor:myGray];
        talkBarItem.image = [UIImage imageNamed:@"mic_off"];
        isTalking = FALSE;
        NSLog(@"stop Talk");
    }else{
        
        [talkBarItem setTintColor:myBlue];
        talkBarItem.image = [UIImage imageNamed:@"mic_on"];

        isTalking = TRUE;
        NSLog(@"start Talk");
    }
    [deviceManager startTalk];
}

- (IBAction)handleClickTalkBarBtn:(UITabBarItem *)sender {
    
    if(isTalking){
        [sender setSelectedImage:[UIImage imageNamed:@"mic_off"]];
        [sender setImage:[UIImage imageNamed:@"mic_off"]];
        [myTabBar setSelectedItem:nil];
        isTalking = FALSE;
        NSLog(@"stop Talk");
    }else{
        
        [sender setSelectedImage:[UIImage imageNamed:@"mic_on"]];
        [sender setImage:[UIImage imageNamed:@"mic_on"]];
        
        isTalking = TRUE;
        NSLog(@"start Talk");
    }
    [deviceManager startTalk];
}

- (IBAction)handleClickAlertBtn:(UIBarButtonItem *)sender {
    
    alertBarItem.image = [UIImage imageNamed:@"video_on"];
    [deviceManager stopVideo];
    //[deviceManager stopAudio];
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:appDelegate.storyboardName bundle:nil];
#if 0
    ubiaAlertViewController * destView = [storyboard instantiateViewControllerWithIdentifier:@"UBIA_DEVICE_ACTIVITY_VIEW"];
    
    destView.currentDevice = currentDevice;
    [self.navigationController setToolbarHidden:FALSE animated:FALSE];
    [deviceManager.queriedAlerts removeAllObjects];
    //[self presentViewController:destView animated:YES completion:nil];
    alertBarItem.image = [UIImage imageNamed:@"message_off"];
    [self.navigationController pushViewController:destView animated:YES];
#else
#if 1
    ubiaRecordTabBarViewController *tabbarViewer= [storyboard instantiateViewControllerWithIdentifier:@"RECORD_TABBAR_VIEWER"];
#else
    ubiaRecordTabBarViewController *tabbarViewer = [[ubiaRecordTabBarViewController alloc] init];
    tabbarViewer.deviceManager = deviceManager;
    
    tabbarViewer.deviceView = [storyboard instantiateViewControllerWithIdentifier:@"UBIA_DEVICE_ACTIVITY_VIEW"];
    //tabbarViewer.cloudview = [storyboard instantiateViewControllerWithIdentifier:@"MM_DEVICE_FILELIST_VIEW"];
    tabbarViewer.localview = [storyboard instantiateViewControllerWithIdentifier:@"MM_DEVICE_FILELIST_VIEW"];

    tabbarViewer.transferview = [storyboard instantiateViewControllerWithIdentifier:@"MM_DEVICE_TRANSFER_VIEW"];
    
    //tabbarViewer.viewControllers =[NSArray arrayWithObjects:tabbarViewer.deviceView,tabbarViewer.localview,nil];
    
    [tabbarViewer addChildViewController: tabbarViewer.deviceView];
    [tabbarViewer addChildViewController: tabbarViewer.transferview];
    [tabbarViewer addChildViewController: tabbarViewer.localview];
#endif
    
    [self.navigationController setToolbarHidden:TRUE animated:FALSE];
    [deviceManager.queriedAlerts removeAllObjects];
    
    //[self presentViewController:destView animated:YES completion:nil];
    alertBarItem.image = [UIImage imageNamed:@"message_off"];
    
    [self.navigationController pushViewController:tabbarViewer animated:YES];
 
#endif
}

- (IBAction)handleClickSettingsBtn:(UIBarButtonItem *)sender {
    //NSLog(@"segue prepare to %@",[segue identifier]);
    
    settingsBarItem.image = [UIImage imageNamed:@"setting_on"];
    
    [deviceManager stopVideo];
    //[deviceManager stopAudio];
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:appDelegate.storyboardName bundle:nil];
    ubiaSettingViewController * destView = [storyboard instantiateViewControllerWithIdentifier:@"UBIA_DEVICE_SETTINGS_VIEW"];
    
    destView.currentDevice = currentDevice;
    [self.navigationController setToolbarHidden:TRUE animated:FALSE];
    //[self presentViewController:destView animated:YES completion:nil];
      settingsBarItem.image = [UIImage imageNamed:@"setting_off"];
    [self.navigationController pushViewController:destView animated:YES];
}

- (IBAction)handlePlaybackBtn:(id)sender {
    _goLiveBtn.hidden = FALSE;
    _statusImage.image = [UIImage imageNamed:@"rec"];
}
- (IBAction)handleGoLiveBtn:(id)sender {
    _goLiveBtn.hidden = TRUE;
    _statusImage.image = [UIImage imageNamed:@"live"];
}

- (void)showMaximumSize:(id)sender {
    PZPhotoView *photoView = (PZPhotoView *)self.pagingScrollView.visiblePageView;
    [photoView updateZoomScale:photoView.maximumZoomScale];
}

- (void)showMediumSize:(id)sender {
    PZPhotoView *photoView  = (PZPhotoView *)self.pagingScrollView.visiblePageView;
    float newScale = (photoView.minimumZoomScale + photoView.maximumZoomScale) / 2.0;
    [photoView updateZoomScale:newScale];
}

- (void)showMinimumSize:(id)sender {
    PZPhotoView *photoView  = (PZPhotoView *)self.pagingScrollView.visiblePageView;
    [photoView updateZoomScale:photoView.minimumZoomScale];
}

- (void)toggleFullScreen {
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (systemVersion < 7.0) {
        //only work on < IOS 7.0
        return;
    }
    if(deviceManager.currentDevice.client.status != UBIA_CLIENT_STATUS_AUTHORIZED){
        
        PZPhotoView * photoView = (PZPhotoView * )self.pagingScrollView.visiblePageView;
        UIImage *image = [self.images objectAtIndex:0];
        [photoView displayImage:image];
        if (deviceManager.currentDevice.client.status == UBIA_CLIENT_STATUS_ERROR) {
            if (deviceManager.currentDevice.client.errCode == AV_ER_WRONG_VIEWACCorPWD) {
#if 1
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                        message:NSLocalizedString(@"device_password_wrong", nil)
                                        delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
                [alert show];
                return;
#endif
            }
        }

        [deviceManager startVideo];
        return;
    }
    if (self.navigationController.navigationBar.alpha == 0.0) {
        // fade in navigation
        
        [UIView animateWithDuration:0.4 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationNone];
            self.navigationController.navigationBar.alpha = 1.0;
            self.navigationController.toolbar.alpha = 1.0;
            dateLabel.hidden = FALSE;
            timeLabel.hidden = FALSE;

            _statusImage.hidden = FALSE;
            _playbackBtn.hidden  = TRUE;
            _goLiveBtn.hidden = TRUE;
            
            myTabBar.hidden = FALSE;
            [self showTempIndictor];
            
        } completion:^(BOOL finished) {
        }];
    }
    else {
        // fade out navigation
        
        [UIView animateWithDuration:0.4 animations:^{
            [[UIApplication sharedApplication] setStatusBarHidden:TRUE withAnimation:UIStatusBarAnimationFade];
            self.navigationController.navigationBar.alpha = 0.0;
            self.navigationController.toolbar.alpha = 0.0;
            dateLabel.hidden = TRUE;
            timeLabel.hidden = TRUE;
            
            _statusImage.hidden = TRUE;
            _playbackBtn.hidden  = TRUE;
            _goLiveBtn.hidden = TRUE;
            
            myTabBar.hidden = TRUE;
            [self showTempIndictor];
            
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Layout Debugging Support
#pragma mark -

- (void)logRect:(CGRect)rect withName:(NSString *)name {
    DebugLog(@"%@: %f, %f / %f, %f", name, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

- (void)logLayout {
    DebugLog(@"### PZViewController ###");
    [self logRect:self.view.window.bounds withName:@"self.view.window.bounds"];
    [self logRect:self.view.window.frame withName:@"self.view.window.frame"];

    CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
    [self logRect:applicationFrame withName:@"application frame"];
    
    if ([self.pagingScrollView respondsToSelector:@selector(logLayout)]) {
        [self.pagingScrollView performSelector:@selector(logLayout)];
    }
}

#pragma mark - Orientation
#pragma mark -


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return TRUE;
}

#pragma mark - PZPagingScrollViewDelegate
#pragma mark -

- (Class)pagingScrollView:(PZPagingScrollView *)pagingScrollView classForIndex:(NSUInteger)index {
    // all page views are photo views
    return [PZPhotoView class];
}

- (NSUInteger)pagingScrollViewPagingViewCount:(PZPagingScrollView *)pagingScrollView {
    return self.images.count;
}

- (UIView *)pagingScrollView:(PZPagingScrollView *)pagingScrollView pageViewForIndex:(NSUInteger)index {
    DebugLog(@"PZViewContoller==>pageViewForIndex");
    PZPhotoView *photoView = [[PZPhotoView alloc] initWithFrame:self.view.bounds];
    photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    photoView.photoViewDelegate = self;
    
    DebugLog(@"PZViewContoller<==pageViewForIndex");
    return photoView;
}

- (void)pagingScrollView:(PZPagingScrollView *)pagingScrollView preparePageViewForDisplay:(UIView *)pageView forIndex:(NSUInteger)index {
    DebugLog(@"PZViewContoller==>preparePageViewForDisplay[%d]",index);
    assert([pageView isKindOfClass:[PZPhotoView class]]);
    assert(index < self.images.count);
    
    PZPhotoView *photoView = (PZPhotoView *)pageView;
    UIImage *image = [self.images objectAtIndex:index];
    [photoView setMaximumZoomScale: 8.0];
    [photoView setMinimumZoomScale: 1.0];
    [photoView displayImage:image];
    
    //[deviceManager startVideo];
    DebugLog(@"PZViewContoller<==preparePageViewForDisplay");
}

#pragma mark - PZPhotoViewDelegate
#pragma mark -

- (void)photoViewDidSwipe:(PZPhotoView *)photoView {
    //DebugLog(@"swipe");
}

- (void)photoViewDidSingleTap:(PZPhotoView *)photoView {
    [self toggleFullScreen];
}

- (void)photoViewDidDoubleTap:(PZPhotoView *)photoView {
    // do nothing
    //DebugLog(@"photoViewDidDoubleTap");
}

- (void)photoViewDidTwoFingerTap:(PZPhotoView *)photoView {
    // do nothing
    //DebugLog(@"photoViewDidTwoFingerTap");

}

- (void)photoViewDidDoubleTwoFingerTap:(PZPhotoView *)photoView {
    //DebugLog(@"photoViewDidDoubleTwoFingerTap==>");
    [self logLayout];
}

#pragma menu



-(void)setupRightMenuButton{
    //MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    
    
    //UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(shareCamera:)];
#if 0
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showMenu:)];
    
    [self.navigationItem setRightBarButtonItem:rightButton animated:YES];
    
#else
    
#if 0
    rightStreamBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightStreamBtn setFrame:CGRectMake(60, self.view.frame.size.height-16-29, 29, 29)];
    [rightStreamBtn setImage:[UIImage imageNamed:@"VideoSD"] forState:UIControlStateNormal];
    //[addBtn addTarget:self action:@selector(shareCamera:) forControlEvents:UIControlEventTouchUpInside];
    [rightStreamBtn addTarget:self action:@selector(switchStream) forControlEvents:UIControlEventTouchUpInside];
    [rightStreamBtn setShowsTouchWhenHighlighted:YES];//设置发光
#endif

    //UIBarButtonItem *addBarBtn = [[UIBarButtonItem alloc]initWithCustomView:rightStreamBtn];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithTitle:        NSLocalizedString(@"substream_txt", nil) style:0 target:self action:@selector(switchStream)];
    
    [self.navigationItem setRightBarButtonItem:rightBarBtn animated:YES];
#endif
    
}

- (void) createPickerRoot
{
    QRootElement *root = [[QRootElement alloc] init];
    root.controllerName = @"easySelectDeviceController";
    root.title = @"Picker";
    root.grouped = YES;
    
    NSArray *component1 = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"];
    NSArray *component2 = @[@"A", @"B"];
    QPickerElement *simplePickerEl = [[QPickerElement alloc] initWithTitle:@"Key" items:@[component1, component2] value:@"3\tB"];
    
    __weak QPickerElement *_simplePickerEl = simplePickerEl;
    
    simplePickerEl.onValueChanged = ^(QRootElement *el){
        NSLog(@"Selected indexes: %@", [_simplePickerEl.selectedIndexes componentsJoinedByString:@","]);
    };
    
    QSection *simplePickerSection = [[QSection alloc] initWithTitle:@"Picker element"];
    [simplePickerSection addElement:simplePickerEl];
    [root addSection:simplePickerSection];
    
    QSection *customParserSection = [[QSection alloc] initWithTitle:@"Custom value parser"];
    
    PeriodPickerValueParser *periodParser = [[PeriodPickerValueParser alloc] init];
    
    QPickerElement *periodPickerEl =
    [[QPickerElement alloc] initWithTitle:@"Period"
                                    items:[NSArray arrayWithObject:periodParser.stringPeriods]
                                    value:[NSNumber numberWithUnsignedInteger:NSMonthCalendarUnit]];
    
    periodPickerEl.valueParser = periodParser;
    __weak QPickerElement *_periodPickerEl = periodPickerEl;
    periodPickerEl.onValueChanged = ^(QRootElement *el){ NSLog(@"New value: %@", _periodPickerEl.value); };
    
    [customParserSection addElement:periodPickerEl];
    [root addSection:customParserSection];
    //[self.navigationController presentViewController:[QuickDialogController controllerForRoot:root] animated:YES completion:(void (^)(void))nil];
    [self.navigationController pushViewController:[QuickDialogController controllerForRoot:root] animated:YES];
    
}

- (void)shareCamera:(UIBarButtonItem *)sender{
    [self createPickerRoot];
    
}

- (void)showMenu:(UIBarButtonItem *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:NSLocalizedString(@"mainstream_txt", nil)
                     image:nil                    target:self
                    action:@selector(switchMainStream)],
      
      [KxMenuItem menuItem:NSLocalizedString(@"substream_txt", nil)
                     image:nil
                    target:self
                    action:@selector(switchSubStream)],
      ];

    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    
    UIView *targetView = (UIView *)[self.navigationItem.rightBarButtonItem performSelector:@selector(view)];
    CGRect rect = targetView.frame;
    rect.origin.y += 24;
    
    static BOOL menuIsShowing = FALSE;
    if (FALSE == menuIsShowing) {
        menuIsShowing = TRUE;
        [KxMenu showMenuInView:self.view fromRect:rect menuItems:menuItems];
    }else{
        [KxMenu dismissMenu];
        menuIsShowing = FALSE;
    }
}

-(void) switchMainStream
{
    [deviceManager stopVideo];
    [NSThread sleepForTimeInterval:0.4];
    [deviceManager.currentDevice.client logoutDevice];
    deviceManager.currentDevice.client.serverStreamIndex = 1;

    [deviceManager startVideo];
}
-(void) switchSubStream{

    [deviceManager stopVideo];
    
    [NSThread sleepForTimeInterval:0.4];
    [deviceManager.currentDevice.client logoutDevice];
    deviceManager.currentDevice.client.serverStreamIndex = 0;

    [deviceManager startVideo];
}

-(void) switchStream{

    //stop listen first
    [deviceManager changePlayAudioRoute:0];
    [deviceManager startListen];
    //stop video
    [deviceManager stopVideo];
    [NSThread sleepForTimeInterval:0.4];
    [deviceManager.currentDevice.client logoutDevice];

    if (deviceManager.currentDevice.client.serverStreamIndex == 0) {
        //current is substream
        deviceManager.currentDevice.client.serverStreamIndex = 1;
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"mainstream_txt", nil)];
        //[rightStreamBtn setImage:[UIImage imageNamed:@"VideoHD"] forState:UIControlStateNormal];
    }else{
        //current is mainstream
        deviceManager.currentDevice.client.serverStreamIndex = 0;
        //[rightStreamBtn setImage:[UIImage imageNamed:@"VideoSD"] forState:UIControlStateNormal ];
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"substream_txt", nil)];
    }

    [deviceManager startVideo];
}
-(void) delayclearTabbar{
    [myTabBar setSelectedItem:nil];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case TABBAR_ITEM_SNAPSHOT:
            [self captureSnapShot:item];
            
            [self performSelector:@selector(delayclearTabbar) withObject:nil afterDelay:0.5];
            break;
        case TABBAR_ITEM_RECORD:
            [self handleClickRecordBtn:NULL];
            break;
        case TABBAR_ITEM_TALK:
            [self handleClickTalkBarBtn:item];
            break;
        case TABBAR_ITEM_VIDEO:
            [self handleClickAlertBtn:NULL];
            break;
        case TABBAR_ITEM_SETTING:
            //[self handleClickSettingsBtn:NULL];
            {
                MMDeviceSettingController * devSetting = [MMDeviceSettingController initWithDevice:currentDevice];
                [self.navigationController pushViewController:devSetting animated:YES];
            }
            break;
        default:
            break;
    }
}
- (IBAction)switchtemperaturemeter:(UIButton *)sender{
    if (showCesTemp) {
        showCesTemp = FALSE;
        [_temperaturemeter setImage:[UIImage imageNamed:@"Temperature_F"] forState:UIControlStateNormal];
    }else{
        showCesTemp = TRUE;
        [_temperaturemeter setImage:[UIImage imageNamed:@"Temperature_C"] forState:UIControlStateNormal];
    }
}


@end
