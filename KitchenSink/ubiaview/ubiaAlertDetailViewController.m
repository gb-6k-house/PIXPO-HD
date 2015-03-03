//
//  ubiaAlertDetailViewController.m
//  P4PCamLive
//
//  Created by work on 13-4-17.
//  Copyright (c) 2013年 Ubianet. All rights reserved.
//

#import "ubiaAlertDetailViewController.h"
#import "ubiaDevice.h"
#import "ubiaAlert.h"
#import "MMAppDelegate.h"
#import "ubiaDeviceManager.h"
#import "MMImageViewer.h"

@interface ubiaAlertDetailViewController ()
{
    BOOL isPortraitOrientation;
    BOOL showNavBar;
    NSString * dateString;
    NSString * timeString;
    __weak ubiaDeviceManager *deviceManager;
}
@end

@implementation ubiaAlertDetailViewController
@synthesize imageViewer, currentDevice;

@synthesize alert, activity;
@synthesize dateLabel,timeLabel,playbackBtn,statusImage;
@synthesize detailInfoLabel;

//extern char * ioctrlRecvBuf;
//extern char * ioctrlSendBuf;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) closeView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"Detail AlertView will appear");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleubiaDeviceTimeUpdateNotification) name:@"ubiaDeviceTimeUpdateNotification" object:nil];
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appDelegate.rotationEnabled = TRUE;
    deviceManager = appDelegate.deviceManager;
    deviceManager.imageView = imageViewer;
    [deviceManager startPlayback:alert];

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"Detail AlertView did appear");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Detail AlertView viewDidLoad");
	// Do any additional setup after loading the view.
    showNavBar = FALSE;
    
    int orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(orientation)){
        //we set the init default
        //isPortraitOrientation = FALSE;
        [self setPortraitOrientation: FALSE];
        
    }else{
        //isPortraitOrientation = TRUE;
        [self setPortraitOrientation: TRUE];
    }
    
    [self handleOrientationLayout];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
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


- (void) appWillEnterForegroundNotification{
    
    NSLog(@"ubiaAlertDetailViewController trigger event when will enter foreground.");
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];

    
    [NSThread sleepForTimeInterval:0.6]; //make sure the old backgroundJob is exit

    [appDelegate.deviceManager startPlayback:alert];
    
    //[NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
    NSLog(@"ubiaAlertDetailViewController trigger event when will enter foreground.");
    
}
- (void) appWillResignActiveNotification{
    NSLog(@"ubiaAlertDetailViewController trigger event when will Resign Active...");   
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void) updateLabelText{
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


-(void) setPortraitOrientation:(BOOL) isPortrait{
    
    isPortraitOrientation = isPortrait;
    
    if(FALSE == isPortraitOrientation){
        showNavBar = FALSE;
        self.navigationController.navigationBarHidden = TRUE;
//        self.toolbar.hidden = TRUE;
        
        self.statusImage.hidden = TRUE;
        self.dateLabel.hidden = TRUE;
        
        self.timeLabel.hidden = TRUE;
        //self.playbackBtn.hidden = TRUE;
        //self.goLiveBtn.hidden = TRUE;
    }else{
        showNavBar = TRUE;
        self.navigationController.navigationBarHidden = FALSE;
        //self.toolbar.hidden = FALSE;
        
        self.statusImage.hidden = FALSE;
        self.dateLabel.hidden = FALSE;
        self.timeLabel.hidden = FALSE;
        //self.playbackBtn.hidden = FALSE;
        //self.goLiveBtn.hidden = FALSE;
    }
    
}

- (IBAction)handleTapGesture:(id)sender {
    if (TRUE == isPortraitOrientation ) {
        return;
    }else{
        if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
        {
            self.statusImage.hidden = TRUE;
            self.dateLabel.hidden = TRUE;
            self.timeLabel.hidden = TRUE;
            //self.playbackBtn.hidden = TRUE;
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


- (IBAction)handleGestureforTap:(id)sender {
    NSLog(@"tapped");
    
}

- (IBAction)handlePlayBackBtn:(id)sender {
    
}

#pragma rotation

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
        
        imageViewer.frame = CGRectMake(0, (height - width*9/16)/2, width, width*9/16);
        
        statusImage.frame = CGRectMake(10, 70, 50, 24);
        dateLabel.frame = CGRectMake(0, 60, width, 44);
        
        //_toolbar.frame = CGRectMake(0,height-44, width, 44);
        
        playbackBtn.frame = CGRectMake(0, height-44, 44, 44);
        timeLabel.frame = CGRectMake(48, height-44, width-96, 44);
        
    }else{
        imageViewer.frame = CGRectMake(0, 0, width, height);
        
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

@end
