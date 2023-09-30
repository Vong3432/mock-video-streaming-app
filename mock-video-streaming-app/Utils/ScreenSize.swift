//
//  UIScreen+Utils.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 30/09/2023.
//

import Foundation
import UIKit

/**
 Screen size
 https://stackoverflow.com/a/76728094
 */
extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
    
    static var currentSize: CGSize {
        current?.bounds.size ?? .zero
    }
}
