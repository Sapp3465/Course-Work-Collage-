//
//  UIView+extension.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import UIKit

extension UIView: Identifiable {
    
}

extension UIView {

    func imaged() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let capturedImage = renderer.image {
            (ctx) in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
        return capturedImage

    }

}
