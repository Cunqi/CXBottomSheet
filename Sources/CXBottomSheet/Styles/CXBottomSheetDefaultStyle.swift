//
//  CXBottomSheetDefaultStyle.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/17/23.
//

import UIKit

public class CXBottomSheetDefaultStyle: CXBottomSheetStyle, CXBottomSheetInternalStyle {
    
    // MARK: - Properties
    
    public let isGripBarHidden: Bool

    public let isShadowEnabled: Bool
    
    public let backgroundColor: UIColor
    
    public let cornerRadius: CGFloat
    
    public let scrollSensitiveLevel: CXBottomSheetScrollSensitiveLevel
    
    // MARK: - Internal properties
    
    let shadowColor: CGColor = UIColor.systemGray.cgColor
    
    let shadowRadius: CGFloat = 16.0
    
    let shadowOffset: CGSize = CGSize(width: 0, height: 4.0)
    
    let shadowFrameHeight: CGFloat = 24.0
    
    let gripBarSize: CGSize = CGSize(width: 48.0, height: 4.0)
    
    let gripBarVerticalPadding: CGFloat = 8.0
    
    let gripBarColor: UIColor = .systemGray3
    
    let animateDuration: CGFloat = 0.25
    
    let animateDelay: CGFloat = 0
    
    let springDamping: CGFloat = 0.8
    
    let initialSpringVelocity: CGFloat = 1.0
    
    // MARK: - Initializer
    
    public convenience init() {
        self.init(with: Builder())
    }
    
    public init(with builder: CXBottomSheetStyleBuilder) {
        self.isGripBarHidden = builder.isGripBarHidden
        self.isShadowEnabled = builder.isShadowEnabled
        self.backgroundColor = builder.backgroundColor
        self.cornerRadius = builder.cornerRadius
        self.scrollSensitiveLevel = builder.scrollSensitiveLevel
    }
}

public extension CXBottomSheetDefaultStyle {
    class Builder: CXBottomSheetStyleBuilder {
        
        // MARK: - Properties
        
        public private(set) var isGripBarHidden: Bool = false
        
        public private(set) var isShadowEnabled: Bool = true
        
        public private(set) var backgroundColor: UIColor = .secondarySystemGroupedBackground
        
        public private(set) var cornerRadius: CGFloat = 16.0
        
        public private(set) var scrollSensitiveLevel: CXBottomSheetScrollSensitiveLevel = .medium
        
        // MARK: - Public methods
        
        public func setGripBarHidden(isHidden: Bool) -> Self {
            isGripBarHidden = isHidden
            return self
        }
        
        public func setShadowEnabled(isEnabled: Bool) -> Self {
            isShadowEnabled = isEnabled
            return self
        }
        
        public func setBackgroundColor(_ color: UIColor) -> Self {
            backgroundColor = color
            return self
        }
        
        public func setCornerRadius(_ value: CGFloat) -> Self {
            cornerRadius = value
            return self
        }
        
        public func setScrollSensitiveLevel(_ value: CXBottomSheetScrollSensitiveLevel) -> Self {
            scrollSensitiveLevel = min(1, max(0, value))
            return self
        }
        
        public func build() -> CXBottomSheetStyle {
            return CXBottomSheetDefaultStyle(with: self)
        }
    }
}

extension CXBottomSheetStyle {
    var `internal`: CXBottomSheetInternalStyle {
        return self as? CXBottomSheetInternalStyle ?? CXBottomSheetDefaultStyle()
    }
}
