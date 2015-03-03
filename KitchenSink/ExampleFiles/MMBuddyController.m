//
//  MMRecordControllerTableViewController.m
//  P4PLive
//
//  Created by Maxwell on 14-7-1.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "MMBuddyController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMLogoView.h"
#import "MMCenterTableViewCell.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
#import "MMNavigationController.h"

#import "MMAppDelegate.h"
#import "ubiaDeviceManager.h"
#import "ubiaRestClient.h"
#import "Utilities.h"



@interface MMBuddyController ()

@end

@implementation MMBuddyController{
    __weak ubiaDeviceManager * deviceManager;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}
-(void) loadView{
    [super loadView];
    
    self.navigationItem.title = NSLocalizedString(@"buddy_txt", nil);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    deviceManager = appDelegate.deviceManager;
    
#if 1
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
#endif
    
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubleTap];
    
    UITapGestureRecognizer * twoFingerDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerDoubleTap:)];
    [twoFingerDoubleTap setNumberOfTapsRequired:2];
    [twoFingerDoubleTap setNumberOfTouchesRequired:2];
    [self.view addGestureRecognizer:twoFingerDoubleTap];
    
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton{
    //MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    
    
    //UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMenu:)];
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setFrame:CGRectMake(60, self.view.frame.size.height-16-25, 25, 25)];
    [addBtn setImage:[UIImage imageNamed:@"add_buddy"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(onAddBuddy) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addBarBtn = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    [addBtn setShowsTouchWhenHighlighted:YES];//设置发光
    [self.navigationItem setRightBarButtonItem:addBarBtn animated:YES];
    
}

-(void)contentSizeDidChange:(NSString *)size{
    [self.tableView reloadData];
}

-(void)refreshHandler
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm:ss a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    //[self reConnect:self];
    [self.refreshControl endRefreshing];
    
}

-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing data..."];
        //[deviceManager.restClient get_cloudinfo];

        [self.tableView reloadData];
        [self performSelector:@selector(refreshHandler) withObject:nil afterDelay:0];
    }
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buddyCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) onAddBuddy{
    
    QRootElement *root =  [[QRootElement alloc] init];//  [[QRootElement alloc] initWithJSONFile:@"registerform"];
    root.title = NSLocalizedString(@"create_account_txt", nil); //@"Create Account";
    root.grouped = YES;
    root.controllerName = @"ShareAccountController";
    
    QSection *section = [[QSection alloc] init];
    //section.title = @"Awesome Register Form";
    //MMAppDelegate * appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //section.headerImage = appDelegate.logoFile;
    
    section.footer = @"Please type your credentials.";
    
    QEntryElement *loginEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"login_id_txt", nil) Value:@"" Placeholder:NSLocalizedString(@"id_or_email_txt", nil)];
    loginEntry.bind=@"textValue:login";
    loginEntry.key = @"login_key";
    
    QEntryElement *pwdEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"password", nil) Value:@"" Placeholder:NSLocalizedString(@"password", nil)];
    pwdEntry.bind=@"textValue:password";
    pwdEntry.key = @"password_key";
    pwdEntry.secureTextEntry = true;
    
    
    QEntryElement *realnameEntry = [[QEntryElement alloc] initWithTitle:NSLocalizedString(@"name", nil) Value:@"" Placeholder:NSLocalizedString(@"name", nil)];
    realnameEntry.bind=@"textValue:checkcode";
    realnameEntry.key = @"realname_key";

    [root addSection:section];
    [section addElement:loginEntry];
    [section addElement:pwdEntry];
    [section addElement:realnameEntry];
    
    QSection *subsection2 = [[QSection alloc] init];
    QButtonElement *myButton = [[QButtonElement alloc] initWithTitle:NSLocalizedString(@"register_txt", nil)];
    myButton.controllerAction = @"onCreateAccount:";
    myButton.key = @"button_key";
    
    [subsection2 addElement:myButton];
    [root addSection:subsection2];
    
    //QuickDialogNavigationController *navigation = [QuickDialogController controllerWithNavigationForRoot:root];
    
    //[self.navigationController presentViewController:navigation animated:YES completion:^{
    //    NSLog(@"Register completion");
    //}];
    [self.navigationController pushViewController:[QuickDialogController controllerForRoot:root] animated:YES];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
