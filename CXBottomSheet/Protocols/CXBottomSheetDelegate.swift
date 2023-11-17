//
//  CXBottomSheetDelegate.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/16/23.
//

import Foundation

/// this represents the display and behavior of the bottom sheet
public protocol CXBottomSheetDelegate: AnyObject {
    
    /// Ask the delegate to return the available height that the bottom sheet can interact with
    /// - Parameter bottomSheet: bottom sheet that asks for height
    /// - Returns: available height that bottom sheet can interact with
    func bottomSheet(availableHeightFor bottomSheet: CXBottomSheetProtocol) -> CGFloat
    
    /// Ask delegate to handle bottom sheet stop change
    /// - Parameters:
    ///   - bottomSheet: bottom sheet which sends out the stop change
    ///   - fromStop: the previous bottom sheet stop
    ///   - toStop: the current bottom sheet stop
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop)
}

// MARK: - Optional methods

extension CXBottomSheetDelegate {
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {}
    
    /// Ask delegate to handle any UI updates along with bottom sheet animation
    /// - Parameters:
    ///   - bottomSheet: bottom sheet which is animating
    ///   - fromStop: the previous bottom sheet stop
    ///   - toStop: the current bottom sheet stop
    func bottomSheet(animateAlongWith bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {}
}
