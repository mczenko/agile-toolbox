//
//  EPAppDelegate.h
//  AgileToolbox
//
//  Created by AtrBea on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPQuestionsDataSource.h"
#import "EPQuestionPostman.h"

@interface EPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// The following three properties are for CoreData
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic, readonly) EPQuestionsDataSource* questionsDataSource;
@property (strong, nonatomic, readonly) EPQuestionPostman* postman;

// The following two methods are for CoreData
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
