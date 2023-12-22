//
//  BottomSheetExampleSimpleContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/17/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExampleSimpleContentViewController: CXBottomSheetBaseContent {
    
    override var stopContext: CXBottomSheetStopContext? {
        CXBottomSheetStopContext(stops: [.percentage(0.15), .half, .full], stop: .half)
    }
    
    // MARK: - Private properties
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemGroupedBackground
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.leading.greaterThanOrEqualTo(view.snp.leading)
            make.trailing.lessThanOrEqualTo(view.snp.trailing)
        }
    }
    
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {
        label.text = "Did move \nFrom stop: \(fromStop.type) \nTo stop: \(toStop.type)"
    }
}
