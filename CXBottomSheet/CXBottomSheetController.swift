//
//  CXBottomSheetController.swift
//  CXBottomSheet
//
//  Created by Cunqi Xiao on 11/16/23.
//

import SnapKit
import UIKit

public class CXBottomSheetController: UIViewController, CXBottomSheetProtocol {

    // MARK: - Public properties
    
    public var isVisible: Bool {
        currentStop != .closed
    }
    
    public var isUserInteractionEnabled: Bool {
        get {
            scrollContext.isBottomSheetInteractionEnabled
        }
        set {
            scrollContext.isBottomSheetInteractionEnabled = newValue
        }
    }

    public var maxStop: CXBottomSheetStop? {
        return stops.max { CXBottomSheetStop.compare(lhs: $0, rhs: $1, with: availableHeight) == .orderedAscending }
    }

    public var minStop: CXBottomSheetStop? {
        return stops.min { CXBottomSheetStop.compare(lhs: $0, rhs: $1, with: availableHeight) == .orderedAscending }
    }

    public private(set) var currentStop: CXBottomSheetStop = .closed
    public private(set) var stops: [CXBottomSheetStop] = []
    
    public weak var delegate: CXBottomSheetDelegate?
    
    public lazy var coordinator: CXBottomSheetCoordinatorProtocol = {
        let coordinator = CXBottomSheetDefaultCoordinator(scrollContext: scrollContext)
        return coordinator
    }()
    
    // MARK: - Private properties

    private let scrollContext = CXBottomSheetScrollContext()
    private let contentController: CXBottomSheetContentController
    private let style: CXBottomSheetStyle

    // MARK: - Private lazy properties
    
    private lazy var gripBar: CXBottomSheetGripBar = {
        let view = CXBottomSheetGripBar(with: style.internal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = style.isGripBarHidden
        return view
    }()

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
        panGestureRecognizer.delegate = self
        return panGestureRecognizer
    }()

    private lazy var topPositionConstraint: NSLayoutConstraint = {
        view.topAnchor.constraint(equalTo: view.bottomAnchor)
    }()
    
    // MARK: - Private computed properties
    
    private var availableHeight: CGFloat {
        delegate?.bottomSheet(availableHeightFor: self) ?? .zero
    }

    private var currentHeight: CGFloat {
        get {
            -topPositionConstraint.constant
        }
        set {
            topPositionConstraint.constant = -newValue
        }
    }
    
    private var navigationBarHeight: CGFloat {
        contentController.isNavigationBarHidden ? 0 : contentController.navigationBar.frame.height
    }
    
    private var gripBarHeight: CGFloat {
        style.isGripBarHidden ? 0 : style.internal.gripBarSize.height + 2 * style.internal.gripBarVerticalPadding
    }
    
    private var topBarHeight: CGFloat {
        gripBarHeight + navigationBarHeight
    }

    // MARK: - Initializer
    
    public init(stops: [CXBottomSheetStop] = [],
                content: CXBottomSheetContentProtocol? = nil,
                style: CXBottomSheetStyle = CXBottomSheetDefaultStyle(),
                delegate: CXBottomSheetDelegate) {
        self.style = style
        self.delegate = delegate
        self.contentController = CXBottomSheetContentController(with: content)
        super.init(nibName: nil, bundle: nil)
        self.stops = Self.calibrateStopsIfNeeded(from: stops, availableHeight: availableHeight)
        content?.bottomSheet = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycles

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviewsAndConstraints()
        stylize()
    }

    // MARK: - Public methods

    public func setupContent(_ content: CXBottomSheetContentProtocol) {
        contentController.setViewControllers([content], animated: false)
        content.bottomSheet = self
    }

    public func pushContent(_ content: CXBottomSheetContentProtocol) {
        contentController.pushViewController(content, animated: true)
        content.bottomSheet = self
    }

    public func makeBottomSheetStop(contentHeight: CGFloat) -> CXBottomSheetStop {
        return .fixed(contentHeight + topBarHeight)
    }

    public func updateStops(_ stops: [CXBottomSheetStop], immediatelyMoveTo stop: CXBottomSheetStop?) {
        self.stops = Self.calibrateStopsIfNeeded(from: stops, availableHeight: availableHeight)
        guard let stop = stop else {
            return
        }
        move(to: stop, distinctMove: false)
    }

    public func move(to stop: CXBottomSheetStop, animated: Bool) {
        guard let calibratedStop = stops.contains(stop) ? stop : maxStop else {
            return
        }
        move(to: calibratedStop, distinctMove: true, animated: animated)
    }

    // MARK: - Private methods

    private func stylize() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = style.cornerRadius
        view.backgroundColor = style.backgroundColor
        view.addGestureRecognizer(panGestureRecognizer)
        applyShadow(to: view)
    }

    private func applyShadow(to view: UIView) {
        let rect = CGRect(
            x: view.frame.origin.x,
            y: view.frame.origin.y, 
            width: view.frame.width,
            height: style.internal.shadowFrameHeight)
        
        view.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: style.internal.shadowRadius).cgPath
        view.layer.shadowOffset = style.internal.shadowOffset
        view.layer.shadowColor = style.internal.shadowColor
        view.layer.shadowRadius = style.internal.shadowRadius
    }

    private func setupSubviewsAndConstraints() {
        view.addSubview(gripBar)
        addChild(contentController)
        view.addSubview(contentController.view)
        contentController.didMove(toParent: self)
        
        gripBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view)
            make.height.equalTo(view).priority(.high)
            make.height.lessThanOrEqualTo(gripBarHeight).priority(.required)
        }
        contentController.view.snp.makeConstraints { make in
            make.top.equalTo(gripBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view)
        }
        NSLayoutConstraint.activate([topPositionConstraint])
    }

    private func executeStopChange(to stop: CXBottomSheetStop, isBouncingBack: Bool = false, animated: Bool = true) {
        let finalStopHeight = stop.makeHeight(with: availableHeight)
        let shadowOpacity: Float = CXBottomSheetStop.closed.value == finalStopHeight ? 0 : 1
        let animations = { [weak self] in
            guard let self = self else {
                return
            }
            self.currentHeight = finalStopHeight
            self.view.layer.shadowOpacity = shadowOpacity
            self.delegate?.bottomSheet(animateAlongWith: self, fromStop: self.currentStop, toStop: stop)
            self.view.superview?.layoutIfNeeded()
        }
        let completion = { [weak self] isFinished in
            if isFinished {
                self?.completeAnimation(to: stop, isBouncingBack: isBouncingBack)
            }
        }
        
        guard animated else {
            animations()
            completion(true)
            return
        }
        
        UIView.animate(
            withDuration: style.internal.animateDuration,
            delay: style.internal.animateDelay,
            usingSpringWithDamping: style.internal.springDamping,
            initialSpringVelocity: style.internal.initialSpringVelocity,
            animations: animations,
            completion: completion)
    }
    
    private func completeAnimation(to stop: CXBottomSheetStop, isBouncingBack: Bool) {
        if !isBouncingBack {
            updateCurrentStop(to: stop)
        } else if currentStop == maxStop {
            delegate?.bottomSheet(didBounceBack: self, toMaxStop: currentStop)
        } else if currentStop == minStop {
            delegate?.bottomSheet(didBounceBack: self, toMinStop: currentStop)
        } else {
            updateCurrentStop(to: stop)
        }
    }

    @objc
    private func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        let currentYPosition = gestureRecognizer.translation(in: view).y
        switch gestureRecognizer.state {
        case .began:
            scrollContext.makeSnapshot(
                startYPosition: 0,
                currentHeight: currentHeight,
                availableHeight: availableHeight,
                stops: stops)
        case .changed:
            guard scrollContext.isBottomSheetInteractionEnabled else {
                scrollContext.updateStartYPosition(with: currentYPosition)
                return
            }
            scrollContext.updateYPosition(with: currentYPosition)
            currentHeight = scrollContext.makeFinalPanPosition()
        case .ended:
            let isBouncingBack = scrollContext.isBouncingBack(with: currentHeight)
            let targetStop = scrollContext.fetchClosetStop(with: currentHeight) ?? currentStop
            executeStopChange(to: targetStop, isBouncingBack: isBouncingBack)
        default:
            break
        }
    }

    private func updateCurrentStop(to stop: CXBottomSheetStop) {
        guard currentStop != stop else {
            return
        }
        contentController.contents.forEach { $0.bottomSheet(didMove: self, fromStop: currentStop, toStop: stop) }
        currentStop = stop
    }

    private func isValidStop(_ stop: CXBottomSheetStop) -> Bool {
        return stop == .closed || stops.contains(stop)
    }
    
    private func move(to stop: CXBottomSheetStop, distinctMove: Bool, animated: Bool = true) {
        guard isValidStop(stop),
              !distinctMove || currentStop != stop else {
            return
        }
        executeStopChange(to: stop, animated: animated)
    }
    
    private static func calibrateStopsIfNeeded(from stops: [CXBottomSheetStop], availableHeight: CGFloat) -> [CXBottomSheetStop] {
        guard let upperBound = stops.last(where: { $0.isUpperBound }) else {
            return stops
        }
        let upperBoundHeight = upperBound.makeHeight(with: availableHeight)
        let calibratedStops = stops.filter { $0.makeHeight(with: availableHeight) <= upperBoundHeight }
        return calibratedStops
    }
}

// MARK: - UIGestureRecognizerDelegate

extension CXBottomSheetController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        return coordinator.bottomSheetCoordinator(bottomSheet: self, shouldResponseToGestureEvent: panGestureRecognizer.view)
    }
}

// MARK: - UIScrollViewDelegate

extension CXBottomSheetController: UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        coordinator.bottomSheetCoordinator(bottomSheet: self, contentWillBeginDragging: scrollView)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        coordinator.bottomSheetCoordinator(bottomSheet: self, currentHeight: currentHeight, contentDidScroll: scrollView)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        coordinator.bottomSheetCoordinator(bottomSheet: self, contentDidEndScroll: scrollView)
    }
}

