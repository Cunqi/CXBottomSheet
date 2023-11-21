//
//  CXBottomSheetScrollSensitiveLevel.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/21/23.
//

import Foundation

/// Defines the threshold of how much distance you need to scroll
/// before move to next stop
public typealias CXBottomSheetScrollSensitiveLevel = CGFloat

public extension CXBottomSheetScrollSensitiveLevel {
    
    // MARK: - Predefined levels
    
    static let none = 1.0
    
    static let low = 0.75
    
    static let medium = 0.5
    
    static let high = 0.25
    
    static let ultra = 0.0
}
