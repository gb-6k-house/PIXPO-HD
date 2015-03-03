//                                
// Copyright 2011 ESCOZ Inc  - http://escoz.com
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "MMAppDelegate.h"
#import "UIViewController+MMDrawerController.h"
#import "GeneralSettingController.h"
#import "LoginInfo.h"
#import "SVHTTPRequest.h"


//#import "MMDrawerController+Storyboard.h"
#import "MMDrawerBarButtonItem.h"

#import "ubiaRestClient.h"
//#import "Account.h"

@interface GeneralSettingController ()
- (void)onLogin:(QButtonElement *)buttonElement;
- (void)onAbout;
- (void)onBack;

@end

@implementation GeneralSettingController
@synthesize restClient;

- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        self.root.appearance.tableGroupedBackgroundColor =  [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];;
        ((QEntryElement *)[self.root elementWithKey:@"login"]).delegate = self;

        QAppearance *fieldsAppearance = [self.root.appearance copy];

        fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
        [self.root elementWithKey:@"login"].appearance = fieldsAppearance;
        [self.root elementWithKey:@"password"].appearance = fieldsAppearance;
        

        [self.root elementWithKey:@"button"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"button"].appearance.backgroundColorEnabled = [UIColor greenColor];
  
        [self.root elementWithKey:@"button"].appearance.buttonAlignment  = NSTextAlignmentCenter;

        MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        restClient = appDelegate.restClient;
         _leftBarimage = [UIImage imageNamed:@"album.png"];

    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
   
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(onAbout)];
    //UIImage * image =[MMDrawerBarButtonItem drawerButtonItemImage];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:_leftBarimage style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
                                             
    //:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    
    //[self setupLeftMenuButton];
    
    QEntryElement * loginEntry = (QEntryElement *)[self.root elementWithKey:@"login"];
    [loginEntry setTextValue:restClient.user_loginID];
    
    QEntryElement * pwdEntry = (QEntryElement *)[self.root elementWithKey:@"password"];
    [pwdEntry setTextValue:restClient.user_password];
    
    QBooleanElement *boolEntry = (QBooleanElement *)[self.root elementWithKey:@"autologin"];
    [boolEntry setBoolValue:restClient.autoLogin];
    boolEntry.onImage = [UIImage imageNamed:@"imgOn"];
    boolEntry.offImage = [UIImage imageNamed:@"imgOff"];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
-(void) viewDidAppear:(BOOL)animated{

}
-(void) viewDidLoad:(BOOL)animated{
  
}

- (void)loginCompleted:(LoginInfo *)info {
    [self loading:NO];
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:[NSString stringWithFormat: @"Hi %@, I hope you're loving QuickDialog! Here's your pass: %@", info.login, info.password] delegate:self cancelButtonTitle:@"YES!" otherButtonTitles:nil];
    //[alert show];
    
    [restClient persistSaveAccountInfo];
    
    NSArray *myKeys = [NSArray arrayWithObjects:@"restClient",nil];
    
    NSArray *myObjects = [NSArray arrayWithObjects: restClient,nil];
    NSDictionary *myTestDictionary = [NSDictionary dictionaryWithObjects:myObjects forKeys:myKeys];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"loginSuccessNotification" object:nil userInfo: myTestDictionary];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName: @"loginSuccessNotification" object: restClient];
    
}

- (void)onLogin:(QButtonElement *)buttonElement {

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self loading:YES];
    LoginInfo *info = [[LoginInfo alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:info];
  
    QBooleanElement *boolEntry = (QBooleanElement *)[self.root elementWithKey:@"autologin"];
    
    if([boolEntry boolValue]){
        if([restClient.user_loginID isEqualToString:@""] && (info.login == nil ||[info.login isEqualToString:@""])){
            [self loading:NO];
            return;
        }
        
        if([restClient.user_password isEqualToString:@""] && (info.password == nil ||[info.password isEqualToString:@""])){
            [self loading:NO];
            return;
        }

        
    }else{
    
        if (info.login == nil || info.password == nil ||[info.password isEqualToString:@""] || [info.login isEqualToString:@""]) {
            [self loading:NO];
            return;
        }
    }
    
    if(nil != info.password && ![info.password isEqualToString:@""]){
        restClient.user_password = info.password;
    }
    
    NSString *hmac_text=[NSString stringWithFormat:@"Time=%@&Nonce=%@&Seq=%@&Account=%@",
                      [restClient url_safe_base64_encode: restClient.Time],
                      [restClient url_safe_base64_encode: restClient.Nonce],
                      [restClient url_safe_base64_encode: @"4"],
                      [restClient url_safe_base64_encode:info.login]];

    
    NSLog(@"hmac_text : %@",hmac_text);
    
    restClient.user_safePassword = [restClient hmacsha1:restClient.user_password secret:@""];
    
    NSLog(@"safePassword : %@",restClient.user_safePassword);
    
    NSString *hmac=[restClient  hmacsha1:hmac_text secret:restClient.user_safePassword];
    
    NSString *urlString= [NSString stringWithFormat:@"%s?Function=48&Command=1&Hmac=%@&%@",REST_SERVICE_BASE,hmac,hmac_text];    

    //NSLog(@"urlString:%@",urlString);
    
    [SVHTTPRequest GET:urlString
            parameters:nil
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                BOOL result = [[response valueForKey:@"state"] boolValue];

                if(result){
                    restClient.user_token = [response valueForKey:@"Token"];
                    restClient.user_secret = [response valueForKey:@"Token_secret"];
                    restClient.user_loginID = info.login;
                    
                    NSLog(@"token=%@", restClient.user_token);
                    NSLog(@"secret=%@", restClient.user_secret);
                    
                    [self performSelector:@selector(loginCompleted:) withObject:info afterDelay:1];

                }else{
                    NSInteger reason = [[response valueForKey:@"reason"] integerValue];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Fail"
                                                                    message:[NSString stringWithFormat:@"%@",
                                                                             [restClient parseErrCodetoStr:reason]]
                                                                   delegate:self 
                                                          cancelButtonTitle:@"OK" 
                                                          otherButtonTitles:nil];
                    [alert show];
                    [self loading:NO];
                }
                
            }];

}

- (void)onAbout {
    QRootElement *details = [GeneralSettingController createDetailsForm];
    [self displayViewControllerForRoot:details];
}

- (void)onBack {

    [[NSNotificationCenter defaultCenter] postNotificationName: @"backTutorialPageNotification" object: nil];
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

- (IBAction)watchersRequest {
  //  watchersLabel.text = nil;
    
    [SVHTTPRequest GET:@"https://api.github.com/repos/samvermette/SVHTTPRequest"
            parameters:nil
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
 //               watchersLabel.text = [NSString stringWithFormat:@"SVHTTPRequest has %@ watchers", [response valueForKey:@"watchers"]];
            }];
}

- (IBAction)twitterRequest {
//    twitterImageView.image = nil;
    
    [[SVHTTPClient sharedClient] setBasePath:@"http://api.twitter.com/1/"];
    [[SVHTTPClient sharedClient] GET:@"users/profile_image"
                          parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                      @"samvermette", @"screen_name",
                                      @"original", @"size",
                                      nil]
                          completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
//                              twitterImageView.image = [UIImage imageWithData:response];
                          }];
}

- (IBAction)progressRequest {
    //progressLabel.text = nil;
    
    [SVHTTPRequest GET:@"http://sanjosetransit.com/extras/SJTransit_Icons.zip"
            parameters:nil
            saveToPath:@"/Users/maxwell/Desktop/test2.zip"
              progress:^(float progress) {
                  //progressLabel.text = [NSString stringWithFormat:@"Downloading (%.0f%%)", progress*100];
              }
            completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error) {
                //progressLabel.text = @"Download complete";
            }];
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
