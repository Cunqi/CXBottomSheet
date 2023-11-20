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
    
    let destinationMaker: () -> UIViewController
    
    // MARK: - Initializer
    
    init(name: String, destinationMaker: @escaping () -> UIViewController) {
        self.name = name
        self.destinationMaker = destinationMaker
    }
    
}

extension BottomSheetExample {
    static let simpleContentExample = BottomSheetExample(name: "Simple content") {
        BottomSheetExampleSimpleExampleViewController()
    }
    
    static let listContentExample = BottomSheetExample(name: "List content") {
        BottomSheetExampleListExampleViewController()
    }
}
