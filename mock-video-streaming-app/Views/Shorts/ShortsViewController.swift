//
//  ShortsViewController.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 22/09/2023.
//

import UIKit

class ShortsViewController: UIViewController {
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    private var shortsTableViewController: ShortsTableViewController = {
        let shortsTableViewController = ShortsTableViewController()
        return shortsTableViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupView()
        setupLayout()
    }
    
    private func setupDelegate() {
        shortsTableViewController.delegate = self
    }
    
    private func setupView() {
        navigationItem.title = Route.shorts.title
    }
    
    private func setupLayout() {
        // Table View
        addChild(shortsTableViewController)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        shortsTableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        shortsTableViewController.didMove(toParent: self)
        stackView.addArrangedSubview(shortsTableViewController.tableView)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0),
            stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0),
        ])
        
        // Loading Indicator
        view.addSubview(loadingIndicator)
        loadingIndicator.frame = CGRect(origin: .zero, size: CGSize(width: 47, height: 47))
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
    }
    
    private func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    private func removeLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
}

extension ShortsViewController: ShortsTableViewControllerDelegate {
    func shortsTable(_ shortsTableViewController: ShortsTableViewController, isFetching: Bool) {
        if isFetching {
            showLoadingIndicator()
        } else {
            removeLoadingIndicator()
        }
    }
}
