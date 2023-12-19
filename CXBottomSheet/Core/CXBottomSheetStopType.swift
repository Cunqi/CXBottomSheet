//
//  CXBottomSheetStopType.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 12/19/23.
//

import Foundation

/// Provides two type of bottom sheet stop
public enum CXBottomSheetStopType {
    
    /// Define the stop position with percentage calculation, (e.g. 0.9 * availableHeight)
    case percentage(value: CGFloat)

    /// Define the stop position with a given absolute value (e.g 200)
    case fixed(value: CGFloat)
    
    // MARK: - Public methods
    
    public func makeHeight(with height: CGFloat) -> CGFloat {
        switch self {
        case .percentage(let value):
            return value * height
        case .fixed(let value):
            return min(value, height)
        }
    }
}
