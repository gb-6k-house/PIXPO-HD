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

#import "RegisterController.h"
#import "RegisterInfo.h"

#import "QImageElement.h"

#import "ubiaRestClient.h"
#import "ubiaDeviceManager.h"


@interface RegisterController (){
    int retries;
}
- (void)onCreate:(QButtonElement *)buttonElement;
- (void)onAbout;

@end

@implementation RegisterController

@synthesize restClient;


- (QuickDialogController *)initWithRoot:(QRootElement *)rootElement {
    self = [super initWithRoot:rootElement];
    if (self) {
        self.root.appearance = [self.root.appearance copy];
        self.root.appearance.tableGroupedBackgroundColor =  [UIColor colorWithHue:40/360.f saturation:0.58f brightness:0.90f alpha:1.f];;
        ((QEntryElement *)[self.root elementWithKey:@"login"]).delegate = self;

        QAppearance *fieldsAppearance = [self.root.appearance copy];

        fieldsAppearance.backgroundColorEnabled = [UIColor colorWithRed:0.9582 green:0.9104 blue:0.7991 alpha:1.0000];
        [self.root elementWithKey:@"login_key"].appearance = fieldsAppearance;
        [self.root elementWithKey:@"password_key"].appearance = fieldsAppearance;
        
        [self.root elementWithKey:@"checkcode_key"].appearance.entryAlignment  = NSTextAlignmentCenter;
        
        [self.root elementWithKey:@"button_key"].appearance = self.root.appearance.copy;
        [self.root elementWithKey:@"button_key"].appearance.backgroundColorEnabled = [UIColor greenColor];
 
        [self.root elementWithKey:@"button_key"].appearance.buttonAlignment  = NSTextAlignmentCenter;

        MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        restClient = appDelegate.deviceManager.restClient;
        
        //restClient = [[ubiaRestClient alloc] init];
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = nil;
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"about_txt", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onAbout)];
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back_txt", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
   [self loading:YES];
    //retries = 0;

   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCheckcodeCompleted:) name:@"getCheckcodeCompleteNotification" object:nil];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerCompleted:) name:@"registerCompleteNotification" object:nil];
   
   [restClient getCheckCode];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getCheckcodeCompleted:(NSNotification *)note {
    [self loading:NO];
    int status = [[[note userInfo] objectForKey:@"status"] intValue];
    
    if (status == 0) {
        //register success
        QEntryElement *checkcode = (QEntryElement *)[self.root elementWithKey:@"checkcode_key"];
        checkcode.image = [[note userInfo] objectForKey:@"image"];
        
        [self.quickDialogTableView reloadData];
    }
    
}


- (void)registerCompleted:(NSNotification *)note {
    [self loading:NO];
    int status = [[[note userInfo] objectForKey:@"status"] intValue];
    
    if (status == 0) {
        //register success
        RegisterInfo * reginfo = [[RegisterInfo alloc] init];
        [self.root fetchValueUsingBindingsIntoObject:reginfo];
        
        MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        appDelegate.deviceManager.restClient.user_loginID = reginfo.login;
        appDelegate.deviceManager.restClient.user_password = reginfo.password;
        [appDelegate.deviceManager.restClient.myDeviceList removeAllDevice];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)onCreate:(QButtonElement *)buttonElement {

    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    [self loading:YES];
    RegisterInfo *info = [[RegisterInfo alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:info];
   
    if(nil == info.login || nil == info.password || nil == info.checkcode){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[NSString stringWithFormat:@"请输入账号、密码、验证码"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self loading:NO];
        return;
    }

    BOOL retVal =  [restClient userRegister:info.login with: info.password with:info.checkcode];
    if (retVal == FALSE) {
        [self loading:NO];
    }

}

- (void)onAbout {
    QRootElement *details = [RegisterController createDetailsForm];
    [self displayViewControllerForRoot:details];
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

- (void) refreshCheckCode{
    NSLog(@"do refreshCheckCode");
}


@end
