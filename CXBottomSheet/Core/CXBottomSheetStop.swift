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
    
    /// Represent if stop is upper-bound stop, if yes, means any stop which
    /// has larger hight will be ignored, this flag is useful when you update
    /// bottom sheet heigh in rael time, ideally, there should always be only
    /// one upper bound, therefor, it is consumer's responsibility to make sure
    /// the singleton of upper bound
    public let isUpperBound: Bool
    
    public let type: CXBottomSheetStopType
    
    public let value: CGFloat
    
    // MARK: - Initializer
    
    public static func fixed(_ value: CGFloat, isUpperBound: Bool = false) -> CXBottomSheetStop {
        return CXBottomSheetStop(type: .fixed, value: value, isUpperBound: isUpperBound)
    }
    
    public static func percentage(_ value: CGFloat, isUpperBound: Bool = false) -> CXBottomSheetStop {
        return CXBottomSheetStop(type: .percentage, value: max(0, min(value, 1)), isUpperBound: isUpperBound)
    }
    
    private init(type: CXBottomSheetStopType, value: CGFloat, isUpperBound: Bool) {
        self.type = type
        self.value = value
        self.isUpperBound = isUpperBound
    }
    
    // MARK: - Public methods
    
    public static func compare(lhs: CXBottomSheetStop, rhs: CXBottomSheetStop, with height: CGFloat) -> ComparisonResult {
        if lhs.isUpperBound != rhs.isUpperBound {
            return lhs.isUpperBound ? .orderedDescending : .orderedAscending
        } else {
            return compareHeight(lhs: lhs.makeHeight(with: height), rhs: rhs.makeHeight(with: height))
        }
    }
    
    public static func minStop(lhs: CXBottomSheetStop, rhs: CXBottomSheetStop, height: CGFloat) -> CXBottomSheetStop {
        return compareHeight(lhs: lhs.makeHeight(with: height), rhs: rhs.makeHeight(with: height)) == .orderedAscending ? lhs : rhs
    }
    
    public func makeHeight(with availableHeight: CGFloat) -> CGFloat {
        switch type {
        case .fixed:
            return min(value, availableHeight)
        case .percentage:
            return value * availableHeight
        }
    }
    
    // MARK: - Private methods
    
    private static func compareHeight(lhs: CGFloat, rhs: CGFloat) -> ComparisonResult {
        if lhs == rhs {
            return .orderedSame
        }
        return lhs < rhs ? .orderedAscending : .orderedDescending
    }
}

extension CXBottomSheetStop: Equatable {
    public static func == (lhs: CXBottomSheetStop, rhs: CXBottomSheetStop) -> Bool {
        return lhs.type == rhs.type 
        && lhs.value == rhs.value 
        && lhs.isUpperBound == rhs.isUpperBound
    }
}

public extension CXBottomSheetStop {

    // MARK: - Constants

    static let closed: CXBottomSheetStop = .fixed(0)
    
    static let expanded: CXBottomSheetStop = .percentage(0.8, isUpperBound: true)
}
