//
//  Assignment6UITests.swift
//  Assignment6UITests
//


import XCTest


class Assignment6UITests: XCTestCase {
    override func setUp() {
        super.setUp()

		continueAfterFailure = false

		XCUIApplication().launch()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        
        XCTAssertEqual(app.tables.count, 1)
        
        XCTAssertGreaterThan(app.cells.count, 0, "category list contains more than zero cell")
        
        app.tables.cells.staticTexts["Contains 5 images"].tap()
        
        let navBar = app.navigationBars["Cat Images"]
        let existsPredicate = NSPredicate(format: "exists == TRUE")
        expectation(for: existsPredicate, evaluatedWith: navBar,
                    handler: nil)
        waitForExpectations(timeout: 5.0, handler: nil)
        
        let cells = app.collectionViews.cells.count
        XCTAssertGreaterThan(cells, 0, "Cat images scene contains mroe than zero cell")
        
        navBar.buttons["Categories"].tap()
    }
}
