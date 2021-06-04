//
//  CollageViewController.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/30/21.
//

import UIKit

protocol CollageViewControllerDelegate: AnyObject {

    func didPresentCollage()

}

class CollageViewController: ViewController {

    private let createButton: Button = .init(title: "+")
    private let imageHolderView: ImageView = ImageView()

    weak var imagePicker: ImageInputController?
    weak var delegate: CollageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()

        imageHolderView.contentMode = .scaleAspectFit
        imageHolderView.delegate = self
        createButton.addTarget(self, action: #selector(goToPicker), for: .touchUpInside)
        beginAppearanceTransition(true, animated: true)
    }

    @objc
    private func goToPicker() {
        createButton.animate()
        guard let imagePicker = imagePicker else {
            return
        }
        imagePicker.inputDelegate = self
        self.present(imagePicker, animated: true, completion: {
            self.createButton.stopAnimating()
        })
    }

    private func updateController(with collage: UIImage) {
        createButton.hide() {
            self.imageHolderView.image = collage
            self.delegate?.didPresentCollage()
        }
    }

    private func shareImage(_ image: UIImage, completion: @escaping () -> Void) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: completion)
    }

}

extension CollageViewController {

    private func layoutViews() {
        layoutView()
        layoutButton()
    }

    private func layoutView() {
        self.view.addSubview(imageHolderView)
        imageHolderView.translatesAutoresizingMaskIntoConstraints = false

        imageHolderView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        imageHolderView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        imageHolderView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        imageHolderView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    }

    private func layoutButton() {
        self.view.addSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false

        let radius: CGFloat = 35
        createButton.cornerRadius = radius
        createButton.heightAnchor.constraint(equalToConstant: 2 * radius).isActive = true
        createButton.widthAnchor.constraint(equalTo: createButton.heightAnchor).isActive = true

        createButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        createButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }

}

//Mark: - ImageViewDeledate
extension CollageViewController: ImageViewDeledate {

    func image(_ image: UIImage, completion: @escaping () -> Void) {
        self.shareImage(image, completion: completion)
    }

}

//Mark: - ImageInputViewControllerDelegate
extension CollageViewController: ImageInputViewControllerDelegate {

    func didSelect(_ images: [UIImage]) {
        createButton.animate()
        makeCollage(form: images,
                    desiredBounds: imageHolderView.bounds,
                    completion: updateController(with:))
    }

    private func makeCollage(form images: [UIImage],
                             desiredBounds: CGRect,
                             completion: @escaping (UIImage) -> Void) {

        DispatchQueue.global(qos: .background).async {
            
            let photos = images.map { Photo(image: $0) }
            
            typealias LayoutSpacing = (vertical: CGFloat, horisontal: CGFloat)
            
            let spacing: LayoutSpacing = (vertical: 5, horisontal: 5)
            
            var landscape = photos.filter { $0.orientation == .lanscape }.sorted(by: { $0.aspect > $1.aspect })
            var portrait  = photos.filter { $0.orientation == .portrait }.sorted(by: { $0.aspect > $1.aspect })
            
            DispatchQueue.main.async {
                var stacks: [UIStackView] = []
                
                pairChoosing: while true {
                    
                    var photos: [UIImage] = []
                    
                    for _ in 0...1 {
                        
                        
                        if !landscape.isEmpty && !portrait.isEmpty {
                            
                            if Bool.random() {
                                photos.append(landscape.removeFirst().image)
                            } else {
                                photos.append(portrait.removeFirst().image)
                            }
                            
                        } else if !landscape.isEmpty {
                            photos.append(landscape.removeFirst().image)
                            
                        } else if !portrait.isEmpty {
                            photos.append(portrait.removeFirst().image)
                        }
                        
                    }
                    let stack = UIStackView(arrangedSubviews: photos.map {
                        let imageView = UIImageView(image: $0)
                        imageView.contentMode = .scaleAspectFill
                        imageView.clipsToBounds = true
                        return imageView
                    })
                    stack.axis = .horizontal
                    stack.distribution = .fillProportionally
                    stack.spacing = spacing.horisontal
                    stacks.append(stack)
                    
                    
                    if landscape.isEmpty && portrait.isEmpty {
                        break pairChoosing
                    }
                }
                
                let mainStack = UIStackView(arrangedSubviews: stacks)
                mainStack.distribution = .fillProportionally
                mainStack.axis = .vertical
                mainStack.spacing = spacing.vertical
                
                mainStack.frame = self.imageHolderView.frame
                mainStack.bounds = self.imageHolderView.bounds
                let image = mainStack.imaged()
                
                
                completion(image)
            }
        }
    }
}
