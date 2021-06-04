//
//  PHAsset.swift
//  Collage
//
//  Created by Сапбиєв Максим on 5/28/21.
//

import Photos

extension PHAsset {

    var size: CGSize {
        return CGSize(width: pixelWidth, height: pixelHeight)
    }

}
