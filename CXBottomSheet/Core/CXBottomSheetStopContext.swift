//
//  CXBottomSheetStopContext.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/24/23.
//

import Foundation

public class CXBottomSheetStopContext {
    
    // MARK: - Public properties
    
    public var isHidden: Bool {
        stop == .closed
    }
    
    public var maxStop: CXBottomSheetStop {
        stops.last ?? stop
    }
    
    public var minStop: CXBottomSheetStop {
        stops.first ?? stop
    }
    
    /// Please consider to combine `hasReachedMaxStop` with `isHidden` to make sure bottom sheet reaches the visible
    /// max stop
    public var hasReachedMaxStop: Bool {
        maxStop == stop
    }
    
    /// Please consider to combine `hasReachedMinStop` with `isHidden` to make sure bottom sheet reaches the visible
    /// min stop
    public var hasReachedMinStop: Bool {
        minStop == stop
    }

    public private(set) var stop: CXBottomSheetStop
    public private(set) var stops: [CXBottomSheetStop]
    
    // MARK: - Initializer
    
    public init(stops: [CXBottomSheetStop], stop: CXBottomSheetStop? = nil) {
        self.stops = stops
        self.stop = stop ?? .closed
    }
    
    // MARK: - Internal methods
    
    func makeSnapshot(stops: [CXBottomSheetStop], stop: CXBottomSheetStop?, height: CGFloat) {
        self.stops = stops
        self.stop = stop ?? self.stop
        calibrate(with: height)
    }
    
    /// Calibrate current stop context with provided height, all stops in the context will be measured and sorted
    /// with the calculated run-time height
    /// - Parameter height: height for measuring bottomn sheet stops
    func calibrate(with height: CGFloat) {
        stop = stop.measured(with: height)
        stops = stops.map { $0.measured(with: height) }.sorted()
        // Filter out invalid stops if needed as we might have 
        if let upperBoundIndex = stops.firstIndex(where: { $0.isUpperBound == true }) {
            stops = Array(stops[0 ... upperBoundIndex])
        }
    }
    
    /// Invalidate current stop with a new stop, if the stops are same, then the operation will be ignored,
    /// otherwise, the invalidated stop will be populated
    /// - Parameter stop: new bottom sheet stop for current
    /// - Returns: the invalidated bottom sheet
    func invalidate(with stop: CXBottomSheetStop) -> CXBottomSheetStop? {
        guard self.stop != stop else {
            return nil
        }
        defer { self.stop = stop }
        return self.stop
    }
    
    /// Check if bottom sheet can move to given stop, a bottom sheet stop is considered valid
    /// for moving only 1. it is in the stop context `stops`, or it is `closed`
    /// - Parameters:
    ///   - stop: A stop that bottom sheet wants to move to
    ///   - distinct: if it is a distinct move, then the check of comparing given stop with current stop can be waived
    /// - Returns: if it is valid to move to given stop
    func canMove(to stop: CXBottomSheetStop, distinct: Bool = true) -> Bool {
        return isValidate(stop: stop) && (!distinct || (self.stop != stop))
    }
    
    // MARK: - Private methods
    
    private func isValidate(stop: CXBottomSheetStop) -> Bool {
        return stop == .closed || stops.contains(stop)
    }
}

public extension CXBottomSheetStopContext {
    static var `default`: CXBottomSheetStopContext {
        CXBottomSheetStopContext(stops: [.closed])
    }
}
