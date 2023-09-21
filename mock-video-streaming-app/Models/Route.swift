//
//  Route.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 22/09/2023.
//

import Foundation
import UIKit

enum Route {
    case shorts, feeds, profile
    var title: String {
        switch self {
        case .shorts:
            return "Shorts"
        case .feeds:
            return "Feeds"
        case .profile:
            return "Profile"
        }
    }
    var icon: UIImage {
        switch self {
        case .shorts:
            return UIImage(systemName: "video")!
        case .feeds:
            return UIImage(systemName: "newspaper")!
        case .profile:
            return UIImage(systemName: "person.crop.circle")!
        }
    }
    var tag: Int {
        switch self {
        case .shorts:
            return 0
        case .feeds:
            return 1
        case .profile:
            return 2
        }
    }
}
