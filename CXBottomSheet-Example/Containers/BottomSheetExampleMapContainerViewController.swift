//
//  BottomSheetExampleMapContainerViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/21/23.
//

import CXBottomSheet
import MapKit
import SnapKit

class BottomSheetExampleMapContainerViewController: UIViewController {
    
    // MARK: - Constants
    
    private static let buttonSize = CGSize(width: 36.0, height: 36.0)
    
    // MARK: - Private properties
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Self.buttonSize.width / 2.0
        button.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var bottomSheet = CXBottomSheetController(stops: stops, content: content, delegate: self)
    
    private let stops: [CXBottomSheetStop] = [.fixed(120), .percentage(0.5), .fullyExpanded]

    private let content: CXBottomSheetContentProtocol
    
    private let introduction: String
    
    // MARK: - Initializer
    
    init(content: CXBottomSheetContentProtocol, introduction: String) {
        self.content = content
        self.introduction = introduction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        [mapView, bottomSheet.view, backButton].forEach { view.addSubview($0) }
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        bottomSheet.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view)
        }
        
        backButton.snp.makeConstraints { make in
            make.size.equalTo(Self.buttonSize)
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        }
        bottomSheet.move(to: bottomSheet.minStop, animated: false)
        stylize()
    }
    
    // MARK: - Private methods
    
    private func stylize() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc
    private func didTapBackButton(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - CXBottomSheetDelegate

extension BottomSheetExampleMapContainerViewController: CXBottomSheetDelegate {
    func bottomSheet(availableHeightFor bottomSheet: CXBottomSheetProtocol) -> CGFloat {
        return view.bounds.height
    }
}
