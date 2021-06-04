//
//  Button.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/29/21.
//

import UIKit

class Button: UIButton {

    private var title: String?
    private var image: UIImage?
    private(set) var condition: Condition = .activated
    private let activityIndicator: ActivityIndicator = ActivityIndicator()

    var cornerRadius: CGFloat = 5
    var activatedColor: UIColor? = .systemBlue {
        didSet {
            if condition == .activated {
                self.backgroundColor = activatedColor
            }
        }
    }
    var disablesColor: UIColor? = .systemGray3{
        didSet {
            if condition == .disabled {
                self.backgroundColor = disablesColor
            }
        }
    }

    //Mark: - Inits
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        commonInit()
    }

    init(image: UIImage) {
        self.image = image
        super.init(frame: .zero)
        setImage(image, for: .normal)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        layer.cornerRadius = 5
        backgroundColor = activatedColor
        contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)

        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    //Mark: - LifeCycle
    private func disable() {
        self.isUserInteractionEnabled = false
    }

    private func activete() {
        self.isUserInteractionEnabled = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
    }

    func animate() {
        bring(to: .disabled)
        self.setTitle(nil, for: .normal)
        self.setImage(nil, for: .normal)
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        bring(to: .activated)
        activityIndicator.stopAnimating()
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
    }

    func hide(completion: @escaping (() -> Void) = {}) {
        disable()
        changeOpacity(to: 0, completion: {
            completion()
            self.isHidden = true
        })
    }

    func show(completion: @escaping (() -> Void) = {}) {
        isHidden = false
        changeOpacity(to: 1, completion: {
            completion()
            self.activete()
        })
    }

    private func changeOpacity(to value: CGFloat, completion: @escaping (() -> Void) = {}) {
        UIView.animate(withDuration: 0.8) {
            self.alpha = value
        } completion: { _ in
            completion()
        }
    }

}

extension Button {

    func bring(to condition: Condition) {
        guard self.condition != condition else {
            return
        }
        self.condition = condition

        UIView.animate(withDuration: 0.4) {
            if condition == .disabled {
                self.disable()
                self.backgroundColor = self.disablesColor
            } else {
                self.activete()
                self.backgroundColor = self.activatedColor
            }
        }
    }

}

extension Button {

    enum Condition {
        case activated
        case disabled

        func toggled() -> Condition {
            return self == .activated ? .disabled : .activated
        }
    }

}
