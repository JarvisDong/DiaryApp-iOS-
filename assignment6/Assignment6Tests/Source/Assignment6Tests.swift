//
//  Assignment6Tests.swift
//  Assignment6Tests
//

import UIKit
import XCTest
@testable import Assignment6

class Assignment6Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        self.measure {
            //measures the time
        }
    }
    
    func testCategories() {
        
        let numberOfSection = CatService.shared.catCategories().sections?.count
        if let instanceSection = numberOfSection {
            XCTAssertGreaterThan(instanceSection, 0, "NSFetchedResultsController instance contains more than 0 sections (catCategories)")
        }
        else {
             XCTFail("NSFetchedResultsController instance do not contains more than 0 sections (catCategories)")
        }
        
        let section = CatService.shared.catCategories().sections
        if let sections = section {
            for section in sections {
                let item = section.numberOfObjects
                XCTAssertGreaterThan(item, 0, "each sction of NSFetchedResultsController contains more than 0 items (catCategories)")
            }
        }
        else {
            XCTFail("each sction of NSFetchedResultsController does not contains more than 0 items (catCategories)")
        }
    }
    
    func testImages() {
        
        let catSection = CatService.shared.catCategories().fetchedObjects
        if let cat = catSection {
            for each in cat {
                let section = CatService.shared.images(for: each).fetchedObjects?.count
                if let sec = section {
                    XCTAssertGreaterThan(sec, 0, "NSFetchedResultsController instance contains more than 0 item for (images)")
                }
                else {
                    XCTFail("NSFetchedResultsController instance does not contain more than 0 item for (images)")
                }
            }
        }
    }
}
