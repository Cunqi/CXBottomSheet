//
//  CXBottomSheetStop.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/16/23.
//

import Foundation

/// Provides two type of bottom sheet stop
public enum CXBottomSheetStopType: Int {
    
    /// Define the stop position with percentage calculation, (e.g. 0.9 * availableHeight)
    case percentage = 0

    /// Define the stop position with a given absolute value (e.g 200)
    case fixed
}


/// Use to define the stop position for bottom sheet interaction
public class CXBottomSheetStop {
    
    // MARK: - Properties
    
    public let type: CXBottomSheetStopType
    
    public let value: CGFloat
    
    // MARK: - Initializer
    
    public static func fixed(_ value: CGFloat) -> CXBottomSheetStop {
        return CXBottomSheetStop(type: .fixed, value: value)
    }
    
    public static func percentage(_ value: CGFloat) -> CXBottomSheetStop {
        return CXBottomSheetStop(type: .percentage, value: value)
    }
    
    private init(type: CXBottomSheetStopType, value: CGFloat) {
        self.type = type
        self.value = value
    }
    
    // MARK: - Public methods
    
    public func makeHeight(with availableHeight: CGFloat) -> CGFloat {
        switch type {
        case .fixed:
            return min(value, availableHeight)
        case .percentage:
            return value * availableHeight
        }
    }
}

extension CXBottomSheetStop: Equatable {
    public static func == (lhs: CXBottomSheetStop, rhs: CXBottomSheetStop) -> Bool {
        return lhs.type == rhs.type && lhs.value == rhs.value
    }
}

public extension CXBottomSheetStop {

    // MARK: - Constants

    static let closed: CXBottomSheetStop = .fixed(0)
    
    static let fullyExpanded: CXBottomSheetStop = .percentage(0.9)
}
