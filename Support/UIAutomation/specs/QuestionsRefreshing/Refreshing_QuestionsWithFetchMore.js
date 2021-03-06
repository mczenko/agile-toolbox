#import "../../jasmine-uiautomation.js"
#import "../../jasmine/lib/jasmine-core/jasmine.js"
#import "../../jasmine-uiautomation-reporter.js"
#import "../../helpers/general_helpers.js"


describe("Questions Refreshing", function() {

    var helpers = new EPHelpers();

    var expectedFirstVisibleCellName = 'Content for question 49';
    var expectedLastVisibleCellName = 'Pull up to download more questions.';

    afterEach(function() {
        helpers.goBack();
    });

    it('performs refresh action in QuestionsWithFetchMore state when more data are still available on the server', function() {

        helpers.enterQuestions(8);

        helpers.checkThereIsACorrectNumberOfRowsInTheTableView(41);
        expect(helpers.getFirstVisibleCellTextForTableView('Questions')).toContain(expectedFirstVisibleCellName);

        helpers.scrollToLastCellInTableView('Questions');
        expect(helpers.getLastVisibleCellTextForTableView('Questions')).toContain(expectedLastVisibleCellName);

        helpers.scrollToFirstCellInTableView('Questions');
        expect(helpers.getFirstVisibleCellTextForTableView('Questions')).toContain(expectedFirstVisibleCellName);

        helpers.refreshTableView('Questions',1);

        helpers.checkThereIsACorrectNumberOfRowsInTheTableView(41);
        helpers.scrollToLastCellInTableView('Questions');

        expect(helpers.getLastVisibleCellTextForTableView('Questions')).toBeNull();

        helpers.target().delay(5);
        expect(helpers.getLastVisibleCellTextForTableView('Questions')).toContain(expectedLastVisibleCellName);
    });

    it('enables refresh control after re-entering the view', function() {

        helpers.enterQuestions();

        helpers.checkThereIsACorrectNumberOfRowsInTheTableView(41);

        expect(helpers.getLastVisibleCellTextForTableView('Questions')).toContain(expectedLastVisibleCellName);
        helpers.scrollToFirstCellInTableView('Questions');
        expect(helpers.getFirstVisibleCellTextForTableView('Questions')).toContain(expectedFirstVisibleCellName);

        helpers.refreshTableView('Questions');

        helpers.goBack();

        helpers.enterQuestions();

        // 40 cells + 1 fetch more - as before, no change here
        helpers.checkThereIsACorrectNumberOfRowsInTheTableView(41);

        expect(helpers.getFirstVisibleCellTextForTableView('Questions')).toContain(expectedFirstVisibleCellName);

        helpers.scrollToLastCellInTableView('Questions');
        expect(helpers.getLastVisibleCellTextForTableView('Questions')).toContain('In progress');

        helpers.target().delay(4);

        // refresh indicator should disappear by now, but we still have 40 cells + 1 fetch more
        helpers.checkThereIsACorrectNumberOfRowsInTheTableView(41);

        expect(helpers.getLastVisibleCellTextForTableView('Questions')).toContain('Progress halted');

        helpers.scrollToFirstCellInTableView('Questions');
        expect(helpers.getFirstVisibleCellTextForTableView('Questions')).toContain(expectedFirstVisibleCellName);
        helpers.scrollToLastCellInTableView('Questions');
        expect(helpers.getLastVisibleCellTextForTableView('Questions')).toContain('Progress halted');

    });
});

jasmine.getEnv().addReporter(new jasmine.UIAutomation.Reporter());
jasmine.getEnv().execute();

