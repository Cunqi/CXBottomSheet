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
    
    public var hasReachedVisibleMaxStop: Bool {
        !stopContext.isHidden && stopContext.hasReachedMaxStop
    }
    
    public var hasReachedVisibleMinStop: Bool {
        !stopContext.isHidden && stopContext.hasReachedMinStop
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
    
    public var coordinator: CXBottomSheetCoordinatorProtocol {
        didSet {
            scrollContext = coordinator.scrollContext
        }
    }
    
    public var container: UIView {
        containerView
    }
    
    public weak var delegate: CXBottomSheetDelegate?
    
    // MARK: - Private properties
    
    private let contentController: CXBottomSheetContentController
    private let style: CXBottomSheetStyle
    private var scrollContext: CXBottomSheetScrollContext
    private var stopContext: CXBottomSheetStopContext
    
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
    
    private lazy var containerView: UIView = {
        let view = CXBottomSheetContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private var containerHeight: CGFloat {
        containerView.bounds.height
    }
    
    // MARK: - Private computed properties
    
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
    
    public init(content: CXBottomSheetContentProtocol?,
                style: CXBottomSheetStyle = CXBottomSheetDefaultStyle()) {
        self.style = style
        self.scrollContext = CXBottomSheetScrollContext(scrollSensitiveLevel: style.scrollSensitiveLevel)
        self.coordinator = CXBottomSheetDefaultCoordinator(scrollContext: scrollContext)
        self.contentController = CXBottomSheetContentController(with: content)
        self.stopContext = content?.stopContext ?? .default
        
        super.init(nibName: nil, bundle: nil)
        content?.bottomSheet = self
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycles
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstraints()
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
        content.saveStopContext(stopContext: stopContext)
        
        if let stopContext = content.stopContext {
            updateStopContext(stops: stopContext.stops, stop: stopContext.stop, animated: immediatelyInvalidate)
        }
    }
    
    public func popContent(immediatelyInvalidate: Bool) {
        defer { contentController.popContent() }
        if let previousStopContext = contentController.topContent?.loadStopContext() {
            updateStopContext(stops: previousStopContext.stops, stop: previousStopContext.stop, animated: immediatelyInvalidate)
        }
    }
    
    public func makeStop(contentHeight: CGFloat, isUpperBound: Bool) -> CXBottomSheetStop {
        makeStop(contentHeight: contentHeight, circutBreaker: nil, isUpperBound: isUpperBound)
    }
    
    public func makeStop(contentHeight: CGFloat, circutBreaker stop: CXBottomSheetStop?, isUpperBound: Bool) -> CXBottomSheetStop {
        let fixedStop = CXBottomSheetStop.fixed(contentHeight + topBarHeight).measured(with: containerHeight)
        guard let stop = stop?.measured(with: containerHeight) else {
            return fixedStop
        }
        return fixedStop <= stop ? fixedStop : stop
    }
    
    public func updateStopContext(stops: [CXBottomSheetStop], stop: CXBottomSheetStop?, animated: Bool) {
        stopContext.makeSnapshot(stops: stops, stop: stop, height: containerHeight)
        guard let stop else {
            return
        }
        move(to: stop, distinctMove: false)
    }
    
    public func move(to stop: CXBottomSheetStop, animated: Bool) {
        move(to: stop, distinctMove: true)
    }
    
    public func move(to stop: CXBottomSheetStop, animator: UIViewPropertyAnimator) {
        move(to: stop, distinctMove: true, animator: animator)
    }
    
    // MARK: - Private methods
    
    private func move(to stop: CXBottomSheetStop, distinctMove: Bool, animated: Bool = true, animator: UIViewPropertyAnimator? = nil) {
        guard stopContext.canMove(to: stop, distinct: distinctMove) else {
            return
        }
        animateStopMove(fromStop: currentStop, toStop: stop, animated: animated, animator: animator)
    }
    
    private func animateStopMove(fromStop: CXBottomSheetStop,
                                 toStop: CXBottomSheetStop,
                                 animated: Bool = true,
                                 animator: UIViewPropertyAnimator? = nil,
                                 isBouncingBack: Bool = false) {
        let finalHeight = toStop.height
        let shadowOpacity: Float = toStop == .closed ? 0 : 1
        let animations: CXBottomSheetAnimationsBlock = { [weak self] in
            self?.currentHeight = finalHeight
            self?.view.layer.shadowOpacity = shadowOpacity
            self?.view.superview?.layoutIfNeeded()
        }
        let completion: CXBottomSheetCompletionBlock = { [weak self] (_: Bool) in
            self?.completeAnimation(to: toStop, isBouncingBack: isBouncingBack)
        }
        
        let bottomSheetAnimator: CXBottomSheetAnimatorProtocol
        if let animator {
            bottomSheetAnimator = CXBottomSheetPropertyAnimator(propertyAnimator: animator)
        } else {
            bottomSheetAnimator = animated ? CXBottomSheetEaseInOutAnimator(duration: style.internal.animateDuration) :
            CXBottomSheetVoidAnimator()
        }
        
        invalidateStop(with: toStop)
        bottomSheetAnimator.animateMovement(animations: animations, completion: completion)
    }
    
    private func completeAnimation(to stop: CXBottomSheetStop, isBouncingBack: Bool) {
        guard isBouncingBack, currentStop == stop else {
            return
        }
        let scrollDirection = scrollContext.scrollDirection
        
        if hasReachedVisibleMaxStop, scrollDirection == .up {
            delegate?.bottomSheet(didBounceBack: self, toMaxStop: currentStop)
            contentController.topContent?.bottomSheet(didBounceBack: self, toMaxStop: currentStop)
        } else if hasReachedVisibleMinStop, scrollDirection == .down {
            delegate?.bottomSheet(didBounceBack: self, toMinStop: currentStop)
            contentController.topContent?.bottomSheet(didBounceBack: self, toMinStop: currentStop)
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
                stopContext: stopContext)
        case .changed:
            guard scrollContext.isBottomSheetInteractionEnabled else {
                scrollContext.updateStartYPosition(with: currentYPosition)
                return
            }
            scrollContext.updateYPosition(with: currentYPosition)
            currentHeight = scrollContext.makeFinalPanPosition()
        case .ended:
            let targetStop = scrollContext.fetchClosetStop(with: currentHeight)
            animateStopMove(
                fromStop: currentStop,
                toStop: targetStop,
                isBouncingBack: scrollContext.isBouncingBack(with: currentHeight))
        default:
            break
        }
    }
    
    private func invalidateStop(with stop: CXBottomSheetStop) {
        guard let invalidatedStop = stopContext.invalidate(with: stop) else {
            return
        }
        contentController.topContent?.bottomSheet(didMove: self, fromStop: invalidatedStop, toStop: stop)
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

// MARK: - UI modification methods

extension CXBottomSheetController {
    
    // MARK: - Properties
    
    private var isDarkMode: Bool {
        return traitCollection.userInterfaceStyle == .dark
    }
    
    // MARK: - Override methods
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        let shadowColor = isDarkMode ? nil : style.internal.shadowColor
        view.layer.shadowColor = shadowColor
    }
    
    // MARK: - Private methods
    
    private func setupViewsAndConstraints() {
        containerView.addSubview(view)
        
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
        view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(containerView)
        }
        
        NSLayoutConstraint.activate([topPositionConstraint])
    }
    
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
        let shadowColor = isDarkMode ? nil : style.internal.shadowColor
        
        view.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: style.internal.shadowRadius).cgPath
        view.layer.shadowOffset = style.internal.shadowOffset
        view.layer.shadowRadius = style.internal.shadowRadius
        view.layer.shadowColor = shadowColor
    }
    
}

// MARK: - CXBottomSheetContainerViewDelegate

extension CXBottomSheetController: CXBottomSheetContainerViewDelegate {
    func containerView(_ containerView: CXBottomSheetContainerView, sizeDidChangeTo size: CGSize) {
        stopContext.calibrate(with: containerHeight)
        move(to: stopContext.stop, distinctMove: false)
    }
}
