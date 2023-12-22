//
//  BottomSheetExampleSlackMessageContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/21/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExampleSlackMessageContentViewController: CXBottomSheetBaseContent {
    
    // MARK: - Constants
    
    private static let textViewInsets = UIEdgeInsets(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)
    private static let minContentHeight = 48.0 + textViewInsets.vertical
    
    private static let placeholderTextColor: UIColor = .placeholderText
    private static let placeholderText = "Message to yourself for fun!"
    
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
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = self
        textView.textContainerInset = .zero
        return textView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = Self.placeholderText
        label.textColor = Self.placeholderTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var hasText: Bool {
        return !textView.text.isEmpty
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsAndLayoutConstraints()
    }
    
    // MARK: - Internal methods
    
    func bottomSheet(didMove bottomSheet: CXBottomSheet.CXBottomSheetProtocol, fromStop: CXBottomSheet.CXBottomSheetStop, toStop: CXBottomSheet.CXBottomSheetStop) {
        textView.isScrollEnabled = bottomSheet.hasReachedVisibleMaxStop
    }
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMinStop stop: CXBottomSheetStop) {
        textView.resignFirstResponder()
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndLayoutConstraints() {
        view.backgroundColor = .systemBackground
        [textView, placeholderLabel].forEach { view.addSubview($0) }
        
        textView.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualTo(view).priority(.required)
            make.edges.equalTo(view).inset(Self.textViewInsets).priority(.high)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(textView)
            make.leading.equalTo(textView).inset(textView.textContainer.lineFragmentPadding)
        }
    }
    
    private func updatePlaceholderLabelVisibility() {
        placeholderLabel.isHidden = hasText
    }
}

// MARK: - UITableViewDelegate

extension BottomSheetExampleSlackMessageContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderLabelVisibility()
        
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
