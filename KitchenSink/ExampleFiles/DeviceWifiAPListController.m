

#import "MMAppDelegate.h"
#import "DeviceWifiAPListController.h"
#import "setupDeviceWifiConfigController.h"

#import "LoginInfo.h"

#import "ubiaDevice.h"
#import "ubiaClient.h"
#import "ubiaWifiApInfo.h"

extern char * ioctrlRecvBuf;
extern char * ioctrlSendBuf;

@interface DeviceWifiAPListController (){

}

- (void)onSelectWifiAP:(QButtonElement *)buttonElement;

@end

@implementation DeviceWifiAPListController
@synthesize currentDevice;
@synthesize aplistArray;
- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        //self.root.appearance.tableGroupedBackgroundColor =  [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];
        
        QAppearance *fieldsAppearance = [self.root.appearance copy];

        fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];


    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUbicSessionStatusNotification:) name:@"ubiaSessionStatusNotification" object:nil];

    [self.quickDialogTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}
-(void) viewDidAppear:(BOOL)animated{

}
-(void) viewDidLoad:(BOOL)animated{
  
}

-(void) handleUbicSessionStatusNotification:(NSNotification *)note{
    int sessionID = [[[note userInfo] objectForKey:@"ubicSessionID"] intValue];
    int errCode = [[[note userInfo] objectForKey:@"ubicErrorCode"] intValue];
    
    [self loading:NO];
    
    if(IOTCER_NoERROR == errCode){
        NSLog(@"receive Connect sucess");
        
    }else{
        NSLog(@"receive disconnect err %d", errCode);
        
        if(sessionID == currentDevice.client.sid){
            //MMCenterTableViewCell * cell = (MMCenterTableViewCell *)device.cell;
            currentDevice.client.status = UBIA_CLIENT_STATUS_PENDINGTO_DISCONNECT;
            NSLog(@"CenterView handleUbicSessionStatusNotification UID: %@ SID:%d status change to %d",currentDevice.uid, sessionID,errCode);
            [currentDevice stopclient];
            [currentDevice startclient];
        }
    }
}

- (void)onSelectWifiAP:(QButtonElement *)buttonElement {

    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    NSLog(@"onSelectWifiAP==>");
    QRootElement *root =  [[QRootElement alloc] init];
    root.title = NSLocalizedString(@"init_camera_step3_txt", nil);
    root.grouped = YES;
    root.controllerName = @"setupDeviceWifiConfigController";
    
    QSection *section = [[QSection alloc] initWithTitle:@"Wifi AP List"];
    section.title = @"Wifi Config";
    //section.headerImage = @"logo";
    section.footer = @"";
    
    QEntryElement *pwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"password", nil) Value:@"" Placeholder:NSLocalizedString(@"password", nil)];
    pwdEntry.bind=@"textValue:password";
    pwdEntry.key = @"password_key";
    pwdEntry.secureTextEntry = true;
    
    [section addElement:pwdEntry];
    [root addSection:section];
    
    QSection *section1 = [[QSection alloc] init];
    QButtonElement *myGetButton = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"init_camera_step3_txt", nil)];
    myGetButton.controllerAction = @"onSetWifiAPConfig:";
    myGetButton.key = @"set_button_key";
    
    [section1 addElement:myGetButton];
    
    [root addSection:section1];
    setupDeviceWifiConfigController * destViewController = (setupDeviceWifiConfigController * )[QuickDialogController controllerForRoot:root];
    
    ubiaWifiApInfo * apInfo = nil;
    int i = 0;
    for (i = 0; i < [aplistArray count]; i++) {
        apInfo = [aplistArray objectAtIndex:i];
        if([apInfo.ssid isEqualToString: [buttonElement title]]){
            break;
        }
    }
    if (i == [aplistArray count]) {
        NSLog(@"No that APInfo [ssid=%@] in the List", [buttonElement title]);
        return;
    }
    destViewController.currentDevice = currentDevice;
    destViewController.selectedAPInfo = apInfo;
    NSLog(@"onSelectWifiAP<==");
    
    [self.navigationController pushViewController:destViewController animated:YES];
}

+ (QRootElement *)createDetailsForm {
    QRootElement *details = [[QRootElement alloc] init];
    details.presentationMode = QPresentationModeModalForm;
    details.title = @"Details";
    details.controllerName = @"AboutController";
    details.grouped = YES;
    QSection *section = [[QSection alloc] initWithTitle:@"Information"];
    [section addElement:[[QTextElement alloc] initWithText:@"Here's some more info about this app."]];
    [details addSection:section];

    return details;
}

- (BOOL)QEntryShouldChangeCharactersInRangeForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Should change characters");
    return YES;
}

- (void)QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    //NSLog(@"Editing changed");
}


- (void)QEntryMustReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell {
    NSLog(@"Must return");

}




@end
