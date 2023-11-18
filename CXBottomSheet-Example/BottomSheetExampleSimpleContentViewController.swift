//
//  BottomSheetExampleSimpleContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/17/23.
//

import UIKit
import CXBottomSheet

class BottomSheetExampleSimpleContentViewController: UIViewController, CXBottomSheetContentProtocol {
    
    // MARK: - Private properties
    
    var bottomSheet: CXBottomSheetProtocol?
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
    }
    
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {
    }
    
}
