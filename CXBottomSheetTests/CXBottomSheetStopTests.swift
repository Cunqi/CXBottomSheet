//
//  CXBottomSheetStopTests.swift
//  CXBottomSheetTests
//
//  Created by Cunqi Xiao on 11/25/23.
//

import XCTest
@testable import CXBottomSheet

final class CXBottomSheetStopTests: XCTestCase {
    
    // MARK: - Private properties
    
    private let availableHeight: CGFloat = 1000
    
    func testMakeFixedHeightLessThanAvailableHeight() {
        let stop = CXBottomSheetStop.fixed(200)
        XCTAssertEqual(stop.makeHeight(with: availableHeight), 200)
    }
    
    func testMakeFixedHeightGreaterThanAvailableHeight() {
        let stop = CXBottomSheetStop.fixed(10000)
        XCTAssertEqual(stop.makeHeight(with: availableHeight), availableHeight)
    }
    
    func testMakeFlexHeightLessThanAvailableHeight() {
        let stop = CXBottomSheetStop.percentage(0.5)
        XCTAssertEqual(stop.makeHeight(with: availableHeight), 500)
    }
    
    func testMakeFlexHeightGreaterThanAvailableHeight() {
        let stop = CXBottomSheetStop.percentage(2)
        XCTAssertEqual(stop.value, 1.0)
        XCTAssertEqual(stop.makeHeight(with: availableHeight), availableHeight)
    }
    
    func testStopComparision() {
        let lhs = CXBottomSheetStop.fixed(600)
        let rhs = CXBottomSheetStop.percentage(0.6)
        XCTAssertNotEqual(lhs, rhs)
        XCTAssertEqual(CXBottomSheetStop.compare(lhs: lhs, rhs: rhs, with: availableHeight), .orderedSame)
    }
    
    func testFindMinStop() {
        let lhs = CXBottomSheetStop.fixed(600)
        let rhs = CXBottomSheetStop.percentage(0.7)
        XCTAssertEqual(CXBottomSheetStop.minStop(lhs: lhs, rhs: rhs, height: availableHeight), lhs)
        XCTAssertEqual(CXBottomSheetStop.minStop(lhs: lhs, rhs: rhs, height: availableHeight / 2.0), rhs)
    }
}
