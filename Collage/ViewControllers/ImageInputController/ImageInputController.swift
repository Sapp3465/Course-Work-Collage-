//
//  ImageInputController.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/29/21.
//

import UIKit

protocol ImageInputViewControllerDelegate: NSObject {

    func didSelect(_ images: [UIImage])

}

class ImageInputController: UINavigationController {

    private let imageInput: ImageInputViewController = .init()

    weak var inputDelegate: ImageInputViewControllerDelegate? {
        didSet {
            self.imageInput.delegate = inputDelegate
        }
    }

    init() {
        super.init(rootViewController: self.imageInput)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
