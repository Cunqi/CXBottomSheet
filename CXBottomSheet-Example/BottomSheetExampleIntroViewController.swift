//
//  BottomSheetExampleIntroViewController.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/19/23.
//

import UIKit

class BottomSheetExampleIntroViewController: UITableViewController {
    
    // MARK: - Constants
    
    private static let cellIdentifier = "ExampleItem"
    
    // MARK: - Private properties
    
    private let examples: [BottomSheetExample] = [
        .simpleContentExample,
        .listContentExample
    ]
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Bottom sheet Demos"
        setupTableView()
    }
    
    // MARK: - Override methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        examples.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        let example = examples[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = example.name
        cell.contentConfiguration = content
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let example = examples[indexPath.row]
        let viewController = example.destinationMaker()
        viewController.title = example.name
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
    }
    
}
