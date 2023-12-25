//
//  BottomSheetExamplePopupMessageContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/19/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExamplePopupMessageContentViewController: CXBottomSheetBaseContent {
    
    // MARK: - Constants
    
    private static let textViewInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
    private static let minContentHeight = 48.0 + textViewInsets.vertical
    
    // MARK: - Internal properties
    
    override var stopContext: CXBottomSheetStopContext? {
        guard let stop = bottomSheet?.makeStop(contentHeight: Self.minContentHeight, isUpperBound: true) else {
            return nil
        }
        return CXBottomSheetStopContext(stops: [stop], stop: stop)
    }
    
    // MARK: - Private properties
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = self
        textView.bounces = false
        return textView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(Self.textViewInsets)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - Internal methods
    
    func bottomSheet(didMove bottomSheet: CXBottomSheet.CXBottomSheetProtocol, fromStop: CXBottomSheet.CXBottomSheetStop, toStop: CXBottomSheet.CXBottomSheetStop) {
        textView.isScrollEnabled = toStop == .half
    }
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMaxStop stop: CXBottomSheetStop) {
        textView.becomeFirstResponder()
    }
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMinStop stop: CXBottomSheetStop) {
        textView.resignFirstResponder()
    }
}

// MARK: - UITableViewDelegate

extension BottomSheetExamplePopupMessageContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let textSize = textView.sizeThatFits(CGSize(width: view.bounds.width - Self.textViewInsets.horizontal, height: .infinity))
        let updatedContentHeight = max(textSize.height + Self.textViewInsets.vertical, Self.minContentHeight)
        guard let updatedStop = bottomSheet?.makeStop(
            contentHeight: updatedContentHeight,
            circutBreaker: .half,
            isUpperBound: true) else {
            return
        }
        bottomSheet?.updateStopContext(stops: [updatedStop], stop: updatedStop, animated: true)
    }
}

extension UIEdgeInsets {
    var horizontal: CGFloat {
        return abs(left) + abs(right)
    }
    
    var vertical: CGFloat {
        return abs(top) + abs(bottom)
    }
}
