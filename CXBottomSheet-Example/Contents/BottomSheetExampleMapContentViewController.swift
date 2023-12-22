//
//  BottomSheetExampleMapContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/21/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExampleMapContentViewController: CXBottomSheetBaseContent {
    
    // MARK: - Internal properties
    
    override var stopContext: CXBottomSheetStopContext? {
        let stops: [CXBottomSheetStop] = [.closed, .percentage(0.15), .half, .full]
        return CXBottomSheetStopContext(stops: stops, stop: .half)
    }
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemGroupedBackground
    }
    
}

