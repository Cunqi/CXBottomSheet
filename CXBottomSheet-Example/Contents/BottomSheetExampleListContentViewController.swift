//
//  BottomSheetExampleListContentViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/18/23.
//

import UIKit
import CXBottomSheet
import SnapKit

class BottomSheetExampleListContentViewController: UIViewController, CXBottomSheetContentProtocol {
    
    var stopContext: CXBottomSheetStopContext? {
        let stops: [CXBottomSheetStop] = [.percentage(0.15), .fixed(250), .full]
        return CXBottomSheetStopContext(stops: stops, stop: stops.first)
    }
    
    var bottomSheet: CXBottomSheetProtocol?
    
    // MARK: - Private properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndLayoutConstraints()
    }
    
    // MARK: - Internal methods
    
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol, fromStop: CXBottomSheetStop, toStop: CXBottomSheetStop) {
        tableView.isScrollEnabled = toStop == .full
        if fromStop == .full {
            tableView.setContentOffset(.zero, animated: true)
        }
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndLayoutConstraints() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension BottomSheetExampleListContentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = indexPath.row % 2 == 0 ? .systemMint : .systemGray
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}

extension BottomSheetExampleListContentViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        bottomSheet?.scrollViewWillBeginDragging?(scrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bottomSheet?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        bottomSheet?.scrollViewDidEndDecelerating?(scrollView)
    }
}

