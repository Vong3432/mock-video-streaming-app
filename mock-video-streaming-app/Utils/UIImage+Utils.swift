//
//  UIImage+Utils.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 28/09/2023.
//

import Foundation
import UIKit

extension UIImageView{
    func asCircle(){
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
}
