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
        
        view.backgroundColor = .systemBlue
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {
        guard let availableHeight = bottomSheet.delegate?.bottomSheet(availableHeightFor: bottomSheet) else {
            return
        }
        label.text = String.init(format: "Current height: %.2f", arguments: [toStop.makeHeight(with: availableHeight)])
    }
    
}
