//
//  UIImage+Utils.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 30/09/2023.
//

import Foundation
import UIKit

extension UIImage {
    /// Downsamping by resizes the image by keeping the aspect ratio
    /// https://stackoverflow.com/a/72378919
    func resize(newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            /// draw center
            /// https://stackoverflow.com/a/65405933
            let hScale = newSize.height / size.height
            let vScale = newSize.width / size.width
            let scale = max(hScale, vScale) // scaleToFill
            let resizeSize = CGSize(width: size.width*scale, height: size.height*scale)
            var middle = CGPoint.zero
            if resizeSize.width > newSize.width {
                middle.x -= (resizeSize.width-newSize.width)/2.0
            }
            if resizeSize.height > newSize.height {
                middle.y -= (resizeSize.height-newSize.height)/2.0
            }
            self.draw(in: CGRect(origin: middle, size: resizeSize))
        }
    }
}
