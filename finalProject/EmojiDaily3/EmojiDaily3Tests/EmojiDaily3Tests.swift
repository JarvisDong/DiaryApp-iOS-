//
//  EmojiDaily3Tests.swift
//  EmojiDaily3Tests
//
//  Created by Haojun Dong on 8/14/18.
//  Copyright © 2018 Jarvis Dong. All rights reserved.
//

import XCTest
@testable import EmojiDaily3

class EmojiDaily3Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let chapter = JournalServices.shared.newChapter(title: "test chapter")
        JournalServices.shared.newJournal(chapter: chapter, title: "test journal", content: "test content")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testChapterAdd() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let chapters = JournalServices.shared.chapters()
        
        let originalCount = chapters.fetchedObjects?.count ?? 0
        JournalServices.shared.newChapter(title: "hi")
        try! chapters.performFetch()
        let newCount = chapters.fetchedObjects?.count ?? 0
        
        
        XCTAssertGreaterThan(newCount, originalCount)
    }
    
    func testJournalAdd() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let chapter = (JournalServices.shared.chapters().fetchedObjects?.first(where: { (chapter) in return chapter.title == "test chapter"}))!
        
        let journals = JournalServices.shared.journals(chapter: chapter)
        
        let originalCount = journals.fetchedObjects?.count ?? 0
        JournalServices.shared.newJournal(chapter: chapter, title: "title", content: "content")
        try! journals.performFetch()
        let newCount = journals.fetchedObjects?.count ?? 0
        
        
        XCTAssertGreaterThan(newCount, originalCount)
    }
    
    func testTagDependency() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let tags = JournalServices.shared.tags()
        let testChapter = (JournalServices.shared.chapters().fetchedObjects?.first(where: { (chapter) in return chapter.title == "test chapter"}))!
        let testJournal = (JournalServices.shared.journals(chapter: testChapter).fetchedObjects?.first(where: { (journal) in return journal.title == "test journal"}))!
        
        let originalCount = tags.fetchedObjects?.count ?? 0
        let newTag = JournalServices.shared.newTag(name: "||thetagwithaweirdname||")
        newTag.addToJournal(testJournal)
        // delete chapter -> delete journal -> delete tag if it is no longer used
        JournalServices.shared.deleteChapter(chapter: testChapter)
        try! tags.performFetch()
        let newCount = tags.fetchedObjects?.count ?? 0
        
        
        XCTAssertEqual(originalCount, newCount)
    }
}
