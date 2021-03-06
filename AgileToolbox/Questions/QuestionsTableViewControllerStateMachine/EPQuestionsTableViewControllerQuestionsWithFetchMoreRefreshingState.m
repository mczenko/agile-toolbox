//
//  EPQuestionsTableViewControllerQuestionsWithFetchMoreRefreshingState.m
//  AgileToolbox
//
//  Created by Marcin Czenko on 11/02/14.
//
//

#import "EPQuestionsTableViewControllerQuestionsWithFetchMoreRefreshingState.h"
#import "EPQuestionsTableViewControllerQuestionsWithFetchMoreState.h"

@implementation EPQuestionsTableViewControllerQuestionsWithFetchMoreRefreshingState


- (UITableViewCell*)cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0==indexPath.section) {
        return [EPQuestionTableViewCell cellDequeuedFromTableView:self.tableViewExpert.tableView
                                                     forIndexPath:indexPath
                                                      andQuestion:[self.viewController.fetchedResultsController objectAtIndexPath:indexPath]];
        
        
    } else {
        EPFetchMoreTableViewCell* cell = [EPFetchMoreTableViewCell cellDequeuedFromTableView:self.tableViewExpert.tableView
                                                                                forIndexPath:indexPath
                                                                                     loading:YES];
        
        if (![UIApplication sharedApplication].networkActivityIndicatorVisible) {
            // We are notifying the user using dispatch_after - in connection failure.
            // Otherwise we wouldn't be in this state anymore.
            [cell setCellText:EPFetchMoreTableViewCellTextConnectionFailure];
        }
        return cell;
    }
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (0==section) {
        return self.viewController.numberOfQuestionsInPersistentStorage ;
    } else {
        return 1 ;
    }
}

- (NSInteger)numberOfSections
{
    return 2;
}

- (void)handleEvent
{
    [self.stateMachine changeCurrentStateTo:[EPQuestionsTableViewControllerQuestionsWithFetchMoreState class]];
    [self.viewController.questionsRefreshControl endRefreshing];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)controllerDidChangeContent
{
    [super controllerDidChangeContent];
    [self.tableViewExpert.fetchMoreCell setLoadingStatus:NO];
}

- (void)fetchReturnedNoData
{
    [super fetchReturnedNoData];
    [self.tableViewExpert.fetchMoreCell setLoadingStatus:NO];
}

- (void)handleConnectionFailureUsingNativeRefreshControlCompletionHandler
{
    if (self.connectionFailurePending) {
        // It may have happened that on waiting for connection failure completion event
        // we left the screen which means viewWillDisappear happened where we
        // reset all failure indicators and move to appropriate state.
        // In such a case, we should execte the methods below.
        // See also viewWillDisappear.
        
        [self.stateMachine changeCurrentStateTo:[EPQuestionsTableViewControllerQuestionsWithFetchMoreState class]];
        [self.viewController.questionsRefreshControl endRefreshing];
        
        if (self.viewController.viewIsVisible) {
            // the view might have dissapear in the meantime
            [self.tableViewExpert.fetchMoreCell setCellText:EPFetchMoreTableViewCellTextDefault];
        }
    }    
}

- (void)connectionFailure
{
    [self.tableViewExpert.fetchMoreCell setCellText:EPFetchMoreTableViewCellTextConnectionFailure];
    [super connectionFailure];
}

@end
