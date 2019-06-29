//
//  SlideInPresentationController.swift
//  MedalCount
//
//  Created by Nitish Mishra on 5/24/19.
//  Copyright © 2019 Nitish Mishra. All rights reserved.
//

import UIKit

class SlideInPresentationController: UIPresentationController {

  private var direction: PresentationDirection
  private var height: CGFloat
  fileprivate var dimmingView: UIView!

  init(presentedViewController: UIViewController,
       presenting presentingViewController: UIViewController?,
       direction: PresentationDirection,
       height: CGFloat) {
    self.direction = direction
    self.height = height

    super.init(presentedViewController: presentedViewController,
               presenting: presentingViewController)
    setupDimmingView()
  }
  
  func setupDimmingView() {
    dimmingView = UIView()
    dimmingView.backgroundColor = .black
    dimmingView.translatesAutoresizingMaskIntoConstraints = false
    dimmingView.alpha = 0.0
  }
  
  override func presentationTransitionWillBegin() {

    containerView?.insertSubview(dimmingView, at: 0)

    NSLayoutConstraint.activate(
      NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                     options: [], metrics: nil, views: ["dimmingView": dimmingView!]))
    NSLayoutConstraint.activate(
      NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                     options: [], metrics: nil, views: ["dimmingView": dimmingView!]))

    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0.7
      return
    }
    
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 0.7
    })
  }

  override func dismissalTransitionWillBegin() {
    guard let coordinator = presentedViewController.transitionCoordinator else {
      dimmingView.alpha = 0.0
      return
    }
    
    coordinator.animate(alongsideTransition: { _ in
      self.dimmingView.alpha = 0.0
    })
  }

  override func containerViewWillLayoutSubviews() {
    presentedView?.frame = frameOfPresentedViewInContainerView
    presentedView?.layer.cornerRadius = 8
  }

  override func size(forChildContentContainer container: UIContentContainer,
                     withParentContainerSize parentSize: CGSize) -> CGSize {
    switch direction {
    case .left, .right:
      return CGSize(width: parentSize.width*(2.0/3.0), height: parentSize.height)
    case .bottom, .top:
      return CGSize(width: parentSize.width*(0.9), height: height)
    }
  }

  override var frameOfPresentedViewInContainerView: CGRect {

    var frame: CGRect = .zero
    frame.size = size(forChildContentContainer: presentedViewController,
                      withParentContainerSize: containerView!.bounds.size)

    switch direction {
    case .right:
      frame.origin.x = containerView!.frame.width*(1.0/3.0)
    case .bottom:
      frame.origin.y = containerView!.frame.height*(0.2)
      frame.origin.x = (containerView!.frame.width - frame.size.width) / 2
    default:
      frame.origin = .zero
    }
    
    return frame
  }

}
