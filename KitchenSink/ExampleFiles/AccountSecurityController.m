

#import "MMAppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "AccountSecurityController.h"
#import "LoginInfo.h"
#import "AccountBasicInfo.h"

//#import "MMDrawerController+Storyboard.h"
#import "MMDrawerBarButtonItem.h"

#import "ubiaRestClient.h"
#import "ubiaDeviceManager.h"
#import "ubiaLocalConfig.h"
#import "AccountBasicInfo.h"


@interface AccountSecurityController ()
- (void)onModify:(QButtonElement *)buttonElement;

@end

@implementation AccountSecurityController
@synthesize restClient;

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        //self.root.appearance.tableGroupedBackgroundColor =  [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];;
        ((QEntryElement *)[self.root elementWithKey:@"login"]).delegate = self;

        QAppearance *fieldsAppearance = [self.root.appearance copy];

        fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
   
        [self.root elementWithKey:@"old_password_key"].appearance = fieldsAppearance;
        [self.root elementWithKey:@"new_password_key"].appearance = fieldsAppearance;
        [self.root elementWithKey:@"reenter_password_key"].appearance = fieldsAppearance;
        

        [self.root elementWithKey:@"button_key"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"button_key"].appearance.backgroundColorEnabled = [UIColor colorWithRed:0.4 green:0.8104 blue:0.7991 alpha:1.0000];
  
        [self.root elementWithKey:@"button_key"].appearance.buttonAlignment  = NSTextAlignmentCenter;

        MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        restClient = appDelegate.deviceManager.restClient;
        
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
   
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(onAbout)];
    //UIImage * image =[MMDrawerBarButtonItem drawerButtonItemImage];

    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:_leftBarimage style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    //_leftBarimage = [UIImage imageNamed:@"album.png"];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void) viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyCompleted:) name:@"accountOPCompleteNotification" object:nil];
}


- (void)modifyCompleted:(NSNotification *)note {
    [self loading:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onModify:(QButtonElement *)buttonElement {

    [self loading:YES];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self loading:YES];
    AccountBasicInfo *info = [[AccountBasicInfo alloc] init];
    
    [self.root fetchValueUsingBindingsIntoObject:info];
  
    QEntryElement * oldpwdEntry = (QEntryElement *)[self.root elementWithKey:@"old_password_key"];
    if(nil == oldpwdEntry.textValue)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[NSString stringWithFormat:@"Please Provide your original password"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self loading:NO];
        return;
    }else{
        if (![oldpwdEntry.textValue isEqualToString:restClient.user_password]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:[NSString stringWithFormat:@"Wrong original password"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self loading:NO];
            return;
        }
    }
    
    
    QEntryElement * newpwdEntry = (QEntryElement *)[self.root elementWithKey:@"new_password_key"];
    
    QEntryElement * reenterpwdEntry = (QEntryElement *)[self.root elementWithKey:@"reenter_password_key"];
    
    if (nil == newpwdEntry.textValue || nil == reenterpwdEntry.textValue || ![newpwdEntry.textValue isEqualToString: reenterpwdEntry.textValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[NSString stringWithFormat:@"twice input password mismatch"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self loading:NO];
        return;
    }
    AccountBasicInfo *maccountinfo = [[AccountBasicInfo alloc] init];
    maccountinfo.login = restClient.user_loginID;
    maccountinfo.password = newpwdEntry.textValue;
    
    if (FALSE == [restClient account_op:maccountinfo operate:3]){
        [self loading:NO];
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

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton{
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}

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
