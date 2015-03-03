//
//  ubiaLocalDeviceConfig.m
//  P4PCamLive
//
//  Created by Maxwell on 14-9-5.
//  Copyright (c) 2014年 UBIA. All rights reserved.
//

#import "ubiaLocalDeviceConfig.h"
#import "ubiaDevice.h"
#import "ubiaDeviceList.h"

#import "MMAppDelegate.h"
#import "ubiaDeviceManager.h"
#import "ubiaRestClient.h"

@implementation ubiaLocalDeviceConfig

-(id)init
{
    self=[super init];
    return self;
}

- (void)loadLocalDeviceConfig : (ubiaRestClient *) restClient
{
    NSLog(@"loadLocalDeviceConfig===>");
    if (self.fetchedResultsController == nil) {
        return;
    }
    
    NSArray  *fetchedObjects = [[self fetchedResultsController] fetchedObjects];
    if ([fetchedObjects count] > 0) {

        //NSManagedObject *object = fetchedObjects[0];
       
        for (int i=0; i<[fetchedObjects count]; i++) {
            
            ubiaDevice *tmpDevice = [[ubiaDevice alloc] init];
            NSManagedObject *object = fetchedObjects[i];
            
            tmpDevice.uid = [object valueForKey:@"devUID"];
            
            tmpDevice.name = [object valueForKey:@"devName"];
            tmpDevice.location = [object valueForKey:@"devLocation"];
            //tmpDevice.isOwner = [[[uidlist objectAtIndex:i] valueForKey:@"private"] boolValue];

            tmpDevice.loginID = [object valueForKey:@"devLoginID"];
            tmpDevice.password = [object valueForKey:@"devPwd"];
            
            tmpDevice.client.loginID = [object valueForKey:@"devLoginID"];
            tmpDevice.client.password = [object valueForKey:@"devPwd"];
         
            tmpDevice.deviceManager = restClient.deviceManager;
            
            [restClient.myDeviceList addDevice:tmpDevice];
        }
        
    }
    NSLog(@"loadLocalDeviceConfig<===");
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
    
   // NSNumber * nssilentMode = [[NSNumber alloc] initWithInt:silentMode];
    //[object setValue:nssilentMode forKey:@"silentMode"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[NSString stringWithFormat:@"MyDeviceList is corrupt."]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (void)addNewDevice:(ubiaDevice *)device
{
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    //[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    [newManagedObject setValue:device.uid forKey:@"devUID"];
    [newManagedObject setValue:device.client.password forKey:@"devPwd"];
    [newManagedObject setValue:device.name forKey:@"devName"];
    [newManagedObject setValue:device.client.loginID forKey:@"devLoginID"];
    
    [newManagedObject setValue:device.location forKey:@"devLocation"];
    
    NSNumber *isOwner = [[NSNumber alloc] initWithBool:device.isOwner];
    [newManagedObject setValue:isOwner forKey:@"isOwner"];
    
    NSNumber *isPublic = [[NSNumber alloc] initWithBool:device.isPublic];
    [newManagedObject setValue:isPublic forKey:@"isPublic"];
    
    NSNumber *isShare = [[NSNumber alloc] initWithBool:device.isShare];
    [newManagedObject setValue: isShare forKey:@"isShare"];
    
    [newManagedObject setValue: device.lastActiveTime forKey:@"lastActiveTime"];
    NSNumber *timeZone = [[NSNumber alloc] initWithInt:device.timeZone];
    [newManagedObject setValue: timeZone forKey:@"timeZone"];
    
    
    //EBWTUKNR1PSBTNDUU65J
    //FRW9SYR7DCSLSMXUYPCJ
    //F7C9AHNY8WU7VM6PSFXT
    //FFMTVKPZ8P83SNDUYPYJ
    //CFGTUKNFJ68BTNXUU6D1
    
    
    //[newManagedObject setValue:@"EBWTUKNR1PSBTNDUU65J" forKey:@"devUID"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

-(void) deleteDevice: (ubiaDevice *) device{

    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    //NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSArray  *fetchedObjects = [[self fetchedResultsController] fetchedObjects];
    
    for (int i=0; i<[fetchedObjects count]; i++) {
        
        NSManagedObject *object = fetchedObjects[i];
        if ([[object valueForKey:@"devUID"] isEqualToString:device.uid]) {
            [context deleteObject:object];
            break;
        }

    }
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)updateDevice:(ubiaDevice *)device
{
    
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];

    NSArray  *fetchedObjects = [[self fetchedResultsController] fetchedObjects];
    
    for (int i=0; i<[fetchedObjects count]; i++) {
        
        NSManagedObject *object = fetchedObjects[i];
        if ([[object valueForKey:@"devUID"] isEqualToString:device.uid]) {
            
            [object setValue:device.uid forKey:@"devUID"];
            [object setValue:device.password forKey:@"devPwd"];
            [object setValue:device.name forKey:@"devName"];
            [object setValue:device.client.loginID forKey:@"devLoginID"];
            
            [object setValue:device.location forKey:@"devLocation"];
            
            NSNumber *isOwner = [[NSNumber alloc] initWithBool:device.isOwner];
            [object setValue:isOwner forKey:@"isOwner"];
            
            NSNumber *isPublic = [[NSNumber alloc] initWithBool:device.isPublic];
            [object setValue:isPublic forKey:@"isPublic"];
            
            NSNumber *isShare = [[NSNumber alloc] initWithBool:device.isShare];
            [object setValue: isShare forKey:@"isShare"];
            
            [object setValue: device.lastActiveTime forKey:@"lastActiveTime"];
            NSNumber *timeZone = [[NSNumber alloc] initWithInt:device.timeZone];
            [object setValue: timeZone forKey:@"timeZone"];
            break;
        }
        
    };
    
    
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

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext * managedObjectContext = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyDeviceList" inManagedObjectContext:managedObjectContext];
    
    if(entity == nil) return nil;
    
    [fetchRequest setEntity:entity];
    
    //Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:10];
    
    //Edit the sort key as appropriate.
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"devUID" ascending:NO];
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


@end
