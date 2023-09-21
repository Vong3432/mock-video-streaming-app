//
//  ViewController.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 22/09/2023.
//

import UIKit

class RootViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        let shortsViewController = ShortsViewController()
        let feedsViewController = FeedsViewController()
        let profileViewController = ProfileViewController()
        
        shortsViewController.setTabBarItem(.shorts)
        feedsViewController.setTabBarItem(.feeds)
        profileViewController.setTabBarItem(.profile)
        
        let shortsNavigationController = UINavigationController(
            rootViewController: shortsViewController
        )
        let feedsNavigationController = UINavigationController(
            rootViewController: feedsViewController
        )
        let profileNavigationController = UINavigationController(
            rootViewController: profileViewController
        )
        
        shortsNavigationController.navigationBar.prefersLargeTitles = true
        feedsNavigationController.navigationBar.prefersLargeTitles = true
        profileNavigationController.navigationBar.prefersLargeTitles = true
        
        viewControllers = [
            shortsNavigationController,
            feedsNavigationController,
            profileNavigationController
        ]
    }
}
