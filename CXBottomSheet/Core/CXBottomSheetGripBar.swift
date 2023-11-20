//
//  CXBottomSheetGripBarView.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/19/23.
//

import SnapKit
import UIKit

class CXBottomSheetGripBar: UIView {
    
    // MARK: - Private proeprties
    
    private let gripView: UIView
    
    // MARK: - Initializer
    
    init(with style: CXBottomSheetInternalStyle) {
        self.gripView = CXBottomSheetGripBar.makeGripView(with: style)
        super.init(frame: .zero)
        setupViewsAndLayoutConstraints(with: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private static func makeGripView(with style: CXBottomSheetInternalStyle) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = style.gripBarSize.height / 2.0
        view.backgroundColor = style.gripBarColor
        return view
    }
    
    private func setupViewsAndLayoutConstraints(with style: CXBottomSheetInternalStyle) {
        addSubview(gripView)
        
        gripView.snp.makeConstraints { make in
            make.width.equalTo(style.gripBarSize.width)
            make.height.equalTo(self).multipliedBy(0.2).priority(.high)
            make.height.lessThanOrEqualTo(style.gripBarSize.height).priority(.required)
            make.center.equalTo(self)
        }
    }
}
