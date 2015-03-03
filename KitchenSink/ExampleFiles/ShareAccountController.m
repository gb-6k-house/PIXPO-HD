

#import "MMAppDelegate.h"
#import "MMAboutViewController.h"
#import "ShareAccountController.h"
#import "RegisterInfo.h"

#import "AccountBasicInfo.h"

#import "ubiaRestClient.h"
#import "ubiaDeviceManager.h"

#import "Utilities.h"

@interface ShareAccountController ()
- (void)onCreateAccount:(QButtonElement *)buttonElement;


@end

@implementation ShareAccountController
@synthesize restClient;

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];

        self.root.appearance.tableGroupedBackgroundColor =  [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];
        
        //self.root.appearance.tableGroupedBackgroundColor= [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:1.0];
        
        ((QEntryElement *)[self.root elementWithKey:@"login_key"]).delegate = self;

        QAppearance *fieldsAppearance = [self.root.appearance copy];
     
        fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
        [self.root elementWithKey:@"login_key"].appearance = fieldsAppearance;
        [self.root elementWithKey:@"password_key"].appearance = fieldsAppearance;
        
        [self.root elementWithKey:@"savePassword_key"].appearance = fieldsAppearance;
        
     
        UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:14];

        
        [self.root elementWithKey:@"button_key"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"button_key"].appearance.backgroundColorEnabled = [UIColor greenColor];
  
        [self.root elementWithKey:@"button_key"].appearance.buttonAlignment  = NSTextAlignmentCenter;
        
        
        MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        restClient = appDelegate.deviceManager.restClient;
        
        //restClient = [[ubiaRestClient alloc] init];

    }

    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0;
    return 22;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.quickDialogTableView reloadCellForElements:entry, nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCompleted:) name: @"addShareAccountSuccessNotification" object:nil];
    
    [self.quickDialogTableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void) viewDidAppear:(BOOL)animated{

}
-(void) viewDidLoad:(BOOL)animated{


}

- (void)addCompleted:(NSNotification *)note {
    [self loading:NO];
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:[NSString stringWithFormat: @"Hi %@, I hope you're loving QuickDialog! Here's your pass: %@", info.login, info.password] delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:nil];
    //[alert show];
    

        //ubiaDevice * device = nil;
        NSString *command = [[note userInfo] objectForKey:@"RestCommand"];
        NSString *status = [[note userInfo] objectForKey:@"Status"];
    
        [self loading:NO];
        if([command isEqualToString:@"SHAREACCOUNT_OP_ADD"]){
            if ([status isEqualToString:@"OK"]) {
                NSLog(@"add ok");
            }else if([status isEqualToString:@"FAIL"]){
                 NSLog(@"add fail");
            }
        }
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName: @"loginSuccessNotification" object: restClient];
    
}

- (void)onCreateAccount:(QButtonElement *)buttonElement {

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self loading:YES];
    
    RegisterInfo *info = [[RegisterInfo alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:info];
  
    if((info.login == nil ||[info.login isEqualToString:@""])){
        [self loading:NO];
        return;
    }
    
    if((info.password == nil ||[info.password isEqualToString:@""])){
        [self loading:NO];
        return;
    }
    
    if(nil != info.realname && ![info.realname isEqualToString:@""]){
        info.realname = @"Buddy";
    }
    
    AccountBasicInfo * account = [[AccountBasicInfo alloc] init];
    account.login = info.login;
    account.password = info.password;
    account.realname = info.realname;
    
    [restClient shareaccount_op:account operate:1];

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
