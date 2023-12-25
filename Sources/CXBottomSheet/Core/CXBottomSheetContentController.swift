//
//  CXBottomSheetContentController.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/19/23.
//

import UIKit

final class CXBottomSheetContentController: UINavigationController {
    
    // MARK: - Internal properties
    
    var contents: [CXBottomSheetContentProtocol] {
        return viewControllers.compactMap { $0 as? CXBottomSheetContentProtocol }
    }
    
    var topContent: CXBottomSheetContentProtocol? {
        return topViewController as? CXBottomSheetContentProtocol
    }
    
    // MARK: - Initializer
    
    convenience init(with content: CXBottomSheetContentProtocol? = nil) {
        if let content {
            self.init(rootViewController: content)
        } else {
            self.init()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        isNavigationBarHidden = true
    }
 
    // MARK: - Internal methods
    
    @discardableResult
    func popContent() -> CXBottomSheetContentProtocol? {
        return popViewController(animated: false) as? CXBottomSheetContentProtocol
    }
}
