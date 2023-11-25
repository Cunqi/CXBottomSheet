//
//  CXBottomSheetSizeObserverProtocol.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/24/23.
//

import UIKit

/// This protocol allows the host to use a non-guaranteed way to observe view's size change
/// to get an instant update once the view size changed
/// From: [Solution](https://stackoverflow.com/a/27590915)
public protocol CXBottomSheetSizeObserverProtocol: AnyObject {
    
    /// Start observing view size change to make sure the bottom sheet can
    /// response to any size change, once the observed view's size changed, the
    /// bottom sheet can invalidate current stop, and resize itself with the latest
    /// size
    /// - Parameter view: The view that bottom sheet height calculation relies on
    func startObservingSizeChange(on view: UIView)
    
    /// Stop observing view size change and invalidate current observer
    func stopObservingSizeChange()
}
