//
//  BottomSheetExampleStackSecondContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/24/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExampleStackSecondContentViewController: UIViewController, CXBottomSheetContentProtocol {
    
    // MARK: - Constants
    
    private static let minimumContentHeight: CGFloat = 48.0
    
    // MARK: - Internal properties
    
    var bottomSheet: CXBottomSheet.CXBottomSheetProtocol?
    
    var stopContext: CXBottomSheetStopContext? {
        let stops: [CXBottomSheetStop] = [.percentage(0.5)]
        return CXBottomSheetStopContext(stops: stops, stop: stops.first)
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
    
    private var previousStopContext: CXBottomSheetStopContext?
    
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
        textView.isScrollEnabled = bottomSheet.hasReachedMaxStop
    }
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMaxStop stop: CXBottomSheetStop) {
        textView.becomeFirstResponder()
    }
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMinStop stop: CXBottomSheetStop) {
        textView.resignFirstResponder()
    }
    
    func saveStopContext(stopContext: CXBottomSheetStopContext?) {
        previousStopContext = stopContext
    }
    
    func loadStopContext() -> CXBottomSheetStopContext? {
        return previousStopContext
    }
    
    // MARK: - Private methods
    
    @objc
    private func didTapBarButtonItem() {
        bottomSheet?.popContent(immediatelyInvalidate: false)
    }
}
