//
//  CXBottomSheetProtocol.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/16/23.
//

import UIKit


/// This protocol specifies the properties and functions that the bottom sheet 
/// should have. Both the host and the consumer can use these properties and
///  functions to interact with the bottom sheet.
public protocol CXBottomSheetProtocol: UIViewController, UIScrollViewDelegate {

    // MARK: - Properties
    
    /// All stops that bottom sheet currently supports
    var stops: [CXBottomSheetStop] { get }
    
    /// Bottom sheet current stop position
    var currentStop: CXBottomSheetStop { get }

    /// The stop which currently has highest height
    var maxStop: CXBottomSheetStop { get }

    /// The stop which currently has lowest height
    var minStop: CXBottomSheetStop { get }
    
    /// Bottom sheet can be considered as closed only if `currentStop` is `closed`
    var isHidden: Bool { get }
    
    /// If bottom sheet stops at the `maxStop`
    var hasReachedMaxStop: Bool { get }
    
    /// If bottom sheet stops at the `minStop`
    var hasReachedMinStop: Bool { get }
    
    /// Flag if bottom sheet is able to response any user interactions
    var isUserInteractionEnabled: Bool { get set }
    
    /// Coordinator for coordinating the pan / scrolling interactions between bottom sheet
    /// and it's contnet
    var coordinator: CXBottomSheetCoordinatorProtocol { get set }
    
    /// Delegate of handling bottom sheet display and behaviors
    var delegate: CXBottomSheetDelegate? { get }
    
    /// Current bottom sheet stop context
    var stopContext: CXBottomSheetStopContext { get }

    // MARK: - Public methods
    
    /// Directly setup content to bottom sheet regardless of current bottom sheet hierarchy
    /// - Parameter content: root content of bottom sheet
    func setupContent(_ rootContent: CXBottomSheetContentProtocol)
    
    /// Push content to bottom sheet into current bottom sheet content stack
    /// - Parameters:
    ///   - content: content that we want to push in current bottom sheet hierarchy
    ///   - immediatelyInvalidate: should invalidate current bottom sheet or not
    func pushContent(_ content: CXBottomSheetContentProtocol, immediatelyInvalidate: Bool)
    
    /// Pop content to previous content from current bottom sheet content stack
    /// - Parameter immediatelyInvalidate: should invalidate current bottom sheet or not
    func popContent(immediatelyInvalidate: Bool)
    
    /// Craete a `fixed` stop with extra bottom sheet space included (e.g. grip view from bottom sheet)
    /// - Parameters:
    ///   - contentHeight: height of content
    ///   - isUpperBound: if the stop is upper bound stop
    /// - Returns: adjusted stop contains extra height for bottom sheet
    func makeBottomSheetStop(contentHeight: CGFloat, isUpperBound: Bool) -> CXBottomSheetStop
    
    /// Craete a `fixed` stop with extra bottom sheet space included (e.g. grip view from bottom sheet)
    /// - Parameters:
    ///   - contentHeight: height of content
    ///   - stop: A circut break stop can help to prevent the content exceeds maximum size of bottom sheet
    ///   - isUpperBound: if the stop is upper bound stop
    /// - Returns: adjusted stop contains extra height for bottom sheet
    func makeBottomSheetStop(contentHeight: CGFloat, circutBreaker stop: CXBottomSheetStop?, isUpperBound: Bool) -> CXBottomSheetStop
    
    /// /// Update bottom sheet stops then optionally move to a given stop immediately
    /// - Parameters:
    ///   - stops: All stops that we want the bottom sheet to support
    ///   - stop: expect stop we want the bottom sheet to move to after `stops` setup
    func updateStops(_ stops: [CXBottomSheetStop], immediatelyMoveTo stop: CXBottomSheetStop?)
    
    /// Update bottom sheet stops then optionally move to a given stop immediately
    /// - Parameters:
    ///   - stops: All stops that we want the bottom sheet to support
    ///   - stop: expect stop we want the bottom sheet to move to after `stops` setup
    ///   - immediately: should immediately move the bottom sheet to given sotp or not
    func updateStops(_ stops: [CXBottomSheetStop], moveTo stop: CXBottomSheetStop?, immediately: Bool)

    /// Move bottom sheet to a given stop
    /// - Parameters:
    ///   - stop: A stop we want the bottom sheet to move to
    ///   - animated: Enable animation for bottom sheet movement
    func move(to stop: CXBottomSheetStop, animated: Bool)
    
    /// Move bottom sheet to a given stop
    /// - Parameters:
    ///   - stop: A stop we want the bottom sheet to move to
    ///   - animator: Create a custom animator to execute the bottom sheet movement
    func move(to stop: CXBottomSheetStop, animator: UIViewPropertyAnimator)
    
    /// Invalidate the bottom sheet without change any stop configuration, this is usefull when
    /// available height changed
    /// - Parameter animated: Enable animation for bottom sheet invalidation
    func invalidate(animated: Bool)
}

