//
//  BottomSheetExampleContainerViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/16/23.
//

import UIKit
import CXBottomSheet

class BottomSheetExampleContainerViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var bottomSheet: CXBottomSheetController = {
        let stops: [CXBottomSheetStop] = [.percentage(0.15), .percentage(0.45), .fullyExpanded]
        let bottomSheet = CXBottomSheetController(stops: stops, delegate: self)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomSheet.move(to: bottomSheet.minStop)
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

extension BottomSheetExampleContainerViewController: CXBottomSheetDelegate {
    func bottomSheet(availableHeightFor bottomSheet: CXBottomSheet.CXBottomSheetProtocol) -> CGFloat {
        return view.bounds.height
    }
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMaxStop stop: CXBottomSheetStop) {
        print("[BottomSheet] Bounce back to max stop \(stop)")
    }
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMinStop stop: CXBottomSheetStop) {
        print("[BottomSheet] Bounce back to min stop \(stop)")
    }
}
