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


#import "MMGeneralSettingController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMLogoView.h"
#import "MMCenterTableViewCell.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
#import "MMNavigationController.h"
#import "MMAboutViewController.h"

#import "MMAppDelegate.h"
#import "ubiaDevice.h"

#import "ubiaDeviceList.h"

#import "MMActivitiesDetailController.h"
#import "ubiaDeviceTableViewCell.h"
#import "ubiaLocalConfig.h"
#import "ubiaDeviceManager.h"
#import "ubiaRestClient.h"

#import "AccountSecurityController.h"
#import "MMNotificationSettingController.h"
#import "MMCloudSettingController.h"
#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, MMCenterViewControllerSection){
    MMCenterViewControllerSectionLeftViewState,
    MMCenterViewControllerSectionLeftDrawerAnimation,
    MMCenterViewControllerSectionRightViewState,
    MMCenterViewControllerSectionRightDrawerAnimation,
};

@interface MMGeneralSettingController (){
    NSArray * settingItemList;
    __weak ubiaDeviceManager *deviceManager;
}

@end

@implementation MMGeneralSettingController
@synthesize restClient;
@synthesize deviceList;
@synthesize detailViewController;
@synthesize settingItemList;
@synthesize items,values;


- (id)init
{
    self = [super init];
    if (self) {
        [self setRestorationIdentifier:@"MMGeneralSettingControllerRestorationKey"];

    }
    return self;
}

-(void) loadView{
    [super loadView];
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    deviceManager = appDelegate.deviceManager;
    restClient = appDelegate.deviceManager.restClient;
    deviceList = restClient.publicList;
  
    
    //NSArray *section0 = [[NSArray alloc] initWithObjects:NSLocalizedString(@"my_account_txt", nil), nil];
#if 0
    NSArray *section1 = [[NSArray alloc] initWithObjects:
                         NSLocalizedString(@"cloudservice_txt", nil),
                         //NSLocalizedString(@"privacy_txt", nil),
                         //NSLocalizedString(@"general_txt", nil),
                         nil];
#endif
    NSArray *section2 = [[NSArray alloc] initWithObjects:
                         NSLocalizedString(@"notifications_txt", nil),
                         //NSLocalizedString(@"privacy_txt", nil),
                         //NSLocalizedString(@"general_txt", nil),
                         nil];
    
    NSArray *section3 = [[NSArray alloc] initWithObjects:NSLocalizedString(@"about_txt", nil), nil];
    
    //NSArray *section4 = [[NSArray alloc] initWithObjects:NSLocalizedString(@"logout_txt", nil), nil];
    
    //settingItemList = [[NSArray alloc] initWithObjects:section0,section1,section2,section3,section4,nil];
    
#ifdef USING_AS_STANDALONE
    settingItemList = [[NSArray alloc] initWithObjects:section2,section3,nil];
#else
    settingItemList = [[NSArray alloc] initWithObjects:section0,section2,section3,section4,nil];
#endif
    self.navigationItem.title = NSLocalizedString(@"settings_txt", nil);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer * twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerDoubleTap:)];
    [twoFingerDoubleTap setNumberOfTapsRequired:2];
    [twoFingerDoubleTap setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:twoFingerDoubleTap];
    

    [self setupLeftMenuButton];
    //[self setupRightMenuButton];
    
    if(OSVersionIsAtLeastiOS7()){
        UIColor * barColor = [UIColor
                              colorWithRed:247.0/255.0
                              green:249.0/255.0
                              blue:250.0/255.0
                              alpha:1.0];
        [self.navigationController.navigationBar setBarTintColor:barColor];
    }
    else {
        UIColor * barColor = [UIColor
                              colorWithRed:78.0/255.0
                              green:156.0/255.0
                              blue:206.0/255.0
                              alpha:1.0];
        [self.navigationController.navigationBar setTintColor:barColor];
    }
    
    
    UIView *backView = [[UIView alloc] init];
    [backView setBackgroundColor:[Utilities viewBackgroundColor]];
    [self.tableView setBackgroundView:backView];
    
}


- (void) appWillEnterForegroundNotification{
    
    NSLog(@"MMPublicDeviceController trigger event when will enter foreground.");
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    restClient = appDelegate.deviceManager.restClient;
    NSLog(@"%@ ", restClient);

    
}
- (void) appWillResignActiveNotification{
    
    NSLog(@"MMPublicDeviceController trigger event when will Resign Active.");
    
    NSLog(@"%@", restClient);

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"MMPublicDeviceController will appear");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    
    [self.tableView reloadData];
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"MMPublicDeviceController did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"MMPublicDeviceController will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    NSLog(@"MMPublicDeviceController did disappear");
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton{
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}

-(void)contentSizeDidChange:(NSString *)size{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [settingItemList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *tmpitems = [settingItemList objectAtIndex:section];
    return [tmpitems count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
#ifdef USING_AS_STANDALONE
    cell = [tableView dequeueReusableCellWithIdentifier:@"mmSettingBasicCell" forIndexPath:indexPath];
#else
    if ([settingItemList count] - 1 == [indexPath section]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"mmSettingBtnCell" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"mmSettingBasicCell" forIndexPath:indexPath];
    }
#endif
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //MMCenterTableViewCell  *cell = (MMCenterTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        //int row = [indexPath row];
 
        [self.tableView reloadData];

    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = [[settingItemList objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    //QRootElement *root = [SampleDataBuilder create];
    //ExampleViewController *quickformController = (ExampleViewController *) [[ExampleViewController alloc] initWithRoot:root];
    
    //[self.navigationController pushViewController:quickformController animated:YES];
#ifdef USING_AS_STANDALONE
    
    if(0 == [indexPath section] && 0 == [indexPath row]){
        [self onClickNotificationSetting];
    }
    
    if(1 == [indexPath section] && 0 == [indexPath row]){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:appDelegate.storyboardName bundle:nil];
        
        UIViewController * aboutViewer = [storyboard instantiateViewControllerWithIdentifier:@"aboutViewer"];
        
        
        //[aboutViewer.view setBackgroundColor:[UIColor colorWithRed:208.0/255.0
        //                                              green:208.0/255.0
        //                                              blue:208.0/255.0
        //                                             alpha:1.0]];
        
        //[aboutViewer.view setBackgroundColor:[UIColor colorWithHue:120/360.f saturation:0.95f brightness:0.80f alpha:1.f]];
        
        [aboutViewer.view setBackgroundColor:[UIColor colorWithRed:208.0/255.0
                                                             green:208.0/255.0
                                                              blue:208.0/255.0
                                                             alpha:1.0]];
        
        
        [self.navigationController pushViewController: aboutViewer animated:YES];

    }
#else
    
    if(0 == [indexPath section] && 0 == [indexPath row]){
        //Account and Security
        [self onClickAccountSecurity];
    }
#if 0
    if(1 == [indexPath section]){
        switch ([indexPath row]) {
            case 0:
                //Notification
                [self onClickCloudSetting];
                break;

            default:
                break;
        }
    }
#endif
    if(1 == [indexPath section]){
        switch ([indexPath row]) {
            case 0:
                //Notification
                [self onClickNotificationSetting];
                break;
            case 1:
                //Privacy
                [self onClickPrivacy];
                break;
            case 2:
                //General
                [self onClickGeneral];
                break;
            default:
                break;
        }
    }
    
    
    if(3 == [indexPath section] && 0 == [indexPath row]){

        [appDelegate.deviceManager.restClient.myDeviceList removeAllDevice];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"backTutorialPageNotification" object: nil];
    }
    
    if(2 == [indexPath section] && 0 == [indexPath row]){
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:appDelegate.storyboardName bundle:nil];
        
        UIViewController * aboutViewer = [storyboard instantiateViewControllerWithIdentifier:@"aboutViewer"];
        

        //[aboutViewer.view setBackgroundColor:[UIColor colorWithRed:208.0/255.0
        //                                              green:208.0/255.0
        //                                              blue:208.0/255.0
        //                                             alpha:1.0]];
        
        //[aboutViewer.view setBackgroundColor:[UIColor colorWithHue:120/360.f saturation:0.95f brightness:0.80f alpha:1.f]];
        
        [aboutViewer.view setBackgroundColor:[UIColor colorWithRed:208.0/255.0
                                                     green:208.0/255.0
                                                      blue:208.0/255.0
                                                     alpha:1.0]];
        
        
        [self.navigationController pushViewController: aboutViewer animated:YES];
        //MMAboutViewController * aboutViewer = [[MMAboutViewController alloc] init];
        //[self.navigationController pushViewController:aboutViewer animated:YES];
    }
#endif

}
- (void) onClickAccountSecurity{
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"account_and_security_txt", nil);
    root.grouped = YES;
    root.controllerName = @"AccountSecurityController";
    
    QSection *section = [[QSection alloc] initWithTitle:NSLocalizedString(@"account_txt", nil)];
    
    QLabelElement * accountEntry = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"account_txt", nil) Value:restClient.user_loginID];
    accountEntry.key = @"account_key";
    
    QEntryElement * oldpwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"old_password_txt", nil) Value:@""];
    oldpwdEntry.key = @"old_password_key";
    oldpwdEntry.placeholder = NSLocalizedString(@"old_password_placeholder_txt", nil);
    oldpwdEntry.secureTextEntry = TRUE;
    
    QEntryElement * newpwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"new_password_txt", nil) Value:@""];
    newpwdEntry.key = @"new_password_key";
    newpwdEntry.placeholder = NSLocalizedString(@"new_password_placeholder_txt", nil);
    newpwdEntry.secureTextEntry = TRUE;
    
    QEntryElement * newrepwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"reenter_password_txt", nil) Value:@""];
    newrepwdEntry.key = @"reenter_password_key";
    newrepwdEntry.placeholder = NSLocalizedString(@"reenter_password_placeholder_txt", nil);
    newrepwdEntry.secureTextEntry = TRUE;
    
    [section addElement:accountEntry];
    
    QSection *section1 = [[QSection alloc]init];
    
    [section1 addElement:oldpwdEntry];
    [section1 addElement:newpwdEntry];
    [section1 addElement:newrepwdEntry];
    
    QSection *section2 = [[QSection alloc]init];
    
    QButtonElement * applyEntry = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"apply_button_txt", nil)];
    [section2 addElement:applyEntry];
    applyEntry.key = @"button_key";
    applyEntry.controllerAction = @"onModify:";
    [root addSection:section];
    [root addSection:section1];
    [root addSection:section2];
    
    AccountSecurityController * destview = (AccountSecurityController *)[QuickDialogController controllerForRoot:root];
    [self.navigationController pushViewController:destview animated:YES];
    
}


- (void)onClickCloudSetting{
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"cloudservice_txt", nil);
    root.grouped = YES;
    root.controllerName = @"MMCloudSettingController";
    
    QSection *section1 = [[QSection alloc] initWithTitle:NSLocalizedString(@"", nil)];
    QRadioElement *activate = [[QRadioElement alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"notifications_on_txt", nil), NSLocalizedString(@"notifications_off_txt", nil), nil] selected:deviceManager.localConfig.cloudstatus title:NSLocalizedString(@"cloudservice_txt", nil)];
    
    activate.controllerAction = @"onOperation:";
    
    [section1 addElement:activate];
    [root addSection:section1];
    
    MMCloudSettingController * destview = (MMCloudSettingController *)[QuickDialogController controllerForRoot:root];
    [self.navigationController pushViewController:destview animated:YES];
}

- (void)onClickNotificationSetting{
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"notifications_txt", nil);
    root.grouped = YES;
    root.controllerName = @"MMNotificationSettingController";
    
    QSection *section = [[QSection alloc] initWithTitle:NSLocalizedString(@"", nil)];
    
    NSString *osnotifystatus;
    if(1){
        osnotifystatus = NSLocalizedString(@"notifications_on_txt", nil);
    }else{
        osnotifystatus = NSLocalizedString(@"notifications_off_txt", nil);
    }
    
    QLabelElement * system_notification_status = [[QLabelElement alloc] initWithTitle:NSLocalizedString(@"receive_notification_txt", nil) Value:osnotifystatus];
    
    [section addElement:system_notification_status];
    [root addSection:section];
    
    
    QSection *section1 = [[QSection alloc] initWithTitle:NSLocalizedString(@"", nil)];
    QRadioElement *nodisturbWithAction = [[QRadioElement alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"on_txt", nil), NSLocalizedString(@"on_just_night_txt", nil), NSLocalizedString(@"off_txt", nil), nil] selected:deviceManager.localConfig.silentMode title:NSLocalizedString(@"notifications_nodisturb_txt", nil)];
    
    nodisturbWithAction.controllerAction = @"onNoDisturbAction:";
    
    [section1 addElement:nodisturbWithAction];
    [root addSection:section1];

#if 0
    QSection *section2 = [[QSection alloc] initWithTitle:NSLocalizedString(@"", nil)];
    

    QBooleanElement *voice = [[QBooleanElement alloc] initWithTitle:
                                    NSLocalizedString(@"notification_voice_txt", nil)BoolValue:deviceManager.localConfig.notificationType & UIRemoteNotificationTypeSound];
    voice.controllerAction = @"onVoiceAction:";
    
    QBooleanElement *vibrate = [[QBooleanElement alloc] initWithTitle:
                              NSLocalizedString(@"notification_vibrate_txt", nil)BoolValue:    deviceManager.localConfig.notificationType & UIRemoteNotificationTypeAlert];
    
    vibrate.controllerAction = @"onVibrateAction:";
    
    //bool2.onImage = [UIImage imageNamed:@"imgOn"];
    //bool2.offImage = [UIImage imageNamed:@"imgOff"];

    [section2 addElement:voice];
    [section2 addElement:vibrate];
    
    [root addSection:section2];
#endif
    MMNotificationSettingController * destview = (MMNotificationSettingController *)[QuickDialogController controllerForRoot:root];
    [self.navigationController pushViewController:destview animated:YES];
}
- (void) onClickPrivacy{
    
    
}

- (void) onClickGeneral{


}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifer = [segue identifier];
    NSLog(@"id:%@",identifer);
    
    if ([[segue identifier] isEqualToString:@"goGeneralSettingView"]) {
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        NSLog(@"segue prepare to %@",[segue identifier]);
        
        //ubiaDevice * device = [deviceList getDeviceByIndex:[indexPath row]];

        //MMActivitiesDetailController * view = (MMActivitiesDetailController *)[segue destinationViewController];
        
        //[view setCurrentDevice:device];
        
    }
}

/***===========================***/

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

/*
 In response to a swipe gesture, show the image view appropriately then move the image view in the direction of the swipe as it fades out.
 */
- (IBAction)handleGestureforLongPress:(id)sender {
    NSLog(@"long press");
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL retVal = FALSE;

    return retVal;
}


@end
