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

    public var maxStop: CXBottomSheetStop? {
        let availableHeight = availableHeight // Data consistency
        return stops.max { $0.makeHeight(with: availableHeight) < $1.makeHeight(with: availableHeight) }
    }

    public var minStop: CXBottomSheetStop? {
        let availableHeight = availableHeight
        return stops.min { $0.makeHeight(with: availableHeight) < $1.makeHeight(with: availableHeight) }
    }

    public private(set) var currentStop: CXBottomSheetStop = .closed

    public private(set) var stops: [CXBottomSheetStop]
    
    public weak var delegate: CXBottomSheetDelegate?
    
    // MARK: - Private properties

    private let scrollContext = CXBottomSheetScrollContext()
    
    private let style: CXBottomSheetStyle

    // MARK: - Private lazy properties
    
    private lazy var gripBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = style.internal.gripBarSize.height / 2.0
        view.backgroundColor = style.internal.gripBarColor
        return view
    }()

    private lazy var contentController: UINavigationController = {
        let controller = UINavigationController()
        controller.navigationBar.barTintColor = .systemBackground
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.isNavigationBarHidden = true
        return controller
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
    
    private var topBarHeight: CGFloat {
        let gripBarHeight = style.isGripBarHidden ? 0 : style.internal.gripBarSize.height
        return gripBarHeight + navigationBarHeight
    }

    // MARK: - Initializer

    public init(stops: [CXBottomSheetStop] = [],
                style: CXBottomSheetStyle = CXBottomSheetDefaultStyle(),
                delegate: CXBottomSheetDelegate) {
        self.stops = stops
        self.style = style
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
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

    public func move(to stop: CXBottomSheetStop?) {
        move(to: stop, distinctMove: true)
    }

    // MARK: - Private methods

    private func stylize() {
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
            make.size.equalTo(style.isGripBarHidden ? .zero : style.internal.gripBarSize)
            make.top.equalTo(view).inset(style.isGripBarHidden ? 0 : style.internal.gripBarVerticalPadding)
            make.centerX.equalTo(view)
        }
        
        contentController.view.snp.makeConstraints { make in
            make.top.equalTo(gripBar.snp.bottom).inset(style.isGripBarHidden ? 0 : style.internal.gripBarVerticalPadding)
            make.leading.trailing.bottom.equalTo(view)
        }
    }

    private func animateStopChange(to stop: CXBottomSheetStop) {
        let finalHeight = stop.makeHeight(with: availableHeight)
        let shadowOpacity: Float = CXBottomSheetStop.closed.value == finalHeight ? 0 : 1
        UIView.animate(
            withDuration: style.internal.animateDuration,
            delay: style.internal.animateDelay,
            usingSpringWithDamping: style.internal.springDamping,
            initialSpringVelocity: style.internal.initialSpringVelocity,
            animations: { [weak self] in
                self?.currentHeight = finalHeight
                self?.view.layer.shadowOpacity = shadowOpacity
                self?.view.superview?.layoutIfNeeded()
            }, completion: { [weak self] isFinished in
                if isFinished {
                    self?.updateCurrentStop(to: stop)
                }
            })
    }

    private func panBottomSheet(to stop: CXBottomSheetStop) {
        animateStopChange(to: stop)
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
            let targetStop = scrollContext.fetchClosetStop(with: currentHeight) ?? currentStop
            panBottomSheet(to: targetStop)
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
    
    private func move(to stop: CXBottomSheetStop?, distinctMove: Bool) {
        guard let stop = stop, isValidStop(stop),
              !distinctMove || currentStop != stop else {
            return
        }
        animateStopChange(to: stop)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension CXBottomSheetController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        return panGestureRecognizer.view is UICollectionView
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

