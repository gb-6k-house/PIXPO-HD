
#import "MMAppDelegate.h"
#import "easyBindDeviceController.h"
#import "BindDeviceInfo.h"
//#import "SVHTTPRequest.h"

#import "ubiaRestClient.h"
#import "ubiaDeviceList.h"
#import "ubiaDevice.h"
#import "ubiaDeviceManager.h"

#import "ubiaClient.h"

@interface easyBindDeviceController (){

}
@end

@implementation easyBindDeviceController
@synthesize deviceUID;
@synthesize isKilled;
@synthesize toBindDeviceList;


- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        //self.root.appearance.tableGroupedBackgroundColor =  [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];
        ((QEntryElement *)[self.root elementWithKey:@"login_key"]).delegate = self;
        
        QAppearance *fieldsAppearance = [self.root.appearance copy];

        fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
        [self.root elementWithKey:@"password_key"].appearance = fieldsAppearance;
        
        [self.root elementWithKey:@"set_button_key"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"set_button_key"].appearance.backgroundColorEnabled = [UIColor colorWithRed:0.4 green:0.8104 blue:0.7991 alpha:1.0000];
  
        [self.root elementWithKey:@"set_button_key"].appearance.buttonAlignment  = NSTextAlignmentCenter;
        
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restClientAddDeviceComplete:) name: @"ubiaRestClientCompleteNotification" object:nil];
    
    [self.quickDialogTableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    isKilled = TRUE;
}
-(void) viewDidAppear:(BOOL)animated{
    isKilled = FALSE;
    [super viewDidAppear:animated];
}

- (void)onBindDevice{

    //[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
 
    BindDeviceInfo *info = [[BindDeviceInfo alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:info];
    
    
    if (info.login == nil && [info.login length] == 0) {
        //update user input
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                    message:NSLocalizedString(@"easy_input_device_login_txt", nil)
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    if (info.password == nil && [info.password length] == 0) {
        //update user input
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                    message:NSLocalizedString(@"easy_input_device_password_txt", nil)
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (deviceUID == nil || [deviceUID length] != UID_SIZE) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                            message:NSLocalizedString(@"uid_len_invalid", nil)
                                            delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    ubiaDevice *newDevice = [[ubiaDevice alloc] init];
    
    newDevice.uid = deviceUID;
    newDevice.loginID = info.login;
    newDevice.password = info.password;
    newDevice.name = info.name;
    if (info.location == nil || [info.location length] == 0) {
        newDevice.location= @"Default Location";
    }else{
        newDevice.location = info.location;
    }
    
    newDevice.client.password = info.password;
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    ubiaRestClient * restClient = appDelegate.deviceManager.restClient;

    [self loading:YES];
    [restClient device_op:newDevice operate:DEVICE_OP_ADD];
}

- (void)restClientAddDeviceComplete:(NSNotification *)note{
    //ubiaDevice * device = nil;
    NSString *command = [[note userInfo] objectForKey:@"RestCommand"];
    [self loading:NO];
    if([command isEqualToString:@"DEVICE_OP_ADD"]){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
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
