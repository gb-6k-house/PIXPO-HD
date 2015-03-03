// Copyright (c) 2013 UBIA (http://ubia.cn/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "MMAppDelegate.h"
#import "MMDrawerController.h"
#import "MMExampleCenterTableViewController.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "MMNavigationController.h"
#import "MHWMigrationManager.h"

#import "ICETutorialController.h"

#import "BPush.h"
#import "ubiaDeviceManager.h"
#import "ubiaRestClient.h"
#import "ubiaDeviceList.h"
#import "ubiaDevice.h"
#import "VideoFrameExtractor.h"
#import "Utilities.h"

#import "LoginController.h"

#import "MMPublicDeviceController.h"
#import "MMActivity.h"

#import "ubiaOperation.h"

#import <QuartzCore/QuartzCore.h>

//#define  UBIA_WITH_HTTPSRV
#ifdef UBIA_WITH_HTTPSRV
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#endif

@interface MMAppDelegate ()
@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation MMAppDelegate{
    NSManagedObjectModel * srcModel;
    NSManagedObjectModel * dstModel;
}

/***+++++++++++++++++++++++***/

/***=======================***/


/***+++++++++++++++++++++++***/
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize deviceManager = _deviceManager;
@synthesize publicNavView;
//@synthesize restClient = _restClient;
@synthesize rotationEnabled;
@synthesize storyboardName;
@synthesize logoFile;
@synthesize notificationType;

/***======================***/

#ifdef UBIA_WITH_HTTPSRV
- (void) prepareForHttpServer{
    // Configure our logging framework.
	// To keep things simple and fast, we're just going to log to the Xcode console.
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	
	// Create server using our custom MyHTTPServer class
	httpServer = [[HTTPServer alloc] init];
	
	// Tell the server to broadcast its presence via Bonjour.
	// This allows browsers such as Safari to automatically discover our service.
	[httpServer setType:@"_http._tcp."];
	
	// Normally there's no need to run our server on any specific port.
	// Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
	// However, for easy testing you may want force a certain port so you can just hit the refresh button.
    [httpServer setPort:12345];
    
    // Serve files from our embedded Web folder
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private Documents/Temp"];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:webPath])
    {
        [fileManager createDirectoryAtPath:webPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
	[httpServer setDocumentRoot:webPath];
    
}

- (void)startServer
{
    // Start the server (and check for problems)
	
	NSError *error;
	if([httpServer start:&error])
	{
		NSLog(@"Started HTTP Server on port %hu", [httpServer listeningPort]);
	}
	else
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
}
#endif

#if 1

-(BOOL) loadTutorialPage{
    
    // Init the pages texts, and pictures.
    ICETutorialPage *layer1 = [[ICETutorialPage alloc] initWithSubTitle:NSLocalizedString(@"tutorial_title0_desc", nil)
                                                            //description:@"Champs-Elysées by night"
                                                            description:NSLocalizedString(@"tutorial_page0_desc", nil)
                                                            pictureName:@"tutorial_background_00"];
    ICETutorialPage *layer2 = [[ICETutorialPage alloc] initWithSubTitle:NSLocalizedString(@"tutorial_title1_desc", nil)
                                                            //description:@"The Eiffel Tower with\n cloudy weather"
                                                            description:NSLocalizedString(@"tutorial_page1_desc", nil) pictureName:@"tutorial_background_01"];
    ICETutorialPage *layer3 = [[ICETutorialPage alloc] initWithSubTitle:NSLocalizedString(@"tutorial_title2_desc", nil)
                                                            //description:@"An other famous street of Paris"
                                                            description:NSLocalizedString(@"tutorial_page2_desc", nil)
                                                            pictureName:@"tutorial_background_02"];
    
    
    // Set the common style for SubTitles and Description (can be overrided on each page).
    ICETutorialLabelStyle *subStyle = [[ICETutorialLabelStyle alloc] init];
    [subStyle setFont:TUTORIAL_SUB_TITLE_FONT];
    [subStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [subStyle setLinesNumber:TUTORIAL_SUB_TITLE_LINES_NUMBER];
    [subStyle setOffset:TUTORIAL_SUB_TITLE_OFFSET];
    
    ICETutorialLabelStyle *descStyle = [[ICETutorialLabelStyle alloc] init];
    [descStyle setFont:TUTORIAL_DESC_FONT];
    [descStyle setTextColor:TUTORIAL_LABEL_TEXT_COLOR];
    [descStyle setLinesNumber:TUTORIAL_DESC_LINES_NUMBER];
    [descStyle setOffset:TUTORIAL_DESC_OFFSET];
    
    // Load into an array.
    NSArray *tutorialLayers = @[layer1,layer2,layer3];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        //NSString* path= [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        //NSString* path= [[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"];
        //NSString* path= [[NSBundle mainBundle] pathForResource:@"zh-Hant" ofType:@"lproj"];
        //NSString* path= [[NSBundle mainBundle] pathForResource:[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] ofType:@"lproj"];
        //NSBundle* languageBundle = [NSBundle bundleWithPath:path];
        
        //self.iceTutorialController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPhone" bundle:languageBundle andPages:tutorialLayers];
        self.iceTutorialController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPhone" bundle:nil andPages:tutorialLayers];
   
    } else {
        self.iceTutorialController = [[ICETutorialController alloc] initWithNibName:@"ICETutorialController_iPad"
                                                                      bundle:nil
                                                                    andPages:tutorialLayers];
    }
    
    // Set the common styles, and start scrolling (auto scroll, and looping enabled by default)
    [self.iceTutorialController setCommonPageSubTitleStyle:subStyle];
    [self.iceTutorialController setCommonPageDescriptionStyle:descStyle];
    
    
    __unsafe_unretained typeof(self) weakSelf = self;
    // Set button 1 action.
    [self.iceTutorialController setButton1Block:^(UIButton *button){
        NSLog(@"Button 1 pressed.");
        
        [weakSelf.iceTutorialController stopScrolling];
        [weakSelf.deviceManager restoreToActive];
#if 1
        
        if(weakSelf.publicNavView == nil){
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:weakSelf.storyboardName bundle:nil];
            weakSelf.publicNavView = [storyboard instantiateViewControllerWithIdentifier:@"publicNavViewer"];
        }
#else
        QRootElement *root =  [[QRootElement alloc] init];//  [[QRootElement alloc] initWithJSONFile:@"registerform"];
        root.title = NSLocalizedString(@"create_account_txt", nil); //@"Create Account";
        root.grouped = YES;
        root.controllerName = @"RegisterController";
        
        QSection *section = [[QSection alloc] init];
        //section.title = @"Awesome Register Form";
        section.headerImage = @"logo";
        section.footer = NSLocalizedString(@"register_section_footer_txt", nil);
        
        QEntryElement *loginEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"login_id_txt", nil) Value:@"" Placeholder:NSLocalizedString(@"id_or_email_txt", nil)];
        
        loginEntry.bind=@"textValue:login";
        loginEntry.key = @"login_key";
    
        QEntryElement *pwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"password", nil) Value:@"" Placeholder:NSLocalizedString(@"password", nil)];
        pwdEntry.bind=@"textValue:password";
        pwdEntry.key = @"password_key";
        pwdEntry.secureTextEntry = true;
        
        
        QEntryElement *codeEntry = [[QEntryElement alloc] init];
        codeEntry.placeholder = NSLocalizedString(@"checkcode_txt", nil);
        codeEntry.bind=@"textValue:checkcode";
        codeEntry.key = @"checkcode_key";
        codeEntry.controllerAction = @"refreshCheckCode";
        //codeEntry.title = @"Check Code";
        //cell.imageView.image =  @"logo";
        //codeEntry.imageNamed =@"live";
        
        [root addSection:section];
        [section addElement:loginEntry];
        [section addElement:pwdEntry];
        [section addElement:codeEntry];

        QSection *subsection2 = [[QSection alloc] init];
        QButtonElement *myButton = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"register_txt", nil)];
        myButton.controllerAction = @"onCreate:";
        myButton.key = @"button_key";
        
        [subsection2 addElement:myButton];
        [root addSection:subsection2];
    
        QuickDialogNavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
#endif
        [weakSelf.iceTutorialController presentViewController:weakSelf.publicNavView animated:YES completion:^{
             NSLog(@"pubic view is presented");
        }];
        
    }];
    
    // Set button 2 action, stop the scrolling.

    [self.iceTutorialController setButton2Block:^(UIButton *button){
        //NSLog(@"Button 2 pressed.");
        //NSLog(@"Auto-scrolling stopped.");
        [weakSelf.iceTutorialController stopScrolling];
        [weakSelf.deviceManager restoreToActive];
        
#if 1
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:weakSelf.storyboardName bundle:nil];
        UIViewController * loginview = [storyboard instantiateViewControllerWithIdentifier:@"MMLoginViewer"];
        
        [weakSelf.iceTutorialController presentViewController:loginview animated:YES completion:^{
            NSLog(@"Login completion");
        }];

#else
        QRootElement *root =  [[QRootElement alloc] init];//  [[QRootElement alloc] initWithJSONFile:@"registerform"];
        root.title = NSLocalizedString(@"login_txt", nil);
        root.grouped = YES;
        root.controllerName = @"LoginController";
        
        QSection *section = [[QSection alloc] init];
        //section.title = @"Awesome Login Form";
        section.headerImage = weakSelf.logoFile;
        //section.footer = NSLocalizedString(@"login_section_footer_txt", nil);
        
        QEntryElement *loginEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"login_id_txt", nil) Value:weakSelf.deviceManager.restClient.user_loginID Placeholder:NSLocalizedString(@"id_or_email_txt", nil)];
        loginEntry.bind=@"textValue:login";
        loginEntry.key = @"login_key";
        
        //[loginEntry  setTextValue:weakSelf.restClient.user_loginID];
        //[loginEntry setTitle:NSLocalizedString(@"login_id_txt", nil)];
        
        QEntryElement *pwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"password", nil) Value:@"" Placeholder:NSLocalizedString(@"password", nil)];
        pwdEntry.bind=@"textValue:password";
        pwdEntry.key = @"password_key";
        pwdEntry.secureTextEntry = true;
        
        if(weakSelf.deviceManager.restClient.savePassword){
            [pwdEntry setTextValue:weakSelf.deviceManager.restClient.user_password];
        }
        
        QBooleanElement *boolEntry = [[QBooleanElement alloc] initWithTitle:NSLocalizedString(@"remember_password_txt", nil) BoolValue:weakSelf.deviceManager.restClient.savePassword];
        boolEntry.bind=@"boolValue:bool";
        boolEntry.key = @"savePassword_key";
        boolEntry.onImage = [UIImage imageNamed:@"imgOn"];
        boolEntry.offImage = [UIImage imageNamed:@"imgOff"];

        [root addSection:section];
        [section addElement:loginEntry];
        [section addElement:pwdEntry];
        [section addElement:boolEntry];
        
        QSection *subsection2 = [[QSection alloc] init];
        QButtonElement * txtElement = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"create_new_account_note", nil)];
        txtElement.key = @"hyperlink_key";
        txtElement.controllerAction = @"onGotoCreateAccount:";
        
        QButtonElement *myButton = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"login_txt", nil)];
        myButton.controllerAction = @"onLogin:";
        myButton.key = @"button_key";
        
        [subsection2 addElement:txtElement];
        [subsection2 addElement:myButton];
        [root addSection:subsection2];
        
        QuickDialogNavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
        //QuickDialogController * loginView = [QuickDialogController controllerForRoot:root];
        
        //LoginController * loginView = (LoginController* ) [navigation topViewController];
        
        //weakSelf.window.rootViewController = navigation;
        
        [weakSelf.iceTutorialController presentViewController:navigation animated:YES completion:^{
            NSLog(@"Login completion");
                    }];
#endif
        
    }];
    
    // Run it.
    [self.iceTutorialController startScrolling];
    self.window.rootViewController = self.iceTutorialController;

    return TRUE;
}

-(BOOL) RegisterSuccess:(NSNotification *)note{
    
    QRootElement *root =    [[QRootElement alloc] initWithJSONFile:@"QDLoginForm"];// [[QRootElement alloc] init];
    root.title = @"Login";
    root.grouped = YES;
    
    QuickDialogNavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
    
    self.window.rootViewController = navigation;

    return  TRUE;
}

-(BOOL) LoginSuccess:(NSNotification *)note{

    ubiaRestClient * restClient = [[note userInfo] objectForKey:@"restClient"];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    
    self.window.rootViewController=[storyboard instantiateInitialViewController];
    
    MMDrawerController * drawerController = (MMDrawerController *)self.window.rootViewController;
    [drawerController setMaximumRightDrawerWidth:120.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [[MMExampleDrawerVisualStateManager sharedManager]
                 drawerVisualStateBlockForDrawerSide:drawerSide];
        if(block){
            block(drawerController, drawerSide, percentVisible);
        }
    }];
    
#ifdef USING_AS_STANDALONE
    [_deviceManager.restClient loadLocalDeviceInfo];
#else
    [_deviceManager.restClient.myDeviceList removeAllDevice];
    [_deviceManager.restClient.publicList removeAllDevice];
    
    [restClient get_public_device_list];
    [restClient get_my_device_list];
#endif
    _deviceManager.autoStartListen = TRUE;
    return  TRUE;
}

//logout
-(void) handleBackTutorialPageNotification{

    _deviceManager.restClient.hasLogin = FALSE;
    [_deviceManager.restClient.myDeviceList removeAllDevice];
    [_deviceManager.restClient.publicList removeAllDevice];
    
    _deviceManager.isPublicView = FALSE;
    _deviceManager.isMyDeviceView = FALSE;
    
    NSMutableArray *uidtag =[NSMutableArray arrayWithCapacity:[_deviceManager.restClient.myDeviceList count]];
    
    for (int i=0; i < [_deviceManager.restClient.myDeviceList count]; i++) {
        ubiaDevice *tmpDevice = [_deviceManager.restClient.myDeviceList getDeviceByIndex:i];
        [uidtag addObject:tmpDevice.uid];
    }
    
    [BPush delTags:uidtag];
    
    //[_deviceManager resignFromActive];
    [self loadTutorialPage];

}
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    NSLog(@"MMAppDelegate willFinishLaunchingWithOptions %@ launchOptions:%@",application, launchOptions);
    
   float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
    {
        if( [[UIScreen mainScreen] bounds].size.height >= 568 || [[UIScreen mainScreen] bounds].size.width >= 568 )
        {
            //4 inch device
            //IPHONE 5/5C/5S
            storyboardName = @"Storyboard_iPhone5";
            logoFile = @"logo";
            
        }else{
            //3.5 inch device
            if (systemVersion >= 7.0) {
                storyboardName = @"Storyboard_iPhone3.5_7.0";
                //storyboardName = @"Storyboard_iPhone3.5";
                logoFile = @"logo_s";
            }else{
                //storyboardName = @"Storyboard_iPhone4";
                storyboardName = @"Storyboard_iPhone5";
                logoFile = @"logo";
            }
        }
    }else{
        //IPAD
    }
    
    rotationEnabled = FALSE;
    if(_deviceManager == nil){
        _deviceManager = [[ubiaDeviceManager alloc] init];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBackTutorialPageNotification) name: @"backTutorialPageNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RegisterSuccess:) name: @"registerSuccessNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginSuccess:) name: @"loginSuccessNotification" object:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
#ifdef USING_AS_STANDALONE
    [_deviceManager restoreToActive];
    _deviceManager.restClient.hasLogin = TRUE;
    
    [self LoginSuccess:nil];
#else
    [self loadTutorialPage];
#endif
    [self.window makeKeyAndVisible];
    return YES;

}
#else
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    
    UIViewController * leftSideDrawerViewController = [[MMExampleLeftSideDrawerViewController alloc] init];

    UIViewController * centerViewController = [[MMExampleCenterTableViewController alloc] init];
    
    UIViewController * rightSideDrawerViewController = [[MMExampleRightSideDrawerViewController alloc] init];
    
    UINavigationController * navigationController = [[MMNavigationController alloc] initWithRootViewController:centerViewController];
    
    [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    if(OSVersionIsAtLeastiOS7()){
        UINavigationController * rightSideNavController = [[MMNavigationController alloc] initWithRootViewController:rightSideDrawerViewController];
		[rightSideNavController setRestorationIdentifier:@"MMExampleRightNavigationControllerRestorationKey"];
        UINavigationController * leftSideNavController = [[MMNavigationController alloc] initWithRootViewController:leftSideDrawerViewController];
		[leftSideNavController setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
        self.drawerController = [[MMDrawerController alloc]
                            initWithCenterViewController:navigationController
                            leftDrawerViewController:leftSideNavController
                            rightDrawerViewController:rightSideNavController];
        [self.drawerController setShowsShadow:NO];
    }
    else{
         self.drawerController = [[MMDrawerController alloc]
                            initWithCenterViewController:navigationController
                            leftDrawerViewController:leftSideDrawerViewController
                            rightDrawerViewController:rightSideDrawerViewController];
    }
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumRightDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if(OSVersionIsAtLeastiOS7()){
        UIColor * tintColor = [UIColor colorWithRed:29.0/255.0
                                              green:173.0/255.0
                                               blue:234.0/255.0
                                              alpha:1.0];
        [self.window setTintColor:tintColor];
    }
    [self.window setRootViewController:self.drawerController];

    return YES;
}
#endif

/*
 When the iOS delivers a local notification there are three possibilities:
 
Case 1  Your application is not running. The system displays the alert message, badges the application, and plays a sound – whatever is specified in the notification. The app can be run and brought to the front when user taps (or slides) the action button (or slider) of the notification. When it happens, your app’s delegate will receive application:didFinishLaunchingWithOptions: with an NSDictionary object that includes the local-notification object.
Case 2 Your application is not frontmost and not visible but is suspended in the background. The system displays the alert message, badges the application, and plays a sound – whatever is specified in the notification. The app can be brought to the front when user taps (or slides) the action button (or slider) of the notification. When it happens (user interacts with the notification), your app’s delegate will receive application:didReceiveLocalNotification:.
Case 3 Your application is foremost and visible when the system delivers the notification, no alert is shown, no icon is badged, and no sound is played. Your app’s delegate will receive application:didReceiveLocalNotification:. In this case you have to notify users in your own way within your app.
 */

// case 1 - AppDelegate.m

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"MMAppDelegate didFinishLaunchingWithOptions %@ launchOptions: %@",application,launchOptions);
#ifdef UBIA_WITH_HTTPSRV
    [self prepareForHttpServer];
    [self startServer];
#endif
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [BPush setupChannel:launchOptions]; // 必须

    
    [BPush setDelegate:self]; // 必须。参数对象必须实现onMethod: response:方法，本示例中为self
    
    // [BPush setAccessToken:@"3.ad0c16fa2c6aa378f450f54adb08039.2592000.1367133742.282335-602025"];  // 可选。api key绑定时不需要，也可在其它时机调用
    
    //[application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound];
    
    [_deviceManager handleSlientMode:_deviceManager.localConfig.silentMode];
#ifdef  USING_AS_STANDALONE
    [_deviceManager restoreToActive];
    
    _deviceManager.restClient.hasLogin = TRUE;
#endif
    //handle remote notification
    if (launchOptions != nil)
	{
		NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			//[self addMessageFromRemoteNotification:dictionary updateUI:NO];
		}
        
        // Override point for customization after application launch.
        // ... your code here ...
        
        UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        
        NSLog(@"%@", notification);
        
        if (notification)
        {
            UIAlertView *aw = [[UIAlertView alloc] initWithTitle:@"Case 1" message: notification.alertBody delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [aw show];
        }
        
        // Remove the badge number (this should be better in the applicationWillEnterForeground: method)
        application.applicationIconBadgeNumber = 0;
        
	}
 
    
   UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
   NSLog(@"UIRemoteNotificationType: %d",type);
    
#if 0
    
    // 通知设备需要接收推送通知 Let the device know we want to receive push notifications
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    
    //handle remote notification
    if (launchOptions != nil)
	{
		NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			//[self addMessageFromRemoteNotification:dictionary updateUI:NO];
		}
	}
#endif
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

// case 2 and case 3 - AppDelegate.m
// case 2 - only triggered when a user interacts with the notification (taps or slides it)
// case 3 - always triggered
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState == UIApplicationStateInactive)
    {
        // case 2
        UIAlertView *aw = [[UIAlertView alloc] initWithTitle:@"Case 2" message: notification.alertBody delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [aw show];
    }
    else if (application.applicationState == UIApplicationStateActive)
    {
        // case 3
        UIAlertView *aw = [[UIAlertView alloc] initWithTitle:@"Case 3" message: notification.alertBody delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [aw show];
    }
    
    application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber - 1;
    
    NSLog(@"%@", notification);
}

-(void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
    //Message* message =[[Message alloc]init];
    //message.date=[NSDate date];
    
    NSString*alertValue=[[userInfo valueForKey:@"aps"]valueForKey:@"alert"];
    NSMutableArray* parts =[NSMutableArray arrayWithArray: [alertValue componentsSeparatedByString:@": "]];
    //message.senderName=[parts objectAtIndex:0];
    [parts removeObjectAtIndex:0];
    //message.text=[parts componentsJoinedByString:@": "];
    //int index =[dataModeladdMessage:message];
    //if(updateUI)
    //   [self.chatViewControllerdidSaveMessage:messageatIndex:index];
    //[message release];
}

#if 0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    //just for ios 7
    NSLog(@"Received BPush ios7 notification: %@", userInfo);
    if (application.applicationState == UIApplicationStateInactive) {
        //[PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    
    NSString *badge = [userInfo objectForKey:@"badge"];
    application.applicationIconBadgeNumber = [badge intValue];
    
    int alertType = [[userInfo objectForKey:@"type"] intValue];
    
    switch (alertType) {
        case 0:
        case 1:
            //Motion
        case 2:
            //Alarm
        case 3:
            //Sound
        case 4:
            //PIR
        case 5:
            //Temperature
        {
            MMActivity *activity = [[MMActivity alloc] init];
            activity.alertType = alertType;
            activity.devUID = [[userInfo objectForKey:@"uid"] description];
            
            NSDate *stDate = [[NSDate alloc] initWithTimeIntervalSince1970: [[userInfo objectForKey:@"time"] intValue]];
            
            activity.timeStamp = stDate;
            //activity.snapFile = [[alertInfo objectForKey:@"snapfile"] description];
            [self insertNewActivityObject: activity];
        }
            break;
            
        default:
            break;
    }
    
}
#endif


-(void) playcustomsound{

    //音效文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"2326" ofType:@"wav"];
    //组装并播放音效
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
    //声音停止
    //AudioServicesDisposeSystemSoundID(soundID);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)alertInfo
{
	NSLog(@"Received BPush notification: %@", alertInfo);
    NSString *badge = [alertInfo objectForKey:@"badge"];
    application.applicationIconBadgeNumber = [badge intValue];
    
    int alertType = [[alertInfo objectForKey:@"type"] intValue];
    
    NSString * sound = [alertInfo objectForKey:@"sound"];
    NSString * vibrate = [alertInfo objectForKey:@"vibrate"];
    
    if (vibrate && (FALSE == [vibrate isEqualToString:@""])) {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    
    if(sound && (FALSE == [sound isEqualToString:@""])){
        //AudioServicesPlaySystemSound(1007);
        [self playcustomsound];
    }
    
    switch (alertType) {
        case 0:
        case 1:
            //Motion
        case 2:
            //Alarm
        case 3:
            //Sound
        case 4:
            //PIR
        case 5:
            //Temperature
        {
            MMActivity *activity = [[MMActivity alloc] init];
            activity.alertType = alertType;
            activity.devUID = [[alertInfo objectForKey:@"uid"] description];
            activity.timeZone = [[[alertInfo objectForKey:@"tz"] description] intValue];
            int utcTime = [[alertInfo objectForKey:@"time"] intValue] - (activity.timeZone * 3600);
            NSDate *stDate = [[NSDate alloc] initWithTimeIntervalSince1970: utcTime];
            
            activity.timeStamp = stDate;

            //activity.snapFile = [[alertInfo objectForKey:@"snapfile"] description];
            [self insertNewActivityObject: activity];
            _deviceManager.badgeNum++;
        }
        //[_deviceManager scheduleNotificationWithItem:0];
            break;
            
        default:
            break;
    }
    
	//[self addMessageFromRemoteNotification:alertInfo updateUI:YES];
    //[BPush handleNotification:alertInfo]; // 可选
}

- (void)insertNewActivityObject:(MMActivity *)activity
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    NSNumber * type = [[NSNumber alloc] initWithShort:activity.alertType];
    [newManagedObject setValue: type forKey:@"alertType"];
    
    [newManagedObject setValue:activity.devUID forKey:@"devUID"];
    [newManagedObject setValue:activity.snapFile forKey:@"snapFile"];
    
    [newManagedObject setValue:activity.timeStamp forKey:@"timeStamp"];
    
    NSNumber * timeZ = [[NSNumber alloc] initWithShort:activity.timeZone];
    [newManagedObject setValue: timeZ forKey:@"timeZone"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"MMAppDelegate applicationWillResignActive ==>Begin");

    _deviceManager.isManagerKilling = TRUE;
    
    NSLog(@"MMAppDelegate applicationWillResignActive <==End");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //method must still exit within 5 seconds.
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"MMAppDelegate applicationDidEnterBackground ==>Begin");

#ifdef UBIA_WITH_HTTPSRV
    [httpServer stop];
#endif
    [NSThread sleepForTimeInterval:1];
    if(_deviceManager.isMyDeviceView)
        [_deviceManager.restClient.myDeviceList stopAllDevice];
    else if(_deviceManager.isPublicView){
        [_deviceManager.restClient.publicList stopAllDevice];
    }
    
    BOOL waiting;
    ubiaDevice * tmpDevice;
    do {
        waiting = FALSE;
        if (_deviceManager.isMyDeviceView) {

            for (int i =0; i< [_deviceManager.restClient.myDeviceList count]; i++) {
                tmpDevice = [_deviceManager.restClient.myDeviceList getDeviceByIndex:i];
                if (tmpDevice.stopOperation && FALSE == tmpDevice.stopOperation.isFinished) {
                    [NSThread sleepForTimeInterval:0.1];
                    NSLog(@"wait stop %@ to be finished", tmpDevice.uid);
                    waiting = TRUE;
                }
            }
        }else if (_deviceManager.isPublicView) {
            
            for (int i =0; i< [_deviceManager.restClient.publicList count]; i++) {
                tmpDevice = [_deviceManager.restClient.publicList getDeviceByIndex:i];
                if (tmpDevice.stopOperation && FALSE == tmpDevice.stopOperation.isFinished) {
                    [NSThread sleepForTimeInterval:0.1];
                    NSLog(@"wait stop %@ to be finished", tmpDevice.uid);
                    waiting = TRUE;
                }
            }
        }
        
    }while (waiting);
    
    [_deviceManager resignFromActive];
    
    NSLog(@"MMAppDelegate applicationDidEnterBackground <==End");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"MMAppDelegate applicationWillEnterForeground ==>");

#ifdef UBIA_WITH_HTTPSRV
    [self startServer];
#endif
    if (_deviceManager == nil) {
        _deviceManager = [[ubiaDeviceManager alloc] init];
        [_deviceManager.localConfig loadConfigInfo];
        [_deviceManager enterMyDeviceView];
    }else{
        [_deviceManager restoreToActive];
    }
    if (_deviceManager.isMyDeviceView) {
        [_deviceManager.restClient.myDeviceList startAllDevice];
    }else if (_deviceManager.isPublicView){
        [_deviceManager.restClient.publicList startAllDevice];
    }
    
    application.applicationIconBadgeNumber = 0;
    NSLog(@"MMAppDelegate applicationWillEnterForeground <==");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"MMAppDelegate applicationDidBecomeActive ==>");
    NSLog(@"MMAppDelegate applicationDidBecomeActive <==");
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return YES;
}

- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    NSLog(@"MMAppDelegate viewControllerWithRestorationIdentifierPath ==>");
    NSString * key = [identifierComponents lastObject];
    if([key isEqualToString:@"MMDrawer"]){
        return self.window.rootViewController;
    }
    else if ([key isEqualToString:@"MMExampleCenterNavigationControllerRestorationKey"]) {
        return ((MMDrawerController *)self.window.rootViewController).centerViewController;
    }
    else if ([key isEqualToString:@"MMExampleRightNavigationControllerRestorationKey"]) {
        return ((MMDrawerController *)self.window.rootViewController).rightDrawerViewController;
    }
    else if ([key isEqualToString:@"MMExampleLeftNavigationControllerRestorationKey"]) {
        return ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
    }
    else if ([key isEqualToString:@"MMExampleLeftSideDrawerController"]){
        UIViewController * leftVC = ((MMDrawerController *)self.window.rootViewController).leftDrawerViewController;
        if([leftVC isKindOfClass:[UINavigationController class]]){
            return [(UINavigationController*)leftVC topViewController];
        }
        else {
            return leftVC;
        }
        
    }
    else if ([key isEqualToString:@"MMExampleRightSideDrawerController"]){
        UIViewController * rightVC = ((MMDrawerController *)self.window.rootViewController).rightDrawerViewController;
        if([rightVC isKindOfClass:[UINavigationController class]]){
            return [(UINavigationController*)rightVC topViewController];
        }
        else {
            return rightVC;
        }
    }
    return nil;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    [application unregisterForRemoteNotifications];
}

- (void)saveContext
{
    NSError *error = nil;
    [_deviceManager.localConfig persistSaveConfigInfo];
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity;
    
    //entity = [NSEntityDescription entityForName:@"TempDeviceActivity" inManagedObjectContext:self.managedObjectContext];
    
    entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"P4PCamLive" withExtension:@"momd"];
    if (!modelURL) {
        modelURL = [[NSBundle mainBundle] URLForResource:@"Model"
                                                      withExtension:@"mom"];
    }
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *srcURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"P4PCamLive.sqlite"];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    //NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:srcURL error:&error];
    
    NSLog(@"model ver:%@",[[self managedObjectModel] versionIdentifiers]);
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:srcURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    //post the devicetoken to apns server
    NSLog(@"My token is: %@", deviceToken);
    [BPush registerDeviceToken:deviceToken]; // 必须
    
    [BPush bindChannel]; // 必须。可以在其它时机调用，只有在该方法返回（通过onMethod:response:回调）绑定成功时，app才能接收到Push消息。一个app绑定成功至少一次即可（如果access token变更请重新绑定）。
    
}

// 必须，如果正确调用了setDelegate，在bindChannel之后，结果在这个回调中返回。
// 若绑定失败，请进行重新绑定，确保至少绑定成功一次
- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
    if ([BPushRequestMethod_Bind isEqualToString:method])
    {
        //NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        
        //NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        //NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        //NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        //int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        //NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}


@end
