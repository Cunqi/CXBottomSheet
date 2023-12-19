//
//  CXBottomSheetAnimatorProtocol.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 12/19/23.
//

import UIKit

public typealias CXBottomSheetAnimationsBlock = () -> Void
public typealias CXBottomSheetCompletionBlock = (Bool) -> Void

public protocol CXBottomSheetAnimatorProtocol: AnyObject {
    
    func animateMovement(animations: @escaping CXBottomSheetAnimationsBlock,
                         completion: @escaping CXBottomSheetCompletionBlock)
    
}
