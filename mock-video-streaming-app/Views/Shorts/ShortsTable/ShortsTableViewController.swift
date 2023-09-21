//
//  ShortsTableViewController.swift
//  mock-video-streaming-app
//
//  Created by Vong Nyuk Soon on 22/09/2023.
//

import UIKit

/**
 https://medium.com/my-ios-studies-en/first-steps-with-uitableviewdiffabledatasource-part-1-a70f12dfd5c9
 **/


protocol ShortsTableViewControllerDelegate: AnyObject {
    func shortsTable(_ shortsTableViewController: ShortsTableViewController, isFetching: Bool) -> Void
}

class ShortsTableViewController: UITableViewController {
    private var shorts = [Short]()
    weak var delegate: ShortsTableViewControllerDelegate?
    private lazy var dataSource: ShortsTableViewDiffableDataSource = {
        return UITableViewDiffableDataSource<ShortSection, Short>(tableView: tableView) { (tableView, indexPath, short) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShortsTableViewCell.identifier, for: indexPath) as? ShortsTableViewCell
            else { return UITableViewCell() }
            var content = cell.defaultContentConfiguration()
            content.text = short.title
            cell.contentConfiguration = content
            return cell
        }
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = ShortsTableView()
        tableView.register(ShortsTableViewCell.self, forCellReuseIdentifier: ShortsTableViewCell.identifier)
        tableView.dataSource = dataSource
        updateTableSnapshot([])
    }
    
    private func fetchData() {
        delegate?.shortsTable(self, isFetching: true)
        // mock
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async {
                self.delegate?.shortsTable(self, isFetching: false)
                self.updateTableSnapshot(Short.mocks)
            }
        }
    }
    
    private func updateTableSnapshot(_ shots: [Short]) {
        var snapshot = NSDiffableDataSourceSnapshot<ShortSection, Short>()
        snapshot.appendSections([.main])
        snapshot.appendItems(shots, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

extension ShortsTableViewController {
    enum ShortSection: Hashable {
        case main
    }
    
    typealias ShortsTableViewDiffableDataSource = UITableViewDiffableDataSource<ShortSection, Short>
}
