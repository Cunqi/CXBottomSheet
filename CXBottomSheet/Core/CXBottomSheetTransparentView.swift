//
//  CXBottomSheetTransparentView.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 12/19/23.
//

import UIKit

class CXBottomSheetTransparentView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let event else {
            return nil
        }
        return event.allTouches?.first?.view == self ? nil : super.hitTest(point, with: event)
    }
}
