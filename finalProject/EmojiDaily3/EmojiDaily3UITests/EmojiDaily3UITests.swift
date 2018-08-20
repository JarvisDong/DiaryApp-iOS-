//
//  EmojiDaily3UITests.swift
//  EmojiDaily3UITests
//
//  Created by Haojun Dong on 8/14/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//

import XCTest

class EmojiDaily3UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let app = XCUIApplication()
        
        // Create chapter
        app.navigationBars["My Chapters"].buttons["Add"].tap()
        app.typeText("hi")
        app.buttons["Done"].tap()

        
        // Check chapter
        XCTAssertEqual(app.tables.cells.element(boundBy: 0).staticTexts.element(boundBy: 0).label, "hi")
   
        
        // Go into the chapter
        app.tables.children(matching: .cell).element(boundBy: 0).staticTexts["hi"].tap()

        
        // Create new journal
        app.navigationBars["hi"].buttons["Compose"].tap()
        
        app.typeText("My Journal")
        app.otherElements.containing(.navigationBar, identifier:"EmojiDaily3.JournalDetailView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element.tap()
        app.typeText("😃")
        
        
        // Add a tag
        app.toolbars["Toolbar"].buttons[""].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 2).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        
        app.typeText("tag")
        app.typeText("\n") // -- return
        app.navigationBars["Tags"].buttons["Done"].tap()

        app.navigationBars["EmojiDaily3.JournalDetailView"].buttons["Done"].tap()
        
        // Check journal
        XCTAssertEqual(app.tables.cells.element(boundBy: 0).staticTexts.element(boundBy: 0).label, "My Journal")
        
        // Search for journal
        app.otherElements.containing(.navigationBar, identifier:"hi").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element.tap()
        
        app.typeText("my")
        
        // Check journal again
        XCTAssertEqual(app.tables.cells.element(boundBy: 0).staticTexts.element(boundBy: 0).label, "My Journal")
        
        // Clear search bar
        app.searchFields.buttons["Clear text"].tap()
        
        // Delete journal
        app.tables.cells.staticTexts["My Journal"].tap()
        
        let emojidaily3JournaldetailviewNavigationBar = app.navigationBars["EmojiDaily3.JournalDetailView"]
        emojidaily3JournaldetailviewNavigationBar.buttons["Edit"].tap()
        emojidaily3JournaldetailviewNavigationBar.buttons["Delete"].tap()
        
        // Go back
        app.navigationBars["hi"].buttons["My Chapters"].tap()
        
        // Rename the chapter
        app.tables.cells.element(boundBy: 0).swipeLeft()
        app.tables.buttons["Rename"].tap()
        app.typeText("new name")
        app.buttons["Done"].tap()
        
        // Check chapter again
        XCTAssertEqual(app.tables.cells.element(boundBy: 0).staticTexts.element(boundBy: 0).label, "new name")
        
        // Delete the chapter that we created
        let myChaptersNavigationBar = app.navigationBars["My Chapters"]
        myChaptersNavigationBar.buttons["Edit"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 0).buttons["Delete new name, 0"].tap()
        tablesQuery.buttons["Delete"].tap()
        myChaptersNavigationBar.buttons["Done"].tap()

        
    }
    
}
