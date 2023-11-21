//
//  CXBottomSheetDelegate.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/16/23.
//

import Foundation

/// this represents the display and behavior of the bottom sheet
public protocol CXBottomSheetDelegate: AnyObject, CXBottomSheetInteractableProtocol {
    
    /// Ask the delegate to return the available height that the bottom sheet can interact with
    /// - Parameter bottomSheet: bottom sheet that asks for height
    /// - Returns: available height that bottom sheet can interact with
    func bottomSheet(availableHeightFor bottomSheet: CXBottomSheetProtocol) -> CGFloat
}

// MARK: - Optional methods

public extension CXBottomSheetDelegate {
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {}
}
