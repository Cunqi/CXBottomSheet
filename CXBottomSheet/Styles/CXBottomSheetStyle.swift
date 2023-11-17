//
//  CXBottomSheetStyle.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/17/23.
//

import UIKit

/// Customize bottom sheet style
public protocol CXBottomSheetStyle {
    
    /// The visibility of grip bar
    var isGripBarHidden: Bool { get }
    
    /// Shadow visibility of bottom sheet
    var isShadowEnabled: Bool { get }
    
    /// Bottom sheet background color
    var backgroundColor: UIColor { get }
    
    /// Corner radius for top two corners (minXMinY, maxXMinY)
    var cornerRadius: CGFloat { get }
    
}

public protocol CXBottomSheetStyleBuilder: CXBottomSheetStyle {
    func build() -> CXBottomSheetStyle
}
