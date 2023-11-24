//
//  CXBottomSheetContentProtocol.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/16/23.
//

import UIKit


/// Any pages which want to be rendered on bottom sheet should implement this protocol,
/// by implementing this protocol, you are able to interact with the bottom sheet
/// (e.g expand, collpase or hide the bottom sheet)
public protocol CXBottomSheetContentProtocol: UIViewController, CXBottomSheetInteractableProtocol {

    // MARK: - Public properties
    
    /// instance of bottom sheet, use this property to inteact with bottom sheetm
    /// it is `CXBottomSheetProtocol`'s responsibility to setup the reference
    var bottomSheet: CXBottomSheetProtocol? { get set }
    
    var stopContext: CXBottomSheetStopContext? { get }
    
    // MARK: - Public methods
    
    /// Save stop context to current bottom sheet content, it is useful when you need to remeber the previous
    /// bottom sheet stop context after you push a new content to bottom sheet
    /// - Parameter stopContext: The stop context from previous bottom sheet content
    func saveStopContext(stopContext: CXBottomSheetStopContext?)
    
    /// Load stop content for previous bottom sheet content
    /// - Returns: the stop context for previous bottom sheet content
    func loadStopContext() -> CXBottomSheetStopContext?
}

public extension CXBottomSheetContentProtocol {
    var stopContext: CXBottomSheetStopContext? {
        return nil
    }
    
    func saveStopContext(stopContext: CXBottomSheetStopContext?) {}
    
    func loadStopContext() -> CXBottomSheetStopContext? { return nil }
}
