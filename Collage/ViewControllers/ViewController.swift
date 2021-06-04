//
//  ViewController.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }

    func showWarning(with text: String, actions: [AlertAction] = []) {
        let warningController = AlertViewController(message: text, actions: actions)
        warningController.modalPresentationStyle = .custom
        warningController.transitioningDelegate = self
        self.present(warningController, animated: true, completion: nil)
    }

}

//Mark: - UIViewControllerTransitioningDelegate
extension ViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return WarningMessageTransition(type: .show)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return WarningMessageTransition(type: .dismiss)
    }

}
