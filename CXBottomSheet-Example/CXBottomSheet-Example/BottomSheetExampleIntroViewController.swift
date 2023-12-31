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
        .listContentExample,
        .popupMessageExample,
        .slackMessageExample,
        .mapExample,
        .stackExample
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
        
        if example == .popupMessageExample {
            let containerViewController = BottomSheetExamplePopupMessageContainerViewController(
                content: example.contentMaker(),
                introduction: example.introducation)
            containerViewController.title = example.name
            navigationController?.pushViewController(containerViewController, animated: true)
        } else if example == .slackMessageExample {
            let containerViewController = BottomSheetExampleSlackMessageContainerViewController(
                content: example.contentMaker(),
                introduction: example.introducation)
            containerViewController.title = example.name
            navigationController?.pushViewController(containerViewController, animated: true)
        } else if example == .mapExample {
          let containerViewController = BottomSheetExampleMapContainerViewController(
            content: example.contentMaker(),
            introduction: example.introducation)
            navigationController?.pushViewController(containerViewController, animated: true)
        } else if example == .stackExample {
            let containerViewController = BottomSheetExampleStackContainerViewController(
              content: example.contentMaker(),
              introduction: example.introducation)
              navigationController?.pushViewController(containerViewController, animated: true)
        } else {
            let containerViewController = BottomSheetExampleContainerViewController(
                content: example.contentMaker(),
                introduction: example.introducation)
            containerViewController.title = example.name
            navigationController?.pushViewController(containerViewController, animated: true)
        }
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
    }
    
}
