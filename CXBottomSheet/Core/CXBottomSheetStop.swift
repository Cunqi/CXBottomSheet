//
//  CXBottomSheetStop.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/16/23.
//

import Foundation

/// Describe the stop infromation that a bottom sheet stop should contains
/// it helps the bottom sheet to decide where to stop and the final height
/// when stop changed
public class CXBottomSheetStop {
    
    // MARK: - Public properties
    
    /// the expected bottom sheet type info
    public let type: CXBottomSheetStopType
    
    /// Indicate if current stop is an upper bound, if it is an upper bound, all stops which has larger hight
    /// will be filtered out from the `stops` list
    public let isUpperBound: Bool
    
    /// The real bottom sheet height value based on run-time available height
    public let height: CGFloat
    
    // MARK: - Initializers
    
    private init(type: CXBottomSheetStopType, isUpperBound: Bool, height: CGFloat = 0) {
        self.type = type
        self.isUpperBound = isUpperBound
        self.height = height
    }
    
    // MARK: Public methods
    
    public func measured(with height: CGFloat) -> CXBottomSheetStop {
        CXBottomSheetStop(
            type: type,
            isUpperBound: isUpperBound,
            height: type.makeHeight(with: height))
    }
    
    // MARK: - Public convenient initializers
    
    public static func fixed(_ value: CGFloat, isUpperBound: Bool = false) -> CXBottomSheetStop {
        CXBottomSheetStop(type: .fixed(value: value),
                          isUpperBound: isUpperBound)
    }
    
    public static func percentage(_ value: CGFloat, isUpperBound: Bool = false) -> CXBottomSheetStop {
        CXBottomSheetStop(type: .percentage(value: max(0, min(value, 1.0))),
                          isUpperBound: isUpperBound)
    }
}

// MARK: - Comparable

extension CXBottomSheetStop: Comparable {
    public static func == (lhs: CXBottomSheetStop, rhs: CXBottomSheetStop) -> Bool {
        lhs.isUpperBound == rhs.isUpperBound && lhs.type == rhs.type
    }
    
    public static func < (lhs: CXBottomSheetStop, rhs: CXBottomSheetStop) -> Bool {
        lhs.height < rhs.height
    }
}

// MARK: - Public convenience properties

extension CXBottomSheetStop {
    public static let closed = CXBottomSheetStop.fixed(0)
    
    public static let half = CXBottomSheetStop.percentage(0.5)
    
    public static let full = CXBottomSheetStop.percentage(1.0, isUpperBound: true)
}

// MARK: - NSCopying

extension CXBottomSheetStop: NSCopying {
    
    public func copy(with zone: NSZone? = nil) -> Any {
        return CXBottomSheetStop(type: type, isUpperBound: isUpperBound, height: height)
    }
    
}
