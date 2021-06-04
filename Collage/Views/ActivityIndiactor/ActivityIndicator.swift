//
//  ActivityIndicator.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/29/21.
//

import UIKit

class ActivityIndicator: UIActivityIndicatorView {

    init() {
        super.init(frame: .zero)
        self.style = .large
        self.hidesWhenStopped = true
        self.color = .blue
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
