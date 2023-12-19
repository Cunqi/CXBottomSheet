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
        let height: CGFloat = 300
        let stop = CXBottomSheetStop.fixed(200).measured(with: height)
        XCTAssertLessThan(stop.height, height)
    }
    
    func testMakeFixedHeightGreaterThanAvailableHeight() {
        let height: CGFloat = 1000
        let stop = CXBottomSheetStop.fixed(height).measured(with: height)
        XCTAssertEqual(stop.height, height)
    }
    
    func testMakeFlexHeightLessThanAvailableHeight() {
        let height: CGFloat = 500
        let stop = CXBottomSheetStop.percentage(0.5).measured(with: height)
        XCTAssertEqual(stop.height, height * 0.5)
    }
    
    func testMakeFlexHeightGreaterThanAvailableHeight() {
        let height: CGFloat = 500
        let stop = CXBottomSheetStop.percentage(2).measured(with: height)
        XCTAssertEqual(stop.height, height)
    }
}
