//
//  BottomSheetExampleSimpleExampleViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/19/23.
//

import UIKit
import CXBottomSheet

class BottomSheetExampleSimpleExampleViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var bottomSheet: CXBottomSheetController = {
        let stops: [CXBottomSheetStop] = [.percentage(0.15), .percentage(0.45), .percentage(0.8)]
        let bottomSheet = CXBottomSheetController(
            stops: stops,
            content: simpleBottomSheetContent, 
            delegate: self)
        return bottomSheet
    }()
    
    private lazy var simpleBottomSheetContent: CXBottomSheetContentProtocol = {
        return BottomSheetExampleSimpleContentViewController()
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        setupViewsAndLayoutConstraints()
        
        bottomSheet.setupContent(simpleBottomSheetContent)
        bottomSheet.move(to: bottomSheet.minStop, animated: false)
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndLayoutConstraints() {
        view.addSubview(bottomSheet.view)
        addChild(bottomSheet)
        bottomSheet.didMove(toParent: self)
        
        bottomSheet.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension BottomSheetExampleSimpleExampleViewController: CXBottomSheetDelegate {
    func bottomSheet(availableHeightFor bottomSheet: CXBottomSheet.CXBottomSheetProtocol) -> CGFloat {
        return view.bounds.height
    }
}

