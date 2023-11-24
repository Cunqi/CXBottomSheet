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
    
    private lazy var bottomSheet: CXBottomSheetController = {
        let stops: [CXBottomSheetStop] = [.percentage(0.15), .percentage(0.45), .fullyExpanded]
        let bottomSheet = CXBottomSheetController(
            content: content,
            stopContext: CXBottomSheetStopContext(stops: stops),
            delegate: self)
        return bottomSheet
    }()
    
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
        [introductionLabel, bottomSheet.view].forEach { view.addSubview($0) }
        addChild(bottomSheet)
        bottomSheet.didMove(toParent: self)
        
        introductionLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 16, left: 24, bottom: 0, right: 24))
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }
        
        bottomSheet.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension BottomSheetExampleContainerViewController: CXBottomSheetDelegate {
    func bottomSheet(availableHeightFor bottomSheet: CXBottomSheet.CXBottomSheetProtocol) -> CGFloat {
        return view.bounds.height
    }
}

