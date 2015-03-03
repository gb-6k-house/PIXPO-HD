//
//  MMPubLiveViewController.m
//  P4PCamLive
//
//  Created by Maxwell on 13-5-18.
//  Copyright (c) 2013年 ubia. All rights reserved.
//
#import <AudioToolBox/AudioQueue.h>
#import <AudioToolBox/AudioSession.h>

#import "MMActivitiesDetailController.h"

#import "ubiaAlertViewController.h"
#import "ubiaSettingViewController.h"

#import "ubiaTabBarViewController.h"
//#import "ubiaP4PController.h"

#import "ubiaDevice.h"
#import "ubiaClient.h"

#import "ubiaAlert.h"

//#import "VideoFrameExtractor.h"

#define SUPPORT_AUDIO

//#import "ubiaAQPlayController.h"
//#import "ubiaAQRecordController.h"

#import "MMAppDelegate.h"
#import "MMImageViewer.h"

#import "ubiaDeviceManager.h"

#import <sys/time.h>
#import "Utilities.h"

//#import <AudioUnit/AudioUnit.h>

extern char * ioctrlRecvBuf;
extern char * ioctrlSendBuf;

@interface MMActivitiesDetailController (){
    BOOL isPortraitOrientation;
    BOOL showNavBar;
}
- (void)configureView;
@end

@implementation MMActivitiesDetailController{
    //ubiaAQPlayController *  uAQPlayer;
    //ubiaAQRecordController * uAQRecord;
    BOOL isListening;
    __weak ubiaDeviceManager * deviceManager;
}

@synthesize imageView, currentDevice;
@synthesize preViewController;
@synthesize showNavBar;
@synthesize goLiveBtn,playbackBtn,dateLabel,timeLabel,statusImage;
//@synthesize video;
@synthesize timeString,dateString;
@synthesize alert;

@synthesize inBackground;

-(void) showSelectItem:(REMenuItem *)item{
 
    if (currentDevice.client.avid != item.tag) {
           NSLog(@"switch channel from %d to %d",currentDevice.client.avid, item.tag);
        //currentDevice
           
    }
    currentDevice.client.avid = item.tag;
}
- (void)showMenu
{
    if (_menu.isOpen)
        return [_menu close];
    
    // Sample icons from http://icons8.com/download-free-icons-for-ios-tab-bar
    //
    NSMutableArray * itemArray = [NSMutableArray arrayWithCapacity:currentDevice.settings.totalChannels];
    
    for (int i = 0; i< currentDevice.settings.totalChannels; i++){
        NSString * title = [NSString stringWithFormat:@"CH%d",i];
        REMenuItem *item = [[REMenuItem alloc] initWithTitle:title
                            //subtitle:@"SubStream"
                                            image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                            action:^(REMenuItem *item) {
                                                NSLog(@"Item: %@", item);
                                                [self showSelectItem:item];
                                            }];
        item.tag = i;
        [itemArray addObject:item];
    }
#if 0
    REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:@"CH0"
                                                    //subtitle:@"SubStream"
                                                       image:[UIImage imageNamed:@"Icon_Home"]
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          NSLog(@"Item: %@", item);
                                                          [self showSelectItem:item];
                                                      }];
    
    REMenuItem *exploreItem = [[REMenuItem alloc] initWithTitle:@"CH1"
                                                       //subtitle:@"MainStream"
                                                          image:[UIImage imageNamed:@"Icon_Explore"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             [self showSelectItem:item];
                                                         }];
    
    REMenuItem *activityItem = [[REMenuItem alloc] initWithTitle:@"CH2"
                                                        subtitle:@""
                                                           image:[UIImage imageNamed:@"Icon_Activity"]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              NSLog(@"Item: %@", item);
                                                              [self showSelectItem:item];
                                                          }];
    
    REMenuItem *profileItem = [[REMenuItem alloc] initWithTitle:@"CH3"
                                                          image:[UIImage imageNamed:@"Icon_Profile"]
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             NSLog(@"Item: %@", item);
                                                             [self showSelectItem:item];
                                                         }];

    
    homeItem.tag = 0;
    exploreItem.tag = 1;
    activityItem.tag = 2;
    profileItem.tag = 3;
 #endif
    _menu = [[REMenu alloc] initWithItems:itemArray];
             //@[homeItem, exploreItem, activityItem, profileItem]];
    _menu.cornerRadius = 4;
    _menu.shadowColor = [UIColor blackColor];
    _menu.shadowOffset = CGSizeMake(0, 1);
    _menu.shadowOpacity = 1;
    _menu.imageOffset = CGSizeMake(4, -1);
    
    [_menu showFromNavigationController:self.navigationController];
}

#pragma mark Playback routines

#ifdef SUPPORT_AUDIO



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  
    NSLog(@"prepareForSegue to %@",[segue identifier]);
    if ([[segue identifier] isEqualToString:@"gotoDeviceDetail"]) {

    }

}


//#pragma mark background notifications
- (void)registerForBackgroundNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(resignActive)
												 name:UIApplicationWillResignActiveNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(enterForeground)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
}

- (void)resignActive
{
    //if(uAQPlayer.mIsRunning) [uAQPlayer StopQueue];
    //if(uAQRecord.mIsRunning) [uAQRecord StopRecord];
    
    inBackground = true;
}

- (void)enterForeground
{
    //OSStatus error = AudioSessionSetActive(true);
    //if (error) printf("AudioSessionSetActive (true) failed");
	inBackground = false;
}
#endif

#ifdef SUPPORT_AUDIO
//#pragma mark Cleanup
- (void)dealloc
{
	//if(uAQPlayer.mIsRunning) [uAQPlayer StopQueue];
    //if(uAQRecord.mIsRunning) [uAQRecord StopRecord];

}
#endif

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (currentDevice != newDetailItem) {
       // _detailItem = newDetailItem;
        currentDevice = newDetailItem;
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if(self.currentDevice){
        self.detailDescriptionLabel.text = self.currentDevice.uid;
        //uAQRecord.currentDevice = currentDevice;
    }
    //imageView =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
    //[imageView setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    
    //imageView = [[UIImageView alloc] init];
    //[imageView setFrame:CGRectMake(0,100,320,180)];
  
    //[self.view addSubview:imageView];
   
    
    [self.view addGestureRecognizer:self.swipeLeft];
    [self.view addGestureRecognizer:self.swipeRight];
    [self.view addGestureRecognizer:self.swipeUp];
    [self.view addGestureRecognizer:self.swipeDown];
    //[self.view addGestureRecognizer:self.panned];
    //[self.view addGestureRecognizer:self.pinched];
    //[self.view addGestureRecognizer:self.rotation];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    goLiveBtn.hidden = TRUE;
    
    //showNavBar = FALSE;
    //showNavBar = TRUE;
    
    int orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(orientation)){
        //we set the init default
        //isPortraitOrientation = FALSE;
        [self setPortraitOrientation: FALSE];
        
    }else{
        //isPortraitOrientation = TRUE;
        [self setPortraitOrientation: TRUE];
        
    }
    
    [self configureView];
    
    //[self handleOrientationLayout];
    
}

- (void) appWillEnterForegroundNotification{
    
    NSLog(@"MMActivitiesDetailController trigger event when will enter foreground.");
    
   // MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [NSThread sleepForTimeInterval:0.6]; //make sure the old backgroundJob is exit

    NSLog(@"MMActivitiesDetailController trigger event when will enter foreground.");
    
}
- (void) appWillResignActiveNotification{
    NSLog(@"MMActivitiesDetailController trigger event when will Resign Active...");
 
    [self.navigationController popToRootViewControllerAnimated:NO];

}

-(void) updateLabelText{
    //timeLabel.text = timeString;
    //dateLabel.text = dateString;
    
    if (isPortraitOrientation){
        timeLabel.text = timeString;
        dateLabel.text = dateString;
        self.navigationItem.title = currentDevice.name;
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",dateString, timeString ];
    }
    
}

-(void) handleubiaDeviceTimeUpdateNotification{
    NSDate *stDate = [[NSDate alloc] initWithTimeIntervalSince1970:(currentDevice.client.secondSince1970-currentDevice.client.deviceTimeZone * 3600)];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    
    dateString = [dateFormatter stringFromDate:stDate];
    
    [dateFormatter setDateFormat:@"a hh:mm:ss"];
    //[dateFormatter setLocale:[NSLocale currentLocale]];
    
    timeString = [dateFormatter stringFromDate:stDate];

    //NSLog(@"Date=%@ Time=%@", dateLabel.text, timeLabel.text);
    
    [self performSelectorOnMainThread:@selector(updateLabelText) withObject:nil waitUntilDone:NO];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"DetailView will appear");
    
    [self navigationItem].title = currentDevice.name;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleubiaDeviceTimeUpdateNotification) name:@"ubiaDeviceTimeUpdateNotification" object:nil];

    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    appDelegate.rotationEnabled = TRUE;
    deviceManager = appDelegate.deviceManager;
    deviceManager.imageView = imageView;
    [deviceManager startPlayback:alert];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //NSLog(@"Public Liveview did appear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    //set global rotation lock to portrait
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.rotationEnabled = FALSE;
    
    [deviceManager stopPlayback];
    
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveSnapShot:(UIBarButtonItem *)sender {
    NSLog(@"click snapshot");
    [Utilities capture_snapshot:currentDevice.uid withImage:imageView.image];
}

- (IBAction)handleClickListenBtn:(UIBarButtonItem *)sender {
    
    if(isListening){
        isListening = FALSE;
        //[_listenBarItem setTintColor:defaultTintColor];
        
    }else{
        isListening = TRUE;
        //[_listenBarItem setTintColor:[UIColor greenColor]];
        
    }
    [deviceManager startListen];
    
    NSLog(@"click listen");
}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view.superview isKindOfClass:[UIToolbar class]]) {
        return NO;
    }
    return YES;
}


- (IBAction)handleClickMuteBtn:(UIBarButtonItem *)sender {
    NSLog(@"click Mute");
}

- (IBAction)handleClickChannelBtn:(id)sender {
    [self showMenu];
}

/*
 In response to a swipe gesture, show the image view appropriately then move the image view in the direction of the swipe as it fades out.
 */
//- (IBAction)handleGestureforPan:(UIPanGestureRecognizer *)sender {
//    NSLog(@"Pan ");
//}
- (IBAction)handleGestureforPinch:(id)sender {
    NSLog(@"Pinch");
    
}
-(void) setPortraitOrientation:(BOOL) isPortrait{
    
    isPortraitOrientation = isPortrait;
    
    if(FALSE == isPortraitOrientation){
        showNavBar = FALSE;
        self.navigationController.navigationBarHidden = TRUE;
        self.toolbar.hidden = TRUE;
        
        self.statusImage.hidden = TRUE;
        self.dateLabel.hidden = TRUE;
        
        self.timeLabel.hidden = TRUE;
        self.playbackBtn.hidden = TRUE;
        //self.goLiveBtn.hidden = TRUE;
    }else{
        showNavBar = TRUE;
        self.navigationController.navigationBarHidden = FALSE;
        self.toolbar.hidden = FALSE;
        
        self.statusImage.hidden = FALSE;
        self.dateLabel.hidden = FALSE;
        self.timeLabel.hidden = FALSE;
        self.playbackBtn.hidden = FALSE;
        //self.goLiveBtn.hidden = FALSE;
    }
    
}

- (IBAction)handleGestureforTap:(id)sender {
    NSLog(@"tapped");
    if (TRUE == isPortraitOrientation ) {
        return;
    }else{
        if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
        {
            self.statusImage.hidden = TRUE;
            self.dateLabel.hidden = TRUE;
            self.timeLabel.hidden = TRUE;
            self.playbackBtn.hidden = TRUE;
            //self.goLiveBtn.hidden = TRUE;
            
            if( [[UIScreen mainScreen] bounds].size.height >= 568 || [[UIScreen mainScreen] bounds].size.width >= 568 )
            {
                //IPHONE 5/5C/5S
                
                if (showNavBar) {
                    showNavBar = FALSE;
                    self.navigationController.navigationBarHidden = YES;
                    //self.toolbar.hidden = YES;
                    
                }else{
                    showNavBar = TRUE;
                    self.navigationController.navigationBarHidden = FALSE;
                    //self.toolbar.hidden = FALSE;
                }
                [self handleOrientationLayout];
                
            }else{
                
                return; //disable tap gesture as lanscape before ios6
            }
        }//IPAD
        
    }
    
}



- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
-(void) handleOrientationLayout{

    int orientation = [[UIDevice currentDevice] orientation];
    int width = self.view.frame.size.width;
    int height = self.view.frame.size.height;
    //int nh = self.navigationController.navigationBar.frame.size.height;
    
    NSLog(@"(w:%d h:%d) rotate %d", width,height,orientation);
    
    if(isPortraitOrientation){
        
        imageView.frame = CGRectMake(0, (height - width*9/16)/2, width, width*9/16);
        
        statusImage.frame = CGRectMake(10, 70, 50, 24);
        dateLabel.frame = CGRectMake(0, 60, width, 44);
        
        //_toolbar.frame = CGRectMake(0,height-44, width, 44);
        
        playbackBtn.frame = CGRectMake(0, height-44, 44, 44);
        timeLabel.frame = CGRectMake(48, height-44, width-96, 44);
        
    }else{
        imageView.frame = CGRectMake(0, 0, width, height);
        
        statusImage.frame = CGRectMake(10, 20, 50, 24);
        dateLabel.frame = CGRectMake(0, 10, width, 44);
        
        //_toolbar.frame = CGRectMake(0,height-44, width, 44);
        
        playbackBtn.frame = CGRectMake(0, height-44, 44, 44);
        timeLabel.frame = CGRectMake(48, height-44, width-96, 44);
    }
    
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    NSLog(@"from rotate %d", fromInterfaceOrientation);
    [self handleOrientationLayout];
}
-(void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if(UIDeviceOrientationIsPortrait(toInterfaceOrientation)){
        self.navigationItem.title = currentDevice.name;
        //isPortraitOrientation = TRUE;
        [self setPortraitOrientation:TRUE];
    }else if(UIDeviceOrientationIsLandscape(toInterfaceOrientation)){
        self.navigationItem.title = [NSString stringWithFormat:@"%@ %@",dateString, timeString ];
        //isPortraitOrientation = FALSE;
        [self setPortraitOrientation:FALSE];
    }
    
}

- (IBAction)playback:(id)sender {
    NSLog(@"Playback rewind 30 seconds");
    goLiveBtn.hidden = FALSE;
    
    NSString* imageName = [[NSBundle mainBundle] pathForResource:@"rec" ofType:@"png"];
    statusImage.image = [[UIImage alloc] initWithContentsOfFile:imageName];
    
}

@end
