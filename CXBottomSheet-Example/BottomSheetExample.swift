//
//  BottomSheetExample.swift
//  CXBottomSheet-Example
//
//  Created by Cunqi Xiao on 11/19/23.
//

import UIKit
import CXBottomSheet

struct BottomSheetExample {
    
    // MARK: - Properties
    
    let name: String
    
    let introducation: String
    
    let contentMaker: () -> CXBottomSheetContentProtocol
    
    // MARK: - Initializer
    
    init(name: String,
         introduction: String,
         contentMaker: @escaping () -> CXBottomSheetContentProtocol) {
        self.name = name
        self.introducation = introduction
        self.contentMaker = contentMaker
    }
}

extension BottomSheetExample: Equatable {
    static func == (lhs: BottomSheetExample, rhs: BottomSheetExample) -> Bool {
        return lhs.name == rhs.name
    }
    
}

extension BottomSheetExample {
    static let simpleContentExample = BottomSheetExample(
        name: "Simple Example",
        introduction: """
        The demo shows how to create and use a basic bottom sheet by setting up stops, content and delegate,
        after that you can display the bottom sheet without animation, you should see bottom sheet right after
        you enter container view controller
        """) {
        BottomSheetExampleSimpleContentViewController()
    }
    
    static let listContentExample = BottomSheetExample(
        name: "List Example",
        introduction: """
        This demo shows how the bottom sheet interact with list content, only one interaction plan has been provided,
        You can only interact with bottom sheet when it is fully expanded, otherwise, any scrolling gesture will directly
        interact with bottom sheet, when bottom sheet is not fully expanded, scroll up will expand the bottom sheet, once
        bottom sheet is fully expanded, scroll up will scroll up the bottom sheet content, also, you can only scroll to
        collapse the bottom sheet when you hit the top of content (contentOffset == 0). if you wnat to implement other
        interaction logic, feel free to customize your own implemenation.
        """) {
        BottomSheetExampleListContentViewController()
    }
    
    static let popupMessageExample = BottomSheetExample(
        name: "Popup Example",
        introduction: """
        This demo shows two main features, 1) how to update bottom sheet height in real time, this demo calculate text
        height and update the stops accordingly. 2) how to deal with available height changes to make sure bottom sheet
        will not break user experiences
        """) {
            return BottomSheetExamplePopupMessageContentViewController()
        }
    
    static let slackMessageExample = BottomSheetExample(
        name: "Slack Example",
        introduction: """
        This demo is similar to `Popup message` example, but this demo mainly focus on setting up initial content and interact
        with bottom sheet without using some hiddenTextView hack. it also shows how to interact with keyboard hide/show
        """) {
            return BottomSheetExampleSlackMessageContentViewController()
        }
    
    static let mapExample = BottomSheetExample(
        name: "Map Example",
        introduction: """
        This demo shows how to interact with map, mainly forcus on data folow between
        host and content, and how the bottom sheet response to those changes
        """) {
            return BottomSheetExampleMapContentViewController()
        }
}
