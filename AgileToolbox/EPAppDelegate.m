//
//  EPAppDelegate.m
//  AgileToolbox
//
//  Created by AtrBea on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EPAppDelegate.h"
#import "EPConnection.h"
#import "EPJSONPostURLRequest.h"
#import "EPQuestionsTableViewController.h"
#import "EPAddQuestionTableViewController.h"

#import "EPQuestionsTableViewControllerDependencyBootstrapper.h"

@interface EPAppDelegate ()

@property (strong, nonatomic) EPDependencyBox* questionsTableViewControllerDependencyBox;

@end

@implementation EPAppDelegate

// The following three @synthesize statements are for CoreData - lazy loading for readonly properties
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.questionsTableViewControllerDependencyBox = [[[EPQuestionsTableViewControllerDependencyBootstrapper alloc] initWithAppDelegate:self] bootstrap];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
#ifdef TEST
    return NO;
#else
    return YES;
#endif
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
#ifdef TEST
    return NO;
#else
    return YES;
#endif
}

- (void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSLog(@"didDecodeRestorableStateWithCoder");
}

- (UIViewController*)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    if ([[identifierComponents lastObject] isEqualToString:@"MenuItems"]) {
        return self.window.rootViewController;
    }
    if ([[identifierComponents lastObject] isEqualToString:@"EPMainMenuListViewController"]) {
        return [(UINavigationController*)self.window.rootViewController viewControllers][0];
    }
    
    UIStoryboard* board = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
    
    if ([[identifierComponents lastObject] isEqualToString:@"EPQuestionsTableViewController"]) {
        EPQuestionsTableViewController* questionsTableViewController = (EPQuestionsTableViewController*)[board instantiateViewControllerWithIdentifier:[identifierComponents lastObject]];
        
        [questionsTableViewController injectDependenciesFrom:self.questionsTableViewControllerDependencyBox];
        
        return questionsTableViewController;
    } else if ([[identifierComponents lastObject] isEqualToString:@"EPQuestionDetailsTableViewController"]) {
        return [board instantiateViewControllerWithIdentifier:[identifierComponents lastObject]];
    } else if ([[identifierComponents lastObject] isEqualToString:@"AddQuestionTableViewController"]) {
        EPAddQuestionTableViewController* addQuestionViewController = (EPAddQuestionTableViewController*)[board instantiateViewControllerWithIdentifier:[identifierComponents lastObject]];
        
        addQuestionViewController.statePreservationAssistant = self.questionsTableViewControllerDependencyBox[@"StatePreservationAssistant"];
        addQuestionViewController.questionsDataSource = self.questionsTableViewControllerDependencyBox[@"DataSource"];
        addQuestionViewController.postman = self.questionsTableViewControllerDependencyBox[@"Postman"];
        
        return addQuestionViewController;
    }

    return nil;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//    NSLog(@"applicationWillResignActive");
//    if (![NSThread isMainThread]) {
//        NSLog(@"WE ARE NOT IN THE MAIN THREAD!!!!!!!!!!!!!");
//    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // TODO
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AgileToolbox" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
#ifdef TEST
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:&error]) {
#else
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AgileToolbox.sqlite"];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
#endif
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - This method is only used for the purpose of testing - should be removed from production code

-(void)clearPersistentStore
{
    _persistentStoreCoordinator = nil;
    _managedObjectContext = nil;
}

@end
