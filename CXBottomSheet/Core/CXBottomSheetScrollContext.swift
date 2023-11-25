//
//  CXBottomSheetScrollContext.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/16/23.
//

import Foundation

/// This class contains all required properties for panning / scrolling position calculation, there are two major
/// responsibility for `CXBottomSheetScrollContext`:
/// 1. It helps to handle pan position calculation and help to determine the proper stop after panning ends
/// 2. It helps to coodinate scrolling between bottom sheet and bottom sheet content (if a content is scrollable)
class CXBottomSheetScrollContext {
    
    enum ScrollDirection: Int {
        case up
        case down
        case none
    }

    // MARK: - Constants
    
    /// Bounce factor was used to mimic a bounce animation
    private static let bounceFactor = 0.06

    // MARK: - Properties
    
    /// Use to record the last content offset Y position,
    /// this can help to determine scroll direction on content
    /// This property should work with scrollable content ONLY
    var lastContentYOffset: CGFloat = 0

    /// Use to setup if bottom sheet is currently enabled for user interaction
    /// This is used to classify the guesture priority when there is a conflict
    var isBottomSheetInteractionEnabled = true

    /// Maximum height we can reach in current panning / scrolling
    var maxHeight: CGFloat {
        stopContext.maxStop.makeHeight(with: availableHeight)
    }

    /// Minimum height we can reach in current panning / scrolling
    var minHeight: CGFloat {
        stopContext.minStop.makeHeight(with: availableHeight)
    }
    
    var scrollDirection: ScrollDirection {
        if pannedDelta == 0 {
            return .none
        }
        return pannedDelta > 0 ? .up : .down
    }
    
    
    
    // MARK: - Private properties

    /// When panning height exceeds maximum height or lower than minimum height
    /// A bounce offset should be applied to the height change for a damping effect
    private var bounceOffset: CGFloat {
        return Self.bounceFactor * pannedDelta
    }

    /// Current stop context snapshot, this will be used to find the right stop
    /// after panning / scrolling
    private var stopContext: CXBottomSheetStopContext = .default

    /// At the begnning of panning / scrolling, an available height should be finalized,
    /// this height will be used to calculate pan position as well as determing final stop
    private var availableHeight: CGFloat = 0
    
    /// At the beginning of panning / scrolling, current height will be setup to support
    /// height calculation
    private var currentHeight: CGFloat = 0
    
    /// Indicate current yPosition while panning
    private var yPosition: CGFloat = 0
    
    /// Indicate start Y Position
    private var startYPosition: CGFloat = 0

    /// Indicate the real time distance while panning,
    /// positive value represents panning up
    /// negative value represents panning down
    private var pannedDelta: CGFloat {
        return startYPosition - yPosition
    }
    
    private let scrollSensitiveLevel: CXBottomSheetScrollSensitiveLevel
    
    // MARK: - Initializer
    
    init(scrollSensitiveLevel: CXBottomSheetScrollSensitiveLevel) {
        self.scrollSensitiveLevel = scrollSensitiveLevel
    }

    // MARK: - Internal methods
    
    /**
     Make snapshot before processing scrolling related calculations, this is required to maintain the accuracy
     of scrolling position

     @param startPosition the start position when finger is on screen and will begin scrolling
     @param currenHeight curren bottom sheet height
     @param availableHeight the available scrolling window while scrolling
     @param stops stops that the scrolling can end with
     */

    
    /// A snapshot should be made at the very beginning when we want to pan / scroll, by making a snapshot of those
    /// properties, we can get the expected height / stop after finishing panning / scrolling
    /// - Parameters:
    ///   - startYPosition: Start Y position
    ///   - currentHeight: Current bottom sheet height
    ///   - availableHeight: Available height that the bottom sheet can scroll
    ///   - stopContext: Current bottom sheet stop context
    func makeSnapshot(startYPosition: CGFloat,
                      currentHeight: CGFloat,
                      availableHeight: CGFloat,
                      stopContext: CXBottomSheetStopContext) {
        self.startYPosition = startYPosition
        self.currentHeight = currentHeight
        self.availableHeight = availableHeight
        self.stopContext = stopContext
    }
    
    /// Find the stop that has the minimum delta value with given height
    /// - Parameter targetHeight: height to find the right stop
    /// - Returns: the most closet stop if available
    func fetchClosetStop(with targetHeight: CGFloat) -> CXBottomSheetStop {
        guard stopContext.stops.count > 1 else {
            return stopContext.stops.first ?? stopContext.stop
        }
        
        for index in 0 ..< (stopContext.stops.count - 1) {
            let stop = stopContext.stops[index]
            let nextStop = stopContext.stops[index + 1]
            let stopHeight = stop.makeHeight(with: availableHeight)
            let nextStopHeight = nextStop.makeHeight(with: availableHeight)
            let deltaThreshold = (nextStopHeight - stopHeight) * scrollSensitiveLevel
            
            guard targetHeight <= nextStopHeight else {
                continue
            }
            
            if scrollDirection == .up {
                let heightThreshold = stopHeight + deltaThreshold
                return targetHeight >= heightThreshold ? nextStop : stop
            } else if scrollDirection == .down {
                let heightThreshold = nextStopHeight - deltaThreshold
                return targetHeight <= heightThreshold ? stop : nextStop
            }
        }
        return stopContext.stops.last ?? stopContext.stop
    }

    /// Calculate and return the final pan positon when the panning action ends, a bounce animation might be applied if
    /// the bottom sheet is still being dragged even the `currentHeight` is out of range `(minHeight, maxHeight)`
    /// - Returns: final height after panning
    func makeFinalPanPosition() -> CGFloat {
        let finalHeight = currentHeight + pannedDelta
        if finalHeight >= maxHeight {
            return maxHeight + bounceOffset
        } else if finalHeight <= minHeight {
            return minHeight + bounceOffset
        }
        return finalHeight
    }
    
    func isBouncingBack(with height: CGFloat) -> Bool {
        return height > maxHeight || height < minHeight
    }

    func updateYPosition(with yPosition: CGFloat) {
        self.yPosition = yPosition
    }

    func updateStartYPosition(with yPositon: CGFloat) {
        self.startYPosition = yPositon
    }
}

