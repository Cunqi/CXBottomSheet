//
//  BottomSheetExampleSimpleExampleViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/19/23.
//

import UIKit
import CXBottomSheet

class BottomSheetExampleContainerViewController: UIViewController {
    
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
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViewsAndLayoutConstraints()
        bottomSheet.move(to: bottomSheet.minStop, animated: false)
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndLayoutConstraints() {
        [introductionLabel, bottomSheet.container].forEach { view.addSubview($0) }
        addChild(bottomSheet)
        bottomSheet.didMove(toParent: self)
        
        introductionLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 24))
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }
        
        bottomSheet.container.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
