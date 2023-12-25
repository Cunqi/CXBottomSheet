//
//  BottomSheetExampleStackSecondContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/24/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExampleStackSecondContentViewController: CXBottomSheetBaseContent {
    
    // MARK: - Constants
    
    private static let minimumContentHeight: CGFloat = 48.0
    
    // MARK: - Internal properties
    
    override var stopContext: CXBottomSheetStopContext? {
        return CXBottomSheetStopContext(stops: [.half], stop: .half)
    }
    
    // MARK: - Private properties
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.backgroundColor = .clear
        return textView
    }()
    
    private lazy var barItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapBarButtonItem))
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemGroupedBackground
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        }
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = barItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - Internal methods
    
    func bottomSheet(didMove bottomSheet: CXBottomSheet.CXBottomSheetProtocol, fromStop: CXBottomSheet.CXBottomSheetStop, toStop: CXBottomSheet.CXBottomSheetStop) {
        textView.isScrollEnabled = bottomSheet.hasReachedVisibleMaxStop
    }
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMaxStop stop: CXBottomSheetStop) {
        textView.becomeFirstResponder()
    }
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMinStop stop: CXBottomSheetStop) {
        textView.resignFirstResponder()
    }
    
    // MARK: - Private methods
    
    @objc
    private func didTapBarButtonItem() {
        bottomSheet?.popContent(animated: false)
    }
}
