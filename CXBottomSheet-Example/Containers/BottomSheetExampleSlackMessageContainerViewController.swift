//
//  BottomSheetExampleSlackMessageContainerViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/21/23.
//

import UIKit
import CXBottomSheet

class BottomSheetExampleSlackMessageContainerViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var introductionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.text = introduction
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bottomSheet = CXBottomSheetController(content: content)

    private let content: CXBottomSheetContentProtocol
    
    private let introduction: String?
    
    private var keyboardHeight: CGFloat = 0
    
    // MARK: - Initializer
    
    init(content: CXBottomSheetContentProtocol, introduction: String?) {
        self.content = content
        self.introduction = introduction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        setupViewsAndLayoutConstraints()
        let initialStop = bottomSheet.makeStop(contentHeight: 48.0, isUpperBound: false)
//        bottomSheet.updateStops([initialStop, .expanded], immediatelyMoveTo: initialStop)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndLayoutConstraints() {
        [introductionLabel, bottomSheet.view].forEach { view.addSubview($0) }
        addChild(bottomSheet)
        bottomSheet.didMove(toParent: self)
        
        introductionLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 24))
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }
        
        bottomSheet.view.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
}

extension BottomSheetExampleSlackMessageContainerViewController: CXBottomSheetDelegate {
    func bottomSheet(availableHeightFor bottomSheet: CXBottomSheet.CXBottomSheetProtocol) -> CGFloat {
        return view.bounds.height -
        (navigationController?.navigationBar.frame.height ?? 0) -
        keyboardHeight
    }
}

extension BottomSheetExampleSlackMessageContainerViewController {
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        keyboardHeight = keyboardFrame.cgRectValue.height
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        keyboardHeight = 0
    }
    
}


