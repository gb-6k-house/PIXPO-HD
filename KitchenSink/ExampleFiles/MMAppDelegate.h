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


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MHWMigrationManager.h"

@class ICETutorialController;
@class LoginController;
//@class ubiaRestClient;
@class ubiaDeviceManager;
@class MMNavigationController;
@class HTTPServer;

@interface MMAppDelegate : UIResponder <UIApplicationDelegate,NSFetchedResultsControllerDelegate,MHWMigrationManagerDelegate>
{
    HTTPServer *httpServer;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ICETutorialController *iceTutorialController;


/***+++++++++++++++++++++++***/
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong,nonatomic) ubiaDeviceManager *deviceManager;

//@property (strong,nonatomic) ubiaRestClient *restClient;
@property (strong,nonatomic) MMNavigationController *publicNavView;
@property (strong, nonatomic) NSString  *storyboardName;
@property (strong, nonatomic) NSString  *logoFile;
@property (assign, nonatomic) BOOL rotationEnabled;
@property (assign, nonatomic) int notificationType;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


/***======================***/


@end
