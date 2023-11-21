//
//  BottomSheetExampleMapContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/21/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExampleMapContentViewController: UIViewController, CXBottomSheetContentProtocol {
    
    var bottomSheet: CXBottomSheetProtocol?
    
    // MARK: - Private properties
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
    }
    
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {
    }
    
}

