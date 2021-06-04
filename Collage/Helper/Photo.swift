//
//  Photo.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/30/21.
//

import UIKit

    struct Photo {

        enum Orientation {
            case lanscape
            case portrait
        }

        let image: UIImage

        init(image: UIImage) {
            self.image = image
        }

        var size: CGSize {
            self.image.size
        }

        var orientation: Orientation {
            switch image.size.width / image.size.height {
            case ..<1:
                return .portrait
            default:
                return.lanscape
            }
        }

        var aspect: CGFloat {
            return image.size.width / image.size.height
        }

    }


extension Photo: CustomStringConvertible {

    var description: String {
        return "Photo: \(size), \(orientation), \(aspect)"
    }

}
