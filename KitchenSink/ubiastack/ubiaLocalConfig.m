//
//  ubiaRestClient.m
//  P4PLive
//
//  Created by Maxwell on 14-3-1.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "ubiaLocalConfig.h"
#import <CommonCrypto/CommonCryptor.h>

#import "ubiaDeviceList.h"

#import "MMAppDelegate.h"
#import "ubiaDeviceManager.h"

@implementation ubiaLocalConfig

@synthesize hasLogin;
@synthesize silentMode,silentBegin,silentDuration;
@synthesize notificationType;
@synthesize cloudstatus;
@synthesize user_loginID,user_password,user_safePassword;
@synthesize savePassword,autoLogin;
@synthesize user_token,user_secret;

-(id)init
{
    self=[super init];
    return self;
}


- (void)loadConfigInfo
{
    NSLog(@"loadConfigInfo===>");
    if (self.fetchedResultsController == nil) {
        return;
    }
  
    NSArray  *fetchedObjects = [[self fetchedResultsController] fetchedObjects];
    if ([fetchedObjects count] == 0) {
        //First time run， init the local config
        hasLogin = NO;
        notificationType = UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeBadge| UIRemoteNotificationTypeSound;
        silentMode = UBIA_LC_SILENT_MODE_OFF;
        silentBegin = 22*3600;
        silentDuration = 10*3600;
        [self persistSaveConfigInfo];
    }else{
        NSManagedObject *object = fetchedObjects[0];
    
        hasLogin = [[[object valueForKey:@"hasLogin"] description] boolValue];
        notificationType = [[[object valueForKey:@"notificationType"] description] intValue];
        silentMode =  [[[object valueForKey:@"silentMode"] description] intValue];
        silentBegin = [[object valueForKey:@"silentBegin"] intValue];
        silentDuration = [[object valueForKey:@"silentDuration"] intValue];
    }
    NSLog(@"loadConfigInfo<===");
}

- (void)persistSaveConfigInfo
{
    
    if (self.fetchedResultsController == nil) {
        return;
    }
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSArray  *fetchedObjects = [[self fetchedResultsController] fetchedObjects];
    
    NSManagedObject *object;
    if ([fetchedObjects count] == 0) {
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        object = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    }else{
        object = fetchedObjects[0];
    }
    //Update user info
    NSNumber * nslogin = [[NSNumber alloc] initWithBool:hasLogin];
    [object setValue:nslogin forKey:@"hasLogin"];
    
    NSNumber * nsnotification = [[NSNumber alloc] initWithInt:notificationType];
    [object setValue:nsnotification forKey:@"notificationType"];

    NSNumber * nssilentMode = [[NSNumber alloc] initWithInt:silentMode];
    [object setValue:nssilentMode forKey:@"silentMode"];
    
    NSNumber * nssilentBegin = [[NSNumber alloc] initWithInt:silentBegin];
    
    [object setValue:nssilentBegin forKey:@"silentBegin"];
     NSNumber * nssilentDuration = [[NSNumber alloc] initWithInt:silentDuration];
    
    [object setValue:nssilentDuration forKey:@"silentDuration"];

    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[NSString stringWithFormat:@"Local Config is corrupt."]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext * managedObjectContext = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalConfig" inManagedObjectContext:managedObjectContext];
    
    if(entity == nil) return nil;
    
    [fetchRequest setEntity:entity];
    
    //Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    //Edit the sort key as appropriate.

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"hasLogin" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext: managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    
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
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            
            break;
            
        case NSFetchedResultsChangeDelete:
            
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            
            break;
            
        case NSFetchedResultsChangeDelete:
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:
            
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    ;
}


- (void)loadAccountInfo
{
    
    NSArray  *fetchedObjects = [[self fetchedAccountsController] fetchedObjects];
    NSManagedObject *object;
    BOOL isDefault;
    
    for(int i=0; i < [fetchedObjects count]; i++){
        object = fetchedObjects[i];
        isDefault = [[[object valueForKey:@"isDefault"] description] boolValue];
        if(isDefault){
            
            user_loginID = [[object valueForKey:@"user_loginID"] description];
            user_password = [[object valueForKey:@"user_password"] description];
            
            autoLogin = [[[object valueForKey:@"autoLogin"] description] boolValue];
            savePassword = [[[object valueForKey:@"savePassword"] description] boolValue];
            //NSString * safePassword = [[object valueForKey:@"user_safePassword"] description];
            
            if(autoLogin){
                //[self onLogin:Nil];
                
            }
            break;
        }
        
        
    }
}

- (void)saveAccountInfo
{
    
    NSManagedObjectContext *context = [self.fetchedAccountsController managedObjectContext];
    
    NSArray  *fetchedObjects = [[self fetchedAccountsController] fetchedObjects];
    NSManagedObject *object;
    NSString *loginID;
    
    //LoginInfo *info = [[LoginInfo alloc] init];
    //[self.root fetchValueUsingBindingsIntoObject:info];
    
    for(int i=0; i < [fetchedObjects count]; i++){
        object = fetchedObjects[i];
        loginID = [[object valueForKey:@"user_loginID"] description];
        
        if([loginID isEqualToString: user_loginID]){
            //Update user info
            
            [object setValue:user_password forKey:@"user_password"];
            //[object setValue:user_safePassword forKey:@"user_safePassword"];
            
            [object setValue:user_token forKey:@"user_token"];
            [object setValue:user_secret forKey:@"user_secret"];
            
            NSNumber* yes = [[NSNumber alloc] initWithBool:TRUE];
            
            [object setValue:yes forKey:@"isDefault"];
            [object setValue:yes forKey:@"hasLogin"];
            
            yes =[[NSNumber alloc] initWithBool:savePassword];
            [object setValue:yes forKey:@"savePassword"];
            
            yes =[[NSNumber alloc] initWithBool:autoLogin];
            
            [object setValue: yes forKey:@"autoLogin"];
            
            NSDate *nowtime = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
            [object setValue:nowtime forKey:@"lastLogin"];
            
            NSError *error;
            [context save:&error];
            return;
        }
    }
    
    NSEntityDescription *entity = [[self.fetchedAccountsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    //[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    
    [newManagedObject setValue:user_loginID forKey:@"user_loginID"];
    [newManagedObject setValue:user_password forKey:@"user_password"];
    [newManagedObject setValue:user_token forKey:@"user_token"];
    [newManagedObject setValue:user_secret forKey:@"user_secret"];
    
    NSNumber* yes = [[NSNumber alloc] initWithBool:TRUE];
    
    [newManagedObject setValue:yes forKey:@"isDefault"];
    [newManagedObject setValue:yes forKey:@"hasLogin"];
    
    yes =[[NSNumber alloc] initWithBool:savePassword];
    [newManagedObject setValue:yes forKey:@"savePassword"];
    
    yes =[[NSNumber alloc] initWithBool:autoLogin];
    
    [object setValue: yes forKey:@"autoLogin"];
    
    NSDate *nowtime = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    [newManagedObject setValue:nowtime forKey:@"lastLogin"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedAccountsController
{
    if (_fetchedAccountsController != nil) {
        return _fetchedAccountsController;
    }
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext * managedObjectContext = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    //Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    //Edit the sort key as appropriate.
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"user_loginID" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext: managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    
    aFetchedResultsController.delegate = self;
    self.fetchedAccountsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedAccountsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedAccountsController;
}


@end
