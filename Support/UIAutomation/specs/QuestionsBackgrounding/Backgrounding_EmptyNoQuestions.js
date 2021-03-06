#import "../../jasmine-uiautomation.js"
#import "../../jasmine/lib/jasmine-core/jasmine.js"
#import "../../jasmine-uiautomation-reporter.js"
#import "../../helpers/general_helpers.js"


describe("Questions Backgrounding", function() {

    var helpers = new EPHelpers();

    afterEach(function() {
        helpers.goBack();
    });

    it("performs background fetch operation when serves returns an empty set", function() {

        helpers.enterQuestions(1);

        helpers.enterBackgroundForDuration(4);

        // one cell with "No questions on the server" should be visible
        helpers.checkThereIsACorrectNumberOfRowsInTheTableView(1);

        expect(helpers.getCellTextForTableViewAtIndex("Questions",0)).toContain("No questions on the server");
    });

    it("displays the same set of questions when re-entering questions section", function() {

        helpers.enterQuestions();

        helpers.checkThereIsACorrectNumberOfRowsInTheTableView(1);

        expect(helpers.getCellTextForTableViewAtIndex("Questions",0)).toContain("No questions on the server");
    });
});

jasmine.getEnv().addReporter(new jasmine.UIAutomation.Reporter());
jasmine.getEnv().execute();

