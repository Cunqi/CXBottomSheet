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
    
    var bottomSheet: CXBottomSheet.CXBottomSheetProtocol?
    
    // MARK: - Private properties
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.delegate = self
        return textView
    }()
    
    private lazy var barItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(didTapBarButtonItem))
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalTo(view)
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
        textView.isScrollEnabled = bottomSheet.reachedMaxStop
    }
    
    // MARK: - Private methods
    
    @objc
    private func didTapBarButtonItem() {
        let stops: [CXBottomSheetStop] = [.percentage(0.15), .percentage(0.45), .fullyExpanded]
        navigationController?.popViewController(animated: false)
        bottomSheet?.updateStops(stops, moveTo: .percentage(0.15), immediately: false)
    }
}

// MARK: - UITableViewDelegate

extension BottomSheetExampleStackSecondContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude))
        let currentStop = bottomSheet?.makeBottomSheetStop(
            contentHeight: max(Self.minimumContentHeight, size.height),
            circutBreaker: nil,
            isUpperBound: false)
        let stops = [currentStop, .percentage(0.5, isUpperBound: true)].compactMap { $0 }
        let isExpanded = bottomSheet?.reachedMaxStop ?? false
        bottomSheet?.updateStops(stops, moveTo: nil, immediately: true)
        if let currentStop = currentStop, !isExpanded {
            bottomSheet?.move(to: currentStop, animated: true)  // Filter out duplicates
        }
    }
}

