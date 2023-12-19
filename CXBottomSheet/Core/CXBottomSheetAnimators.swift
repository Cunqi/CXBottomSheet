//
//  CXBottomSheetAnimators.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 12/19/23.
//

import UIKit

public class CXBottomSheetVoidAnimator: CXBottomSheetAnimatorProtocol {
    public func animateMovement(animations: @escaping CXBottomSheetAnimationsBlock, completion: @escaping CXBottomSheetCompletionBlock) {
        animations()
        completion(true)
    }
}

public class CXBottomSheetEaseInOutAnimator: CXBottomSheetAnimatorProtocol {
    
    // MARK: - Private properties
    
    private let duration: TimeInterval
    
    // MARK: - Initializer
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    // MARK: - Public methods
    
    public func animateMovement(animations: @escaping CXBottomSheetAnimationsBlock, completion: @escaping CXBottomSheetCompletionBlock) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseInOut,
            animations: animations,
            completion: completion)
    }
}

public class CXBottomSheetPropertyAnimator: CXBottomSheetAnimatorProtocol {
    
    // MARK: - Private properties
    
    private let propertyAnimator: UIViewPropertyAnimator
    
    // MARK: - Initializer
    
    init(propertyAnimator: UIViewPropertyAnimator) {
        self.propertyAnimator = propertyAnimator
    }
    
    // MARK: - Public methods
    
    public func animateMovement(animations: @escaping CXBottomSheetAnimationsBlock, completion: @escaping CXBottomSheetCompletionBlock) {
        propertyAnimator.addAnimations(animations)
        propertyAnimator.addCompletion { position in
            completion(position == .end)
        }
        propertyAnimator.startAnimation()
    }
    
}
