//
//  EPQuestionsTableViewControllerQuestionsWithFetchMoreStateTests.m
//  AgileToolbox
//
//  Created by Marcin Czenko on 21/01/14.
//
//

#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"

#import "EPQuestionsTableViewControllerQuestionsWithFetchMoreState.h"

#import "EPQuestionsDataSource.h"
#import "EPQuestionTableViewCell.h"

@interface EPQuestionsTableViewControllerQuestionsWithFetchMoreStateTests : XCTestCase

@property (nonatomic,strong) id fetchedResultsControllerMock;
@property (nonatomic,strong) id viewControllerMock;

@property (nonatomic,strong) id tableViewExpertMock;
@property (nonatomic,strong) id tableViewMock;

@property (nonatomic,strong) id stateMachineMock;

@property (nonatomic,strong) EPQuestionsTableViewControllerQuestionsWithFetchMoreState* state;

@end

@implementation EPQuestionsTableViewControllerQuestionsWithFetchMoreStateTests

-(void)expectPersistentStorageWithNItems:(NSUInteger)numberOfRows
{
    [[[self.viewControllerMock stub] andReturnValue:OCMOCK_VALUE(numberOfRows)] numberOfQuestionsInPersistentStorage];
}

- (void)setUp
{
    [super setUp];
    
    self.fetchedResultsControllerMock = [OCMockObject niceMockForClass:[NSFetchedResultsController class]];
    
    self.viewControllerMock = [OCMockObject mockForClass:[EPQuestionsTableViewController class]];
    [[[self.viewControllerMock stub] andReturn:self.fetchedResultsControllerMock] fetchedResultsController];
    
    self.tableViewMock = [OCMockObject niceMockForClass:[UITableView class]];
    self.tableViewExpertMock = [OCMockObject niceMockForClass:[EPQuestionsTableViewExpert class]];
    [[[self.tableViewExpertMock stub] andReturn:self.tableViewMock] tableView];
    
    self.stateMachineMock = [OCMockObject niceMockForClass:[EPQuestionsTableViewControllerStateMachine class]];
    
    self.state = [[EPQuestionsTableViewControllerQuestionsWithFetchMoreState alloc] initWithViewController:self.viewControllerMock
                                                                                           tableViewExpert:self.tableViewExpertMock
                                                                                           andStateMachine:self.stateMachineMock];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testThatCellForRowAtIndexPathReturnsQuestionCellForSectionZero
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [[self.stateMachineMock reject] changeCurrentStateTo:[OCMArg any]];
    
    Question *question = [[Question alloc] init];
    [[[self.fetchedResultsControllerMock stub] andReturn:question] objectAtIndexPath:indexPath];
    
    id questionCellClassMock = [OCMockObject niceMockForClass:[EPQuestionTableViewCell class]];
    [[questionCellClassMock expect] cellDequeuedFromTableView:self.tableViewMock forIndexPath:indexPath andQuestion:question];
    
    [self.state cellForRowAtIndexPath:indexPath];
    
    [questionCellClassMock verify];
}

- (void)testThatCellForRowAtIndexPathReturnsFetchMoreCellWithoutLoadingIndicatorForSectionOne
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    
    id fetchMoreCellClassMock = [OCMockObject niceMockForClass:[EPFetchMoreTableViewCell class]];
    [[fetchMoreCellClassMock expect] cellDequeuedFromTableView:self.tableViewMock forIndexPath:indexPath loading:NO];
    
    [self.state cellForRowAtIndexPath:indexPath];
    
    [fetchMoreCellClassMock verify];
}

- (void)testThatNumberOfRowsInSectionNumberOfRowsInFetchedResultsControllerForSectionZero
{
    NSInteger expectedNumberOfRows = 10;
    [self expectPersistentStorageWithNItems:expectedNumberOfRows];
    
    XCTAssertEqual(expectedNumberOfRows, [self.state numberOfRowsInSection:0]);
}


- (void)testThatNumberOfRowsInSectionReturnsOneForSectionOne
{
    XCTAssertEqual((NSInteger)1, [self.state numberOfRowsInSection:1]);
}

- (void)testThanNumberOfSectionsIsTwo
{
    XCTAssertEqual((NSInteger)2, [self.state numberOfSections]);
}

@end