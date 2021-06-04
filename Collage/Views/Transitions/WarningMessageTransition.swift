//
//  WarningMessageTransition.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/29/21.
//

import UIKit

class WarningMessageTransition: NSObject, UIViewControllerAnimatedTransitioning {

    enum AnimationType {
        case show
        case dismiss
    }

    private let animationType: AnimationType
    private let animationDuration: TimeInterval = 0.35

    init(type: AnimationType) {
        self.animationType = type
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(true)
            return
        }

        if animationType == .show {
            let containerView = transitionContext.containerView
            toVC.view.alpha = 0
            containerView.addSubview(toVC.view)

            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseIn) {

                toVC.view.alpha = 1
            } completion: { (success) in
                transitionContext.completeTransition(success)
            }
        } else {
            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseIn) {
                fromVC.view.alpha = 0
            } completion: { (success) in
                transitionContext.completeTransition(success)
            }
        }

    }

}
