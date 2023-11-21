//
//  CXBottomSheetCoordinatorProtocol.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/20/23.
//

import UIKit

/// This protocol helps to define the scrolling / panning behavior
/// while interacting with bottom sheet and bottom sheet content
/// There are two things we need to figure out while interacting
/// bottom sheet:
/// 1. When should we interact with bottom sheet and when should
/// we interact with bottom sheet content
/// 2. What's our expectation for the interaction result between
/// bottom sheet and its content
///
/// This protocol is trying to provide a template to solve these
/// two questions above
public protocol CXBottomSheetCoordinatorProtocol: AnyObject {
    
    // MARK: - Public methods
    
    /// This methods can help bottom sheet to figure out if the given view can response to
    /// the pan gesture on bottom sheet, this is the most important step to check if the
    /// event should be passed into content or not, if yes, the pan gesture event should be
    /// passed to both bottom sheet and its content
    /// - Parameters:
    ///   - bottomSheet: bottom sheet that needs to coordinate with
    ///   - view: the view where pan gesture happens on
    /// - Returns: if the view is able to receive the pan gesture
    func bottomSheetCoordinator(bottomSheet: CXBottomSheetProtocol, shouldResponseToGestureEvent view: UIView?) -> Bool
    
    
    /// Ask coordinator to handle `scrollViewWillBeginDragging`
    /// - Parameters:
    ///   - bottomSheet: bottom sheet that needs to coordinate with
    ///   - scrollView: scrollView from bottom sheet content
    func bottomSheetCoordinator(bottomSheet: CXBottomSheetProtocol, contentWillBeginDragging scrollView: UIScrollView)
    
    /// Ask coordinator to handle `scrollViewDidScroll`
    /// - Parameters:
    ///   - bottomSheet: bottom sheet that needs to coordinate with
    ///   - currentHeight: bottom sheet current height
    ///   - scrollView: scrollView from bottom sheet content
    func bottomSheetCoordinator(bottomSheet: CXBottomSheetProtocol, currentHeight: CGFloat, contentDidScroll scrollView: UIScrollView)
    
    /// Ask coordinator to handle `scrollViewDidEndDecelerating`
    /// - Parameters:
    ///   - bottomSheet: bottom sheet that needs to coordinate with
    ///   - scrollView: scrollView from bottom sheet content
    func bottomSheetCoordinator(bottomSheet: CXBottomSheetProtocol, contentDidEndScroll scrollView: UIScrollView)
}

public class CXBottomSheetDefaultCoordinator: NSObject, CXBottomSheetCoordinatorProtocol {
    
    // MARK: - Private properties
    
    private let scrollContext: CXBottomSheetScrollContext
    
    // MARK: - Initializer
    
    init(scrollContext: CXBottomSheetScrollContext) {
        self.scrollContext = scrollContext
    }
    
    // MARK: - Public methods
    
    public func bottomSheetCoordinator(bottomSheet: CXBottomSheetProtocol, shouldResponseToGestureEvent view: UIView?) -> Bool {
        return view is UIScrollView
    }
    
    public func bottomSheetCoordinator(bottomSheet: CXBottomSheetProtocol, contentWillBeginDragging scrollView: UIScrollView) {
        scrollContext.lastContentYOffset = scrollView.contentOffset.y
        scrollContext.isBottomSheetInteractionEnabled = false
    }
    
    public func bottomSheetCoordinator(bottomSheet: CXBottomSheetProtocol, currentHeight: CGFloat, contentDidScroll scrollView: UIScrollView) {
        if scrollContext.lastContentYOffset > scrollView.contentOffset.y {
            // Scroll down
            if scrollView.contentOffset.y <= 0 {
                scrollView.contentOffset.y = 0
                scrollContext.isBottomSheetInteractionEnabled = true
            }
        } else if scrollContext.lastContentYOffset < scrollView.contentOffset.y {
            // scroll up
            if currentHeight < (scrollContext.maxHeight ?? 0) {
                scrollView.contentOffset.y = 0
                scrollContext.isBottomSheetInteractionEnabled = true
            } else {
                scrollContext.isBottomSheetInteractionEnabled = false
            }
        }
        scrollContext.lastContentYOffset = scrollView.contentOffset.y
    }
    
    public func bottomSheetCoordinator(bottomSheet: CXBottomSheetProtocol, contentDidEndScroll scrollView: UIScrollView) {
        scrollContext.isBottomSheetInteractionEnabled = true
    }
}
