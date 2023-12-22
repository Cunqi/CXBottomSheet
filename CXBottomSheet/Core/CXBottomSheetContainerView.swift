//
//  CXBottomSheetContainerView.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 12/19/23.
//

import UIKit

protocol CXBottomSheetContainerViewDelegate: AnyObject {
    func containerView(_ containerView: CXBottomSheetContainerView, sizeDidChangeTo size: CGSize)
}

class CXBottomSheetContainerView: CXBottomSheetTransparentView {
    
    // MARK: - Internal properties
    
    weak var delegate: CXBottomSheetContainerViewDelegate?
    
    // MARK: - Private properties
    
    private var previousSize: CGSize = .zero
    
    // MARK: - Override methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if previousSize != bounds.size {
            previousSize = bounds.size
            delegate?.containerView(self, sizeDidChangeTo: bounds.size)
        }
    }
    
}
