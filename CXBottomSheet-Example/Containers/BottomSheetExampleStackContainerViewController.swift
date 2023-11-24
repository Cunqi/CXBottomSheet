//
//  BottomSheetExampleStackContainerViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/23/23.
//

import UIKit
import CXBottomSheet

class BottomSheetExampleStackContainerViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var introductionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.text = introduction
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bottomSheet: CXBottomSheetController = {
        let stops: [CXBottomSheetStop] = [.percentage(0.15), .percentage(0.45), .fullyExpanded]
        let bottomSheet = CXBottomSheetController(
            stops: stops,
            content: content,
            delegate: self)
        return bottomSheet
    }()
    
    private lazy var monitorWindow: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let content: CXBottomSheetContentProtocol
    
    private let introduction: String?
    
    private var keyboardHeight: CGFloat = 0
    
    private var boundsObserver: NSKeyValueObservation?
    private var previousSize: CGSize = .zero
    
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
        bottomSheet.move(to: bottomSheet.minStop, animated: false)
        
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
        
        boundsObserver = monitorWindow.observe(\.bounds, changeHandler: { [weak self] view, _ in
            guard let self = self,
                  self.previousSize != view.bounds.size else {
                return
            }
            print("bounds \(view.bounds)")
            self.previousSize = view.bounds.size
            self.bottomSheet.invalidate(animated: true)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        boundsObserver?.invalidate()
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndLayoutConstraints() {
        [introductionLabel, bottomSheet.view, monitorWindow].forEach { view.addSubview($0) }
        addChild(bottomSheet)
        bottomSheet.didMove(toParent: self)
        
        introductionLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 24))
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }
        
        monitorWindow.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        bottomSheet.view.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(monitorWindow)
        }
    }
}

extension BottomSheetExampleStackContainerViewController: CXBottomSheetDelegate {
    func bottomSheet(availableHeightFor bottomSheet: CXBottomSheet.CXBottomSheetProtocol) -> CGFloat {
        return monitorWindow.bounds.height
    }
}

extension BottomSheetExampleStackContainerViewController {
    @objc
    private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        keyboardHeight = keyboardFrame.cgRectValue.height
        
        guard let keyboardAnimationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let keyboardAnimationCurve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int,
              let keyboardCurve = UIView.AnimationCurve(rawValue: keyboardAnimationCurve) else {
            return
        }
        let animator = UIViewPropertyAnimator(duration: keyboardAnimationDuration, curve: keyboardCurve)
        bottomSheet.move(to: bottomSheet.minStop, animator: animator)
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        keyboardHeight = 0
    }
}

