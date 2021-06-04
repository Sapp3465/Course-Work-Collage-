//
//  ImageAssets.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit

fileprivate extension UIImage {

    static func unsafeSystemImage(with name: String) -> UIImage {
        guard let image = UIImage(systemName: name) else {
            fatalError("Unable to find image with system name: \(name)")
        }
        return image
    }

}

struct ImageAssets {

    private init() {}

    static var exclamationImage: UIImage {
        let image: UIImage = .unsafeSystemImage(with: "exclamationmark.circle")
        return image.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
    }


    static var shareImage: UIImage {
        let image: UIImage = .unsafeSystemImage(with: "square.and.arrow.up")
        return image.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    }

}
