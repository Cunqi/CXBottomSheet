//
//  BottomSheetExampleStackFirstContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/23/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExampleStackFirstContentViewController: UIViewController, CXBottomSheetContentProtocol {
    
    var bottomSheet: CXBottomSheetProtocol?
    
    var stopContext: CXBottomSheetStopContext? = {
        let stops: [CXBottomSheetStop] = [.percentage(0.15), .percentage(0.45), .fullyExpanded]
        return CXBottomSheetStopContext(
            stops: stops,
            stop: stops.first)
    }()
    
    // MARK: - Private properties
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tap me", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    // MARK: - Internal methods
    
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {
    }
    
    // MARK: - Private methods
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        let secondContent = BottomSheetExampleStackSecondContentViewController()
        secondContent.saveStopContext(stopContext: bottomSheet?.stopContext)
        bottomSheet?.pushContent(secondContent, immediatelyInvalidate: true)
    }
}

