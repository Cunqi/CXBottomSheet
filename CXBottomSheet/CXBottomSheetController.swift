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
    
    public var maxStop: CXBottomSheetStop? {
        return stops.max { CXBottomSheetStop.compare(lhs: $0, rhs: $1, with: availableHeight) == .orderedAscending }
    }
    
    public var maxStopHeight: CGFloat {
        return maxStop?.makeHeight(with: availableHeight) ?? currentStopHeight
    }
    
    public var minStop: CXBottomSheetStop? {
        return stops.min { CXBottomSheetStop.compare(lhs: $0, rhs: $1, with: availableHeight) == .orderedAscending }
    }
    
    public var minStopHeight: CGFloat {
        return minStop?.makeHeight(with: availableHeight) ?? currentStopHeight
    }
    
    public private(set) var currentStop: CXBottomSheetStop = .closed
    
    public var currentStopHeight: CGFloat {
        currentStop.makeHeight(with: availableHeight)
    }
    
    public private(set) var stops: [CXBottomSheetStop]
    
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
    
    public weak var delegate: CXBottomSheetDelegate?
    
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
    
    private var contents: [CXBottomSheetContentProtocol] {
        contentController.viewControllers.compactMap { $0 as? CXBottomSheetContentProtocol }
    }
    
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
        self.stops = stops
        self.style = style
        self.delegate = delegate
        self.contentController = CXBottomSheetContentController(with: content)
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
        content.bottomSheet = self
        contentController.setViewControllers([content], animated: false)
    }
    
    public func pushContent(_ content: CXBottomSheetContentProtocol) {
        content.bottomSheet = self
        contentController.pushViewController(content, animated: true)
    }
    
    public func makeBottomSheetStop(contentHeight: CGFloat) -> CXBottomSheetStop {
        return .fixed(contentHeight + topBarHeight)
    }
    
    public func updateStops(_ stops: [CXBottomSheetStop], immediatelyMoveTo stop: CXBottomSheetStop?) {
        self.stops = stops
        move(to: stop, distinctMove: false)
    }
    
    public func move(to stop: CXBottomSheetStop?, animated: Bool) {
        move(to: stop, distinctMove: true, animated: animated)
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
        let finalStop = calibrateFinalStopIfNeeded(with: stop)
        let finalStopHeight = finalStop.makeHeight(with: availableHeight)
        let shadowOpacity: Float = CXBottomSheetStop.closed.value == finalStopHeight ? 0 : 1
        let animations = { [weak self] in
            guard let self = self else {
                return
            }
            self.currentHeight = finalStopHeight
            self.view.layer.shadowOpacity = shadowOpacity
            self.delegate?.bottomSheet(animateAlongWith: self, fromStop: self.currentStop, toStop: stop)
        }
        let completion = { [weak self] isFinished in
            if isFinished {
                self?.completeAnimation(to: finalStop, isBouncingBack: isBouncingBack)
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
            animations: { [weak self] in
                animations()
                self?.view.superview?.layoutIfNeeded()
            },
            completion: completion)
    }
    
    private func completeAnimation(to stop: CXBottomSheetStop, isBouncingBack: Bool) {
        guard isBouncingBack else {
            updateCurrentStop(to: stop)
            return
        }
        
        if currentStop == maxStop {
            delegate?.bottomSheet(didBounceBack: self, toMaxStop: currentStop)
        } else if currentStop == minStop {
            delegate?.bottomSheet(didBounceBack: self, toMinStop: currentStop)
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
        contents.forEach { $0.bottomSheet(didMove: self, fromStop: currentStop, toStop: stop) }
        currentStop = stop
    }
    
    private func isValidStop(_ stop: CXBottomSheetStop?) -> Bool {
        guard let stop = stop else {
            return false
        }
        return stop == .closed || stops.contains(stop)
    }
    
    private func move(to stop: CXBottomSheetStop?, distinctMove: Bool, animated: Bool = true) {
        guard let stop = stop, isValidStop(stop),
              !distinctMove || currentStop != stop else {
            return
        }
        executeStopChange(to: stop, animated: animated)
    }
    
    private func calibrateFinalStopIfNeeded(with stop: CXBottomSheetStop) -> CXBottomSheetStop {
        guard let maxStop = maxStop else {
            return stop
        }
        return CXBottomSheetStop.minStop(lhs: stop, rhs: maxStop, height: availableHeight)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension CXBottomSheetController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        return panGestureRecognizer.view is UIScrollView
    }
}

// MARK: - UIScrollViewDelegate

extension CXBottomSheetController: UIScrollViewDelegate {

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollContext.lastContentYOffset = scrollView.contentOffset.y
        scrollContext.isBottomSheetInteractionEnabled = false
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollContext.isBottomSheetInteractionEnabled = true
    }
}

