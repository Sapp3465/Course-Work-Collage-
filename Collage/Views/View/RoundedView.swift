//
//  RoundedView.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/29/21.
//

import UIKit

class RoundedView: UIView {

    internal var cornerRadius: CGFloat {
        return 20
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let mask = CAShapeLayer()
        mask.path = bPath.cgPath
        self.layer.mask = mask
    }

}
