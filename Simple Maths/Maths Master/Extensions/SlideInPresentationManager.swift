//
//  SlideInPresentationManager.swift
//  MedalCount
//
//  Created by Nitish Mishra on 5/24/19.
//  Copyright © 2019 Nitish Mishra. All rights reserved.
//


import UIKit

enum PresentationDirection: String {
  case bottom
  case top
  case right
  case left
}

class SlideInPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
  
  var direction = PresentationDirection.left
  
  var height: CGFloat = 400

  func presentationController(forPresented presented: UIViewController,
                              presenting: UIViewController?,
                              source: UIViewController) -> UIPresentationController? {
    let presentationController = SlideInPresentationController(presentedViewController: presented,
                                                               presenting: presenting,
                                                               direction: direction,
                                                               height: height)
    return presentationController
  }

  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController,
                           source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SlideInPresentationAnimator(direction: direction, isPresentation: true)
  }
  
  func animationController(forDismissed dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
      return SlideInPresentationAnimator(direction: direction, isPresentation: false)
  }

}
