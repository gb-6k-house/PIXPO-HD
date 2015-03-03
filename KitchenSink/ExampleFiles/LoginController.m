

#import "MMAppDelegate.h"
#import "MMAboutViewController.h"
#import "LoginController.h"
#import "LoginInfo.h"

#import "ubiaRestClient.h"
#import "ubiaDeviceManager.h"


@interface LoginController ()
- (void)onLogin:(QButtonElement *)buttonElement;
- (void)onAbout;
- (void)onBack;

@end

@implementation LoginController
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
        
        [self.root elementWithKey:@"hyperlink_key"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"hyperlink_key"].appearance.buttonAlignment = NSTextAlignmentRight;
     
        UIFont * font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        
        [self.root elementWithKey:@"hyperlink_key"].appearance.labelFont = font;
        
        [self.root elementWithKey:@"hyperlink_key"].appearance.tableGroupedBackgroundColor = [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];
        [self.root elementWithKey:@"hyperlink_key"].appearance.backgroundColorEnabled = [UIColor clearColor];
        [self.root elementWithKey:@"hyperlink_key"].appearance.actionColorEnabled = [UIColor blueColor];
        [self.root elementWithKey:@"hyperlink_key"].appearance.tableSeparatorColor = [UIColor clearColor];
        
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
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"about_txt", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onAbout)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back_txt", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    
    
    
#if 1
    QEntryElement * loginEntry = (QEntryElement *)[self.root elementWithKey:@"login_key"];
    [loginEntry setTextValue:restClient.user_loginID];
    [loginEntry setTitle:NSLocalizedString(@"login_id_txt", nil)];
    
    QEntryElement * pwdEntry = (QEntryElement *)[self.root elementWithKey:@"password_key"];
    [pwdEntry setTextValue:restClient.user_password];
    
    [pwdEntry setTitle:NSLocalizedString(@"password", nil)];
    
    QBooleanElement *boolEntry = (QBooleanElement *)[self.root elementWithKey:@"savePassword_key"];

    [boolEntry setTitle:NSLocalizedString(@"remember_password_txt", nil)];

    //boolEntry.onImage = [UIImage imageNamed:@"imgOn"];
    //boolEntry.offImage = [UIImage imageNamed:@"imgOff"];
    [boolEntry setBoolValue:restClient.savePassword];
    
    //QButtonElement *buttonEntry = ( QButtonElement *)[self.root elementWithKey:@"button_key"];
    //[buttonEntry setTitle:NSLocalizedString(@"login_txt", nil)];
#endif
    //[self.quickDialogTableView reloadCellForElements:entry, nil];
    [self.quickDialogTableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void) viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCompleted:) name:@"loginCompleteNotification" object:nil];
}
-(void) viewDidLoad:(BOOL)animated{


}

- (void)loginCompleted:(NSNotification *)note {
    [self loading:NO];
    
    int status = [[[note userInfo] objectForKey:@"status"] intValue];
    
    if (status == 0) {
        //login success
        NSArray *myKeys = [NSArray arrayWithObjects:@"restClient",nil];
        
        NSArray *myObjects = [NSArray arrayWithObjects: restClient,nil];
        NSDictionary *myTestDictionary = [NSDictionary dictionaryWithObjects:myObjects forKeys:myKeys];
        
        [[NSNotificationCenter defaultCenter] postNotificationName: @"loginSuccessNotification" object:nil userInfo: myTestDictionary];
    }
    
}

- (void)onLogin:(QButtonElement *)buttonElement {

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self loading:YES];
    LoginInfo *info = [[LoginInfo alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:info];
  
    if([restClient.user_loginID isEqualToString:@""] && (info.login == nil ||[info.login isEqualToString:@""])){
        [self loading:NO];
        return;
    }
    
    if([restClient.user_password isEqualToString:@""] && (info.password == nil ||[info.password isEqualToString:@""])){
        [self loading:NO];
        return;
    }
    
    if(nil != info.password && ![info.password isEqualToString:@""]){
        restClient.user_password = info.password;
    }
    QBooleanElement *boolEntry = (QBooleanElement *)[self.root elementWithKey:@"savePassword_key"];
    restClient.savePassword = [boolEntry boolValue];

    if (FALSE == [restClient userLogin:info.login with:info.password]){
        [self loading:NO];
    }
    
}

- (void) onGotoCreateAccount:(QButtonElement *)buttonElement {
    QRootElement *root =  [[QRootElement alloc] init];//  [[QRootElement alloc] initWithJSONFile:@"registerform"];
    root.title = NSLocalizedString(@"create_account_txt", nil); //@"Create Account";
    root.grouped = YES;
    root.controllerName = @"RegisterController";
    
    QSection *section = [[QSection alloc] init];
    section.title = @"Awesome Register Form";
    MMAppDelegate * appDelegate = [[UIApplication sharedApplication]delegate];
    
    section.headerImage = appDelegate.logoFile;
    
    section.footer = @"Please type your credentials.";
    
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
    
    //QuickDialogNavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
    
    //[self.navigationController presentViewController:navigation animated:YES completion:^{
    //    NSLog(@"Register completion");
    //}];
    [self.navigationController pushViewController:[QuickDialogController controllerForRoot:root] animated:YES];
    
}
- (void)onAbout {
    //QRootElement *details = [LoginController createDetailsForm];
    //[self displayViewControllerForRoot:details];
    
    MMAppDelegate * appDelegate = [[UIApplication sharedApplication]delegate];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:appDelegate.storyboardName bundle:nil];
    UIViewController * aboutviewer = [storyboard instantiateViewControllerWithIdentifier:@"aboutViewer"];
    
    
    [aboutviewer.view setBackgroundColor:[UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f]];
    
    [self.navigationController pushViewController:aboutviewer animated:YES];
    
    //MMAboutViewController * aboutViewer = [[MMAboutViewController alloc] init];
    //[self displayViewController: aboutViewer];
}

-(void)onBackButtonPress:(id)sender{
    //didn't login just view public
    //[[NSNotificationCenter defaultCenter] postNotificationName: @"backTutorialPageNotification" object: nil];

    
}

- (void)onBack {

    //[[NSNotificationCenter defaultCenter] postNotificationName: @"backTutorialPageNotification" object: nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
        //deviceManager.isPublicView = FALSE;
        NSLog(@"Exit LoginController");
    }];
}


+ (QRootElement *)createDetailsForm {
    QRootElement *details = [[QRootElement alloc] init];
    details.presentationMode = QPresentationModeModalForm;
    details.title = NSLocalizedString(@"about_txt", nil);
    details.controllerName = @"AboutController--";
    details.grouped = NO;
    QSection *section = [[QSection alloc] initWithTitle:@""];
    section.headerImage = @"80x80";
    
    QLabelElement *ver = [[QLabelElement alloc] initWithTitle:@"P4PLive 1.0" Value:@""];
    ver.key = @"ver_key";
    
    [section addElement:ver];
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
