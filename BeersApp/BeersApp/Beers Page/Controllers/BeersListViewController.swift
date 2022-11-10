//
//  BeersListViewController.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 25/08/22.
//

import UIKit

class BeersListViewController: UITableViewController {

    var onRefresh: (() -> Void)?

    private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
        .init(tableView: tableView) { (tableView, index, controller) in
            controller.dataSource.tableView(tableView, cellForRowAt: index)
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        refresh()
    }

    private func configureTableView() {
        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource
    }

    @IBAction private func refresh() {
        onRefresh?()
    }

    func display(_ snapshot: NSDiffableDataSourceSnapshot<Int, CellController>) {
        dataSource.applySnapshotUsingReloadData(snapshot)
    }

    func display(_ viewModel: BeersLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, didSelectRowAt: indexPath)
    }

    private func cellController(at indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }
}
