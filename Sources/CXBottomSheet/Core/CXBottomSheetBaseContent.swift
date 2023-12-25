//
//  CXBottomSheetBaseContent.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 12/21/23.
//

import UIKit

open class CXBottomSheetBaseContent: UIViewController, CXBottomSheetContentProtocol {
    
    // MARK: - Public properties
    
    open weak var bottomSheet: CXBottomSheetProtocol?
    
    open var stopContext: CXBottomSheetStopContext? {
        return nil
    }
    
    // MARK: - Private properties
    
    private var previousStopContext: CXBottomSheetStopContext?
    
    // MARK: - Lifecycles
    
    deinit {
        CXLog.info("\(type(of: self)) deinitialized")
    }
    
    // MARK: - Public methods
    
    open func saveStopContext(stopContext: CXBottomSheetStopContext?) {
        previousStopContext = stopContext
    }
    
    open func loadStopContext() -> CXBottomSheetStopContext? {
        previousStopContext
    }
}
