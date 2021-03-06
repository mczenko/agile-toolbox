//
//  EPQuestionsTableViewControllerInitialState.m
//  AgileToolbox
//
//  Created by Marcin Czenko on 23/01/14.
//
//

#import "EPQuestionsTableViewControllerInitialState.h"
#import "EPQuestionsTableViewControllerEmptyLoadingState.h"
#import "EPQuestionsTableViewControllerEmptyNoQuestionsState.h"
#import "EPQuestionsTableViewControllerQuestionsWithFetchMoreState.h"
#import "EPQuestionsTableViewControllerQuestionsNoMoreToFetchState.h"

@implementation EPQuestionsTableViewControllerInitialState

- (void)viewDidLoad
{
    if (!self.viewController.hasQuestionsInPersistentStorage) {
        self.viewController.tableView.estimatedRowHeight = 44.0;
        if ([self.viewController.questionsDataSource hasMoreQuestionsToFetch]) {
            [self.stateMachine changeCurrentStateTo:[EPQuestionsTableViewControllerEmptyLoadingState class]];
            [self.viewController.questionsDataSource fetchOlderThan:nil];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
        else {
            [self.stateMachine changeCurrentStateTo:[EPQuestionsTableViewControllerEmptyNoQuestionsState class]];
        }
    } else {
        self.viewController.tableView.estimatedRowHeight = 105.0;
        [self.viewController.questionsRefreshControl enable];
        if ([self.viewController.questionsDataSource hasMoreQuestionsToFetch]) {
            [self.stateMachine changeCurrentStateTo:[EPQuestionsTableViewControllerQuestionsWithFetchMoreState class]];
        }
        else {
            [self.stateMachine changeCurrentStateTo:[EPQuestionsTableViewControllerQuestionsNoMoreToFetchState class]];
        }
    }
}

@end
