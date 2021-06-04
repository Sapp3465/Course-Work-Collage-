//
//  ImageCollectioniewCell.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit

class ImageCollectioniewCell: UICollectionViewCell {

    private let activityIndicator = ActivityIndicator()
    private var _state: State = .normal
    var state: State {
        return _state
    }

    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override var safeAreaInsets: UIEdgeInsets {
        return .init(top: 3, left: 3, bottom: 3, right: 3)
    }

    //Mark: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        layoutViews()
    }

    //MARK: - LifeCycle

    override func prepareForReuse() {
        super.prepareForReuse()
        self.install(nil)
        self.activityIndicator.startAnimating()
    }

    func install(_ image: UIImage?) {
        self.clipsToBounds = true
        if let image = image {
            activityIndicator.stopAnimating()
            UIView.transition(with: imageView,
                              duration: 0.25,
                              options: .transitionCrossDissolve,
                              animations: { self.imageView.image = image },
                              completion: nil)
        } else {
            activityIndicator.startAnimating()
            self.imageView.image = nil
        }
    }

    func setState(_ state: State, animated: Bool = false) {
        self._state = state
        guard animated else {
            adjustAppearance()
            return
        }

        UIView.animate(withDuration: 0.2) {
            self.adjustAppearance()
        }
    }

    private func adjustAppearance() {
        self.backgroundColor = state.color
        self.layer.cornerRadius = state.cornerRadius
        self.imageView.layer.cornerRadius = state.cornerRadius
    }

}

// MARK: - Layout
extension ImageCollectioniewCell {

    private func layoutViews() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)

        imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        imageView.addSubview(activityIndicator)

        activityIndicator.topAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.topAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: imageView.safeAreaLayoutGuide.leadingAnchor).isActive = true
    }

}
