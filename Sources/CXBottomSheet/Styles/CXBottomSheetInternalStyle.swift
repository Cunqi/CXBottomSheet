//
//  CXBottomSheetInternalStyle.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/17/23.
//

import UIKit

protocol CXBottomSheetInternalStyle {
    
    // MARK: - Shadow
    
    var shadowColor: CGColor { get }
    
    var shadowRadius: CGFloat { get }
    
    var shadowOffset: CGSize { get }
    
    var shadowFrameHeight: CGFloat { get }
    
    // MARK: - Grip bar
    
    var gripBarSize: CGSize { get }
    
    var gripBarVerticalPadding: CGFloat { get }
    
    var gripBarColor: UIColor { get }
    
    // MARK: - Animation
    
    var animateDuration: CGFloat { get }
    
    var animateDelay: CGFloat { get }
    
    var springDamping: CGFloat { get }
    
    var initialSpringVelocity: CGFloat { get }
    
    
}
