//
//  BottomSheetExampleSimpleContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/17/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExampleSimpleContentViewController: UIViewController, CXBottomSheetContentProtocol {
    
    var bottomSheet: CXBottomSheetProtocol?
    
    var stopContext: CXBottomSheetStopContext? {
        CXBottomSheetStopContext(stops: [.percentage(0.15), .half, .full], stop: .half)
    }
    
    // MARK: - Private properties
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemGroupedBackground
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {
        label.text = "ContainerView \(bottomSheet.container.bounds.size)"
    }
    
}
