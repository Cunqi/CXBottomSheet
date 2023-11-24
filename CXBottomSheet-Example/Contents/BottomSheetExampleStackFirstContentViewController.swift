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
        let stops: [CXBottomSheetStop] = [.percentage(0.5), .fullyExpanded]
        let secondContent = BottomSheetExampleStackSecondContentViewController()
        bottomSheet?.pushContent(secondContent, stops: stops, immediatelyMoveTo: stops.first)
    }
}

