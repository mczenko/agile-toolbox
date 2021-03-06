#import "../../jasmine-uiautomation.js"
#import "../../jasmine/lib/jasmine-core/jasmine.js"
#import "../../jasmine-uiautomation-reporter.js"
#import "../../helpers/general_helpers.js"


describe("Questions", function() {

    var helpers = new EPHelpers();

    afterEach(function() {
        helpers.goBack();
    });

    it("server returns zero questions after returning full page", function() {

        helpers.enterQuestions(2);
        // we have 40 questions on a page + one cell for "Fetch More".
        helpers.checkThereIsACorrectNumberOfRowsInTheTableView(41);
        helpers.fetchMoreInTableView('Questions');

        // server returns 0 questions which means we should not see "Fetch More" cell anymore
        helpers.checkThereIsACorrectNumberOfRowsInTheTableView(40);
    });
});

jasmine.getEnv().addReporter(new jasmine.UIAutomation.Reporter());
jasmine.getEnv().execute();
