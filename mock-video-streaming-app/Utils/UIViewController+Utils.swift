//
//  UIViewController+Utils.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 22/09/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func setTabBarItem(_ route: Route) -> Void {
        tabBarItem = UITabBarItem(
            title: route.title,
            image: route.icon,
            tag: route.tag
        )
    }
}
