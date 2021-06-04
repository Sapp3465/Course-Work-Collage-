//
//  ImageView.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/30/21.
//

import UIKit

protocol ImageViewDeledate: AnyObject {

    func image(_ image: UIImage, completion: @escaping () -> Void)

}

class ImageView: UIImageView {

    private enum State {

        case active
        case notactive
        case animating

    }

    private var state: State = .notactive
    private lazy var button: Button = {
        let button = Button(image: ImageAssets.shareImage)
        button.alpha = 0
        button.isHidden = true
        return button
    } ()
    weak var delegate: ImageViewDeledate?

    init() {
        super.init(frame: .zero)
        commomInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commomInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commomInit() {
        isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
        tapGR.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGR)

        button.activatedColor = button.activatedColor?.withAlphaComponent(0.9)
        button.disablesColor = button.disablesColor?.withAlphaComponent(0.9)
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        let radius: CGFloat = 35
        button.cornerRadius = radius
        button.heightAnchor.constraint(equalToConstant: 2 * radius).isActive = true
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true

        button.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true

        button.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
    }

    @objc
    private func shareImage() {

        guard let image = image,
              self.state != .animating else {
            return
        }
        self.button.animate()
        delegate?.image(image, completion: {
            self.button.stopAnimating()
        })
    }

    @objc
    private func imageTapped() {

        guard let _ = image,
              self.state != .animating else {
            return
        }

        if state == .active {
            state = .animating
            button.hide() {
                self.state = .notactive
            }
        } else if state == .notactive {
            state = .animating
            button.show() {
                self.state = .active
            }
        }
    }

}
