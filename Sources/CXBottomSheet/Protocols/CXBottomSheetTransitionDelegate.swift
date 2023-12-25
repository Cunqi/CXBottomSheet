//
//  CXBottomSheetInteractableProtocol.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/21/23.
//

import Foundation

public protocol CXBottomSheetTransitionDelegate: AnyObject {
    
    /// Ask delegate to handle bottom sheet will move to stop
    /// - Parameters:
    ///   - bottomSheet: bottom sheet which sends out the stop change
    ///   - fromStop: the previous bottom sheet stop
    ///   - toStop: the current bottom sheet stop
    func bottomSheet(willMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop)
    
    /// Ask delegate to handle bottom sheet stop change
    /// - Parameters:
    ///   - bottomSheet: bottom sheet which sends out the stop change
    ///   - fromStop: the previous bottom sheet stop
    ///   - toStop: the current bottom sheet stop
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop)
    
    /// Ask the delegate to handle bottom sheet bounce stop change, the bottom sheet real stop is not changed
    /// but the bounce action can still be useful to trigger some interactions (e.g. dismiss keyboard)
    /// - Parameters:
    ///   - bottomSheet: bottom sheet which sends out the bounce change
    ///   - stop: bottom sheet max stop
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMaxStop stop: CXBottomSheetStop)
    
    /// Ask the delegate to handle bottom sheet bounce stop change, the bottom sheet real stop is not changed
    /// but the bounce action can still be useful to trigger some interactions (e.g. wakeup keyboard)
    /// - Parameters:
    ///   - bottomSheet: bottom sheet which sends out the bounce change
    ///   - stop: bottom sheet max stop
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMinStop stop: CXBottomSheetStop)
}

// MARK: - Optional methods

public extension CXBottomSheetTransitionDelegate {
    func bottomSheet(willMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {}
    
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {}
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMaxStop stop: CXBottomSheetStop) {}
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMinStop stop: CXBottomSheetStop) {}
}
