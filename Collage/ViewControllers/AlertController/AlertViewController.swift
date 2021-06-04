//
//  WarningViewController.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit

class AlertViewController: CollageViewController {

    private let roundndedView: UIView = {
        let view = RoundedView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private let warningImageView: UIImageView = UIImageView(image: ImageAssets.exclamationImage)
    private let warninglLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private let warningMessage: String
    private var actions: [AlertAction]

    //Mark: - Inits
    init(message: String, actions: [AlertAction]) {
        if actions.isEmpty {
            self.actions = [.init(priority: .normal, message: "Okay", action: nil)]
        } else {
            self.actions = actions
        }
        warningMessage = message
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.7)

        layoutViews()
        warninglLabel.text = warningMessage

    }

    @objc
    private func actionDidChoosed(_ sender: UIButton) {
        actions[sender.tag].action?()
        actions.removeAll()
        self.dismiss(animated: true, completion: nil)
    }

}

//Mark: - Layout
extension AlertViewController {

    private func layoutViews() {
        layoutWarningView()
    }

    private func layoutWarningView() {
        roundndedView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(roundndedView)
        
        roundndedView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        roundndedView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        roundndedView.widthAnchor.constraint(equalToConstant: 300).isActive = true

        let stackView = UIStackView(arrangedSubviews: [warningImageView, warninglLabel])
        stackView.alignment = .center
        stackView.spacing = 15

        let buttons: [UIButton] = actions.enumerated().map { (index, alertAction) in
            let button = Button(title: alertAction.message)
            button.tag = index
            switch alertAction.priority {
            case .hight:
                button.backgroundColor = .systemGreen
            case .normal:
                button.backgroundColor = .systemBlue
            case .low:
                button.backgroundColor = .systemRed
            }

            button.addTarget(self, action: #selector(actionDidChoosed(_:)), for: .touchUpInside)
            return button
        }

        let vStackView = UIStackView(arrangedSubviews: [stackView] + buttons)
        vStackView.axis = .vertical
        vStackView.spacing = 6
        vStackView.distribution = .fillProportionally
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        roundndedView.addSubview(vStackView)

        vStackView.topAnchor.constraint(equalTo: roundndedView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        vStackView.bottomAnchor.constraint(equalTo: roundndedView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        vStackView.leadingAnchor.constraint(equalTo: roundndedView.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        vStackView.trailingAnchor.constraint(equalTo: roundndedView.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true

        warningImageView.translatesAutoresizingMaskIntoConstraints = false
        warningImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        warningImageView.heightAnchor.constraint(equalTo: warningImageView.widthAnchor).isActive = true

    }

}

class Kek: UIPresentationController {

    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        containerView?.isUserInteractionEnabled = false
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(origin: .zero, size: CGSize(width: self.containerView?.frame.width ?? 0, height: 100))
    }

}
