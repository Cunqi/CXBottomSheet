//
//  CXLog.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 12/20/23.
//

import Foundation

class CXLog {
    
    // MARK: - Constants
    
    private static let logPrefix = "[CXBottomSheet] - "
    
    static func info(_ message: String) {
        print(Self.logPrefix + "Info " + message)
    }
    
}
