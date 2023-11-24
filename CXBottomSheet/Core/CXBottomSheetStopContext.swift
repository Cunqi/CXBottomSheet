//
//  CXBottomSheetStopContext.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/24/23.
//

import Foundation

public struct CXBottomSheetStopContext {
    
    // MARK: - Public properties
    
    public var isHidden: Bool {
        stop == .closed
    }
    
    public var isReachedMaxStop: Bool {
        !isHidden && stop == maxStop
    }
    
    public var isReachedMinStop: Bool {
        !isHidden && stop == minStop
    }
    
    public var maxStop: CXBottomSheetStop {
        stops.last ?? stop
    }
    
    public var minStop: CXBottomSheetStop {
        stops.first ?? stop
    }

    public private(set) var stop: CXBottomSheetStop
    public private(set) var stops: [CXBottomSheetStop]
    
    // MARK: - Initializer
    
    public init(stops: [CXBottomSheetStop], stop: CXBottomSheetStop? = nil) {
        self.stops = stops
        self.stop = stop ?? .closed
    }
    
    // MARK: - Internal methods
    
    mutating func makeSnapshot(updatedStops: [CXBottomSheetStop]? = nil, with availableHeight: CGFloat) {
        stops = Self.calibrateAndSort(stops: updatedStops ?? stops, availableHeight: availableHeight)
    }
    
    mutating func invalidate(stop: CXBottomSheetStop) -> CXBottomSheetStop? {
        guard self.stop != stop else {
            return nil
        }
        let invalidatedStop = stop
        self.stop = stop
        return invalidatedStop
    }
    
    func canMove(to stop: CXBottomSheetStop, distinct: Bool) -> Bool {
        return isValidate(stop: stop) && (distinct || isCurrent(stop: stop))
    }
    
    func calibrate(stop: CXBottomSheetStop) -> CXBottomSheetStop {
        return stops.contains(stop) ? stop : maxStop
    }
    
    // MARK: - Private methods
    
    private func isValidate(stop: CXBottomSheetStop) -> Bool {
        return stop == .closed || stops.contains(stop)
    }
    
    private func isCurrent(stop: CXBottomSheetStop) -> Bool {
        return stop == stop
    }
    
    private static func calibrateAndSort(stops: [CXBottomSheetStop], availableHeight: CGFloat) -> [CXBottomSheetStop] {
        guard let upperBound = stops.last(where: { $0.isUpperBound }) else {
            return sort(stops: stops, with: availableHeight)
        }
        let upperBoundHeight = upperBound.makeHeight(with: availableHeight)
        let calibratedStops = stops.filter { $0.makeHeight(with: availableHeight) <= upperBoundHeight }
        return sort(stops: calibratedStops, with: availableHeight)
    }
    
    private static func sort(stops: [CXBottomSheetStop], with availableHeight: CGFloat) -> [CXBottomSheetStop] {
        return stops.sorted { CXBottomSheetStop.compare(lhs: $0, rhs: $1, with: availableHeight) == .orderedAscending }
    }
}

public extension CXBottomSheetStopContext {
    static var `default`: CXBottomSheetStopContext {
        CXBottomSheetStopContext(stops: [.closed])
    }
}
