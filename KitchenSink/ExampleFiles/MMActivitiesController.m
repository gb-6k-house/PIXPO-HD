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


#import "MMActivitiesController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "MMLogoView.h"
#import "MMCenterTableViewCell.h"
#import "MMExampleLeftSideDrawerViewController.h"
#import "MMExampleRightSideDrawerViewController.h"
#import "MMNavigationController.h"

#import "MMAppDelegate.h"
#import "MMActivityTableViewCell.h"
#import "MMActivity.h"
#import "ubiaDeviceManager.h"
#import "ubiaRestClient.h"
#import "ubiaDevice.h"
#import "Utilities.h"
#import "ubiaAlert.h"

#import "MMActivitiesDetailController.h"
#import  "ubiaAlertDetailViewController.h"

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, MMCenterViewControllerSection){
    MMCenterViewControllerSectionLeftViewState,
    MMCenterViewControllerSectionLeftDrawerAnimation,
    MMCenterViewControllerSectionRightViewState,
    MMCenterViewControllerSectionRightDrawerAnimation,
};

@interface MMActivitiesController ()

@end

@implementation MMActivitiesController
@synthesize detailViewController;

- (id)init
{
    self = [super init];
    if (self) {
        [self setRestorationIdentifier:@"MMPublicDeviceControllerRestorationKey"];
    }
    return self;
}

-(void) loadView{
    [super loadView];
    //Add by Maxwell to init P4PController
#if 0
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    MMActivity * newActivity = [[MMActivity alloc] init];
    newActivity.alertType = 1;
    newActivity.devUID = @"ZH5NK7JHFJRYO6GB7QMQ";
    newActivity.snapFile = @"";
    newActivity.timeStamp = [NSDate date];
    newActivity.timeZone = -8;
    
    [self insertNewActivityObject:newActivity];
#endif
    
    self.navigationItem.title = NSLocalizedString(@"activity_txt", nil);
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
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
    
    //MMLogoView * logo = [[MMLogoView alloc] initWithFrame:CGRectMake(0, 0, 29, 31)];
    //[self.navigationItem setTitleView:logo];
    //[self.navigationController.view.layer setCornerRadius:10.0f];
    
    //UIView *backView = [[UIView alloc] init];
    //[backView setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:208.0/255.0  blue:208.0/255.0 alpha:1.0]];
    //[self.tableView setBackgroundView:backView];
}

- (void)restClientComplete:(NSNotification *)note{
    //ubiaDevice * device = nil;
    NSString *command = [[note userInfo] objectForKey:@"RestCommand"];
    
    if([command isEqualToString:@"GET_PUBLICLIST"]){
        //[deviceList stopAllDevice];
        //deviceList = restClient.publicList;
        //[deviceList startAllDevice];
        [self.tableView reloadData];
    }
    
}

- (void) appWillEnterForegroundNotification{
    
    NSLog(@"MMActivitiesController trigger event when will enter foreground.");
    
    //MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    
}
- (void) appWillResignActiveNotification{
    
    NSLog(@"MMActivitiesController trigger event when will Resign Active.");

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"MMActivitiesController will appear");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActiveNotification) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restClientComplete:) name: @"ubiaRestClientCompleteNotification" object:nil];

    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"MMActivitiesController did appear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"MMActivitiesController will disappear");
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    NSLog(@"MMActivitiesController did disappear");
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

#if 0
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
#endif

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mmActivityCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        //self.detailViewController.detailItem = object;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"goActivityDetailView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        //[[segue destinationViewController] setDetailItem:object];
        MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
        ubiaDevice * device = [appDelegate.deviceManager.restClient.myDeviceList getDeviceByUID:[[object valueForKey:@"devUID"] description]];
        NSDate  *timeStamp = [object valueForKey:@"timeStamp"];

        ubiaAlertDetailViewController * detailViewer = [segue destinationViewController];
        detailViewer.currentDevice = device;
        
        ubiaAlert *  alert = [[ubiaAlert alloc] init];
        
        NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
        NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        
        NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:timeStamp];
        NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:timeStamp];
        NSTimeInterval gmtInterval = gmtOffset - currentGMTOffset;
        
        NSDate *destDate =[[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:timeStamp];
        
        // 获取时间中的详细信息年、月、日、时、分、秒
        //NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        
        NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit | NSHourCalendarUnit|NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:destDate];
        
        alert.year = [dateComponent year];
        alert.month = [dateComponent month];
        alert.day = [dateComponent day];

        alert.hour = [dateComponent hour];
        alert.minute = [dateComponent minute];
        alert.second = [dateComponent second];
        
        detailViewer.alert = alert;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
        
        //[dateFormatter setDateFormat:@"yy-MM-dd a hh:mm:ss"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *stDate = [object valueForKey:@"timeStamp"];
        NSString *dateString = [dateFormatter stringFromDate:stDate];
        
        detailViewer.dateLabel.text = dateString;
        
        dateString = [dateFormatter stringFromDate:stDate];
        [dateFormatter setDateFormat:@"zzz a hh:mm:ss"];
        detailViewer.timeLabel.text = dateString;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL retVal = FALSE;
    
    if ([identifier isEqualToString:@"goActivityDetailView"]) {
        
        MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if (nil == appDelegate.deviceManager.restClient || nil == appDelegate.deviceManager.restClient.myDeviceList ||
            nil == [appDelegate.deviceManager.restClient.myDeviceList getDeviceByUID:[[object valueForKey:@"devUID"] description]]) {
            
            retVal = FALSE;
        }else {
            retVal = TRUE;
        }
        
    }
    return retVal;
}

#pragma mark - Fetched results controller

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

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    MMActivityTableViewCell *activityCell = (MMActivityTableViewCell *) cell;
    ubiaFileNode *node =[[ubiaFileNode alloc] init];
    
    NSString * devUID = [[object valueForKey:@"devUID"] description];
    
    node.fileName = [[object valueForKey:@"snapFile"] description];
    node.pathName = devUID;
    
    activityCell.snapImageView.image = [Utilities loadImageFile:node];
    
    if(nil == activityCell.snapImageView.image){
        
        activityCell.snapImageView.image = [UIImage imageNamed:@"alert2.png"];
    }
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];

    ubiaDevice * device = [appDelegate.deviceManager.restClient.myDeviceList getDeviceByUID:devUID];
    
    if(nil == device || nil == device.name){
        activityCell.nameLabel.text = [[object valueForKey:@"devUID"] description];
    }else {
        activityCell.nameLabel.text = device.name;
    }
    
    switch ([[[object valueForKey:@"alertType"] description] intValue]) {
        case 1:
            activityCell.typeLabel.text = @"Motion" ;
            break;
        case 2:
            activityCell.typeLabel.text = @"Alarm" ;
            break;
        case 3:
            activityCell.typeLabel.text = @"Sound" ;
            break;
        case 4:
            activityCell.typeLabel.text = @"PIR" ;
            break;
        case 5:
            activityCell.typeLabel.text = @"Temp" ;
            break;
        default:
            activityCell.typeLabel.text = @"Unknown" ;
            break;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    
    //[dateFormatter setDateFormat:@"yy-MM-dd a hh:mm:ss"];
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    
    NSDate *stDate = [object valueForKey:@"timeStamp"];
    
    NSString *dateString = [dateFormatter stringFromDate:stDate];

    activityCell.dateLabel.text = dateString;
    
}


@end
