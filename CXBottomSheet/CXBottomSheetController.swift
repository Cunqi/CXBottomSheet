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
    
    public var isHidden: Bool {
        stopContext.isHidden
    }
    
    public var hasReachedMaxStop: Bool {
        stopContext.isReachedMaxStop
    }
    
    public var hasReachedMinStop: Bool {
        stopContext.isReachedMinStop
    }
    
    public var maxStop: CXBottomSheetStop {
        return stopContext.maxStop
    }
    
    public var minStop: CXBottomSheetStop {
        return stopContext.minStop
    }
    
    public var stops: [CXBottomSheetStop] {
        stopContext.stops
    }
    
    public var currentStop: CXBottomSheetStop {
        stopContext.stop
    }
    
    public var isUserInteractionEnabled: Bool {
        get {
            scrollContext.isBottomSheetInteractionEnabled
        }
        set {
            scrollContext.isBottomSheetInteractionEnabled = newValue
        }
    }
    
    public private(set) var stopContext: CXBottomSheetStopContext
    
    public weak var delegate: CXBottomSheetDelegate?
    
    public lazy var coordinator: CXBottomSheetCoordinatorProtocol = {
        let coordinator = CXBottomSheetDefaultCoordinator(scrollContext: scrollContext)
        return coordinator
    }()
    
    // MARK: - Private properties
    
    private let scrollContext: CXBottomSheetScrollContext
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
    
    public convenience init(style: CXBottomSheetStyle = CXBottomSheetDefaultStyle(),
                            stopContext: CXBottomSheetStopContext = .default,
                            delegate: CXBottomSheetDelegate) {
        self.init(content: nil, style: style, stopContext: stopContext, delegate: delegate)
    }
    
    public convenience init(content: CXBottomSheetContentProtocol?,
                            style: CXBottomSheetStyle = CXBottomSheetDefaultStyle(),
                            delegate: CXBottomSheetDelegate) {
        self.init(content: content, style: style, stopContext: content?.stopContext ?? .default, delegate: delegate)
    }
    
    public convenience init(content: CXBottomSheetContentProtocol?,
                            stopContext: CXBottomSheetStopContext,
                            delegate: CXBottomSheetDelegate) {
        self.init(content: content, style: CXBottomSheetDefaultStyle(), stopContext: stopContext, delegate: delegate)
    }
    
    public init(content: CXBottomSheetContentProtocol?,
                style: CXBottomSheetStyle,
                stopContext: CXBottomSheetStopContext,
                delegate: CXBottomSheetDelegate) {
        self.style = style
        self.scrollContext = CXBottomSheetScrollContext(scrollSensitiveLevel: style.scrollSensitiveLevel)
        self.delegate = delegate
        self.contentController = CXBottomSheetContentController(with: content)
        self.stopContext = stopContext
        super.init(nibName: nil, bundle: nil)
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
        stopContext = content.stopContext ?? stopContext
    }
    
    public func pushContent(_ content: CXBottomSheetContentProtocol, immediatelyInvalidate: Bool) {
        contentController.pushViewController(content, animated: false)
        content.bottomSheet = self
        
        if let stopContext = content.stopContext {
            updateStops(stopContext.stops, moveTo: stopContext.stop, immediately: immediatelyInvalidate)
        } else if immediatelyInvalidate {
            invalidate(animated: true)
        }
    }
    
    public func popContent(immediatelyInvalidate: Bool) {
        defer { contentController.popContent() }
        if let previousStopContext = contentController.topContent?.loadStopContext() {
            updateStops(previousStopContext.stops, moveTo: previousStopContext.stop, immediately: immediatelyInvalidate)
        } else {
            invalidate(animated: true)
        }
    }
    
    public func makeBottomSheetStop(contentHeight: CGFloat, isUpperBound: Bool) -> CXBottomSheetStop {
        makeBottomSheetStop(contentHeight: contentHeight, circutBreaker: nil, isUpperBound: isUpperBound)
    }
    
    public func makeBottomSheetStop(contentHeight: CGFloat, circutBreaker stop: CXBottomSheetStop?, isUpperBound: Bool) -> CXBottomSheetStop {
        let fixedHeightStop = CXBottomSheetStop.fixed(contentHeight + topBarHeight)
        guard let circutBreakerStop = stop else {
            return fixedHeightStop
        }
        return fixedHeightStop.makeHeight(with: availableHeight) <= circutBreakerStop.makeHeight(with: availableHeight) ? fixedHeightStop : circutBreakerStop
    }
    
    public func updateStops(_ stops: [CXBottomSheetStop], immediatelyMoveTo stop: CXBottomSheetStop?) {
        updateStops(stops, moveTo: stop, immediately: true)
    }
    
    public func updateStops(_ stops: [CXBottomSheetStop], moveTo stop: CXBottomSheetStop?, immediately: Bool) {
        stopContext.makeSnapshot(updatedStops: stops, with: availableHeight)
        guard let stop = stop else {
            return
        }
        
        if immediately {
            move(to: stop, distinctMove: false)
        } else {
            updateCurrentStop(to: stop)
        }
    }
    
    public func move(to stop: CXBottomSheetStop, animated: Bool) {
        move(to: stopContext.calibrate(stop: stop), distinctMove: true, animated: animated)
    }
    
    public func move(to stop: CXBottomSheetStop, animator: UIViewPropertyAnimator) {
        move(to: stopContext.calibrate(stop: stop), distinctMove: true, animated: true, animator: animator)
    }
    
    public func invalidate(animated: Bool) {
        guard !isHidden else {
            return
        }
        stopContext.makeSnapshot(with: availableHeight)
        move(to: currentStop, distinctMove: false, animated: animated)
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
    
    private func executeStopChange(to stop: CXBottomSheetStop,
                                   isBouncingBack: Bool = false,
                                   animated: Bool = true,
                                   animator: UIViewPropertyAnimator? = nil) {
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
        let completion = { [weak self] in
            self?.completeAnimation(to: stop, isBouncingBack: isBouncingBack)
        }
        
        if !animated {
            animations()
            completion()
        } else if let animator = animator {
            animator.addAnimations(animations)
            animator.addCompletion { _ in
                completion()
            }
            animator.startAnimation()
        } else {
            UIView.animate(
                withDuration: style.internal.animateDuration,
                delay: style.internal.animateDelay,
                usingSpringWithDamping: style.internal.springDamping,
                initialSpringVelocity: style.internal.initialSpringVelocity,
                animations: animations,
                completion: { isFinished in
                    if isFinished {
                        completion()
                    }
                })
        }
    }
    
    private func completeAnimation(to stop: CXBottomSheetStop, isBouncingBack: Bool) {
        let stopNotUpdated = currentStop == stop
        let isScrollingUp = scrollContext.scrollDirection == .up
        let isScrollingDown = scrollContext.scrollDirection == .down
        if !isBouncingBack {
            updateCurrentStop(to: stop)
        } else if stopNotUpdated, hasReachedMaxStop, isBouncingBack, isScrollingUp {
            delegate?.bottomSheet(didBounceBack: self, toMaxStop: currentStop)
            contentController.topContent?.bottomSheet(didBounceBack: self, toMaxStop: currentStop)
        } else if stopNotUpdated, hasReachedMinStop, isBouncingBack, isScrollingDown {
            delegate?.bottomSheet(didBounceBack: self, toMinStop: currentStop)
            contentController.topContent?.bottomSheet(didBounceBack: self, toMinStop: currentStop)
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
                stopContext: stopContext)
        case .changed:
            guard scrollContext.isBottomSheetInteractionEnabled else {
                scrollContext.updateStartYPosition(with: currentYPosition)
                return
            }
            scrollContext.updateYPosition(with: currentYPosition)
            currentHeight = scrollContext.makeFinalPanPosition()
        case .ended:
            let isBouncingBack = scrollContext.isBouncingBack(with: currentHeight)
            let targetStop = scrollContext.fetchClosetStop(with: currentHeight)
            executeStopChange(to: targetStop, isBouncingBack: isBouncingBack)
        default:
            break
        }
    }
    
    private func updateCurrentStop(to stop: CXBottomSheetStop) {
        guard let invalidatedStop = stopContext.invalidate(stop: stop) else {
            return
        }
        contentController.topContent?.bottomSheet(didMove: self, fromStop: invalidatedStop, toStop: stop)
    }
    
    private func move(to stop: CXBottomSheetStop, distinctMove: Bool, animated: Bool = true, animator: UIViewPropertyAnimator? = nil) {
        guard stopContext.canMove(to: stop, distinct: distinctMove) else {
            return
        }
        executeStopChange(to: stop, animated: animated, animator: animator)
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

