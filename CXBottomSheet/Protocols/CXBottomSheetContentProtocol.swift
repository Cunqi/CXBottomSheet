//
//  CXBottomSheetContentProtocol.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/16/23.
//

import UIKit


/// Any pages which want to be rendered on bottom sheet should implement this protocol,
/// by implementing this protocol, you are able to interact with the bottom sheet
/// (e.g expand, collpase or hide the bottom sheet)
public protocol CXBottomSheetContentProtocol: UIViewController {

    
    /// instance of bottom sheet, use this property to inteact with bottom sheetm
    /// it is `CXBottomSheetProtocol`'s responsibility to setup the reference
    var bottomSheet: CXBottomSheetProtocol? { get set }
    
    /// As bottom sheet content, sometimes it needs to react with bottom sheet stop change, this
    /// delegate method provides a place to let content handle such changes.
    /// - Parameters:
    ///   - bottomSheet: an instance of `CXBottomSheetProtocol`
    ///   - fromStop: the previous bottom sheet stop
    ///   - toStop: the current bottom sheet stop
    func bottomSheet(didMove bottomSheet: CXBottomSheetProtocol,
                     fromStop: CXBottomSheetStop,
                     toStop: CXBottomSheetStop)
}

