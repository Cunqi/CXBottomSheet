//
//  CXBottomSheetTransparentView.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 12/19/23.
//

import UIKit

class CXBottomSheetTransparentView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
