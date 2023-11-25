//
//  BottomSheetExampleSlackMessageContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/21/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExampleSlackMessageContentViewController: UIViewController, CXBottomSheetContentProtocol {
    
    // MARK: - Constants
    
    private static let minimumContentHeight: CGFloat = 48.0
    private static let placeholderTextColor: UIColor = .placeholderText
    private static let placeholderText = "Message to yourself for fun!"
    
    var bottomSheet: CXBottomSheet.CXBottomSheetProtocol?
    
    // MARK: - Private properties
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = self
        return textView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsAndLayoutConstraints()
        
        textView.text = Self.placeholderText
        textView.textColor = Self.placeholderTextColor
    }
    
    // MARK: - Internal methods
    
    func bottomSheet(didMove bottomSheet: CXBottomSheet.CXBottomSheetProtocol, fromStop: CXBottomSheet.CXBottomSheetStop, toStop: CXBottomSheet.CXBottomSheetStop) {
        textView.isScrollEnabled = bottomSheet.hasReachedMaxStop
    }
    
    func bottomSheet(didBounceBack bottomSheet: CXBottomSheetProtocol, toMinStop stop: CXBottomSheetStop) {
        textView.resignFirstResponder()
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndLayoutConstraints() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view).inset(8)
        }
    }
}

// MARK: - UITableViewDelegate

extension BottomSheetExampleSlackMessageContentViewController: UITextViewDelegate {
    
    // placeholder text implementation: https://stackoverflow.com/a/27652289 <-- Contains some bugs, but it is not my part
    // to fix this
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = Self.placeholderText
            textView.textColor = Self.placeholderTextColor
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        
        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to black then set its text to the
        // replacement string
        else if textView.textColor == Self.placeholderTextColor && !text.isEmpty && text != currentText {
            textView.textColor = .label
            textView.text = text
        }
        
        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }
        
        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == Self.placeholderTextColor {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == Self.placeholderTextColor {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude))
        let currentStop = bottomSheet?.makeBottomSheetStop(contentHeight: max(Self.minimumContentHeight, size.height), isUpperBound: false)
        let stops = [currentStop, .expanded].compactMap { $0 }
        let isExpanded = bottomSheet?.hasReachedMaxStop ?? false
        bottomSheet?.updateStops(stops, immediatelyMoveTo: nil)
        if let currentStop = currentStop, !isExpanded {
            bottomSheet?.move(to: currentStop, animated: true)  // Filter out duplicates
        }
    }
}

