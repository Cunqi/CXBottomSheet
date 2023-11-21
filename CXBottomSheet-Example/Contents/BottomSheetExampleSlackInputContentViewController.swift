//
//  BottomSheetExampleSlackInputContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/19/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExampleSlackInputContentViewController: UIViewController, CXBottomSheetContentProtocol {
    
    // MARK: - Constants
    
    private static let minimumContentHeight: CGFloat = 48.0
    
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
        
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    // MARK: - Internal methods
    
    func bottomSheet(didMove bottomSheet: CXBottomSheet.CXBottomSheetProtocol, fromStop: CXBottomSheet.CXBottomSheetStop, toStop: CXBottomSheet.CXBottomSheetStop) {
        textView.isScrollEnabled = bottomSheet.reachedMaxStop
    }
}

// MARK: - UITableViewDelegate

extension BottomSheetExampleSlackInputContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude))
        let currentStop = bottomSheet?.makeBottomSheetStop(contentHeight: max(Self.minimumContentHeight, size.height), isUpperBound: false)
        let stops = [currentStop, .percentage(0.5, isUpperBound: true)].compactMap { $0 }
        let isExpanded = bottomSheet?.reachedMaxStop ?? false
        bottomSheet?.updateStops(stops, immediatelyMoveTo: nil)
        if let currentStop = currentStop, !isExpanded {
            bottomSheet?.move(to: currentStop, animated: true)  // Filter out duplicates
        }
    }
}
