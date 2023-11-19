//
//  CXBottomSheetContentController.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/19/23.
//

import UIKit

final class CXBottomSheetContentController: UINavigationController {
    
    convenience init(with content: CXBottomSheetContentProtocol?) {
        if let content = content {
            self.init(rootViewController: content)
        } else {
            self.init()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        isNavigationBarHidden = true
    }
    
}
