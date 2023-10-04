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

typealias ShortsTableLoadDataCompletion = ((Result<Void, Error>)) -> Void

class ShortsTableViewController: UITableViewController {
    private var shorts = [Short]()
    private var isReloading = false
    weak var delegate: ShortsTableViewControllerDelegate?
    private lazy var dataSource: ShortsTableViewDiffableDataSource = {
        return UITableViewDiffableDataSource<ShortSection, Short>(tableView: tableView) { (tableView, indexPath, short) -> UITableViewCell in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ShortsTableViewCell.identifier, for: indexPath) as? ShortsTableViewCell
            else { return UITableViewCell() }
            cell.configure(with: ShortsTableViewCell.ViewModel(short: short))
            return cell
        }
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData { _ in }
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = ShortsTableView()
        tableView.register(ShortsTableViewCell.self, forCellReuseIdentifier: ShortsTableViewCell.identifier)
        configureRefreshControl()
        tableView.dataSource = dataSource
        updateTableSnapshot([])
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:
                                              #selector(handleRefreshControl),
                                              for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        // Start fetching
        tableView.refreshControl?.beginRefreshing()
        fetchData { _ in
            // Dismiss the refresh control.
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func fetchData(completion: @escaping ShortsTableLoadDataCompletion) {
        let shouldNotifyDelegate = tableView.refreshControl?.isRefreshing == false
        if shouldNotifyDelegate {
            delegate?.shortsTable(self, isFetching: true)
        }
        // mock
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            DispatchQueue.main.async {
                self.delegate?.shortsTable(self, isFetching: false)
                self.updateTableSnapshot(Short.mocks)
                completion(.success(Void()))
            }
        }
    }
    
    private func updateTableSnapshot(_ shots: [Short]) {
        var snapshot = NSDiffableDataSourceSnapshot<ShortSection, Short>()
        snapshot.appendSections([.main])
        snapshot.appendItems(shots, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /**
     https://stackoverflow.com/a/29793097
     **/
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for visibleCell in tableView.visibleCells {
            guard let indexPath = tableView.indexPath(for: visibleCell), let shortTableCell = visibleCell as? ShortsTableViewCell else { return }
            let cellRect = tableView.rectForRow(at: indexPath)
            if let superview = tableView.superview {
                let convertedRect = tableView.convert(cellRect, to: superview)
                let intersect = CGRectIntersection(tableView.frame, convertedRect)
                let visibleHeight = CGRectGetHeight(intersect)
                let cellHeight = CGRectGetHeight(cellRect)
                let ratio = visibleHeight / cellHeight
                if ratio > 0.75 {
                    shortTableCell.playVideo()
                } else {
                    shortTableCell.stopVideo()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let shortTableCell = cell as? ShortsTableViewCell else { return }
        shortTableCell.stopVideo()
    }
}

extension ShortsTableViewController {
    enum ShortSection: Hashable {
        case main
    }
    
    typealias ShortsTableViewDiffableDataSource = UITableViewDiffableDataSource<ShortSection, Short>
}
