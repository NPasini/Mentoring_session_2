//
//  LoadMoreCellController.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 30/08/22.
//

import UIKit

class LoadMoreCellController: NSObject, UITableViewDataSource, UITableViewDelegate {

    private let cell = LoadMoreCell()
    private let callback: () -> Void
    private var offsetObserver: NSKeyValueObservation?

    init(callback: @escaping () -> Void) {
        self.callback = callback
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadIfNeeded()

        offsetObserver = tableView.observe(\.contentOffset, options: .new) { [weak self] (tableView, _) in
            guard tableView.isDragging else { return }

            self?.reloadIfNeeded()
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        offsetObserver = nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadIfNeeded()
    }

    private func reloadIfNeeded() {
        guard !cell.isLoading else { return }

        callback()
    }
}

extension LoadMoreCellController: BeersLoadingView, BeersErrorView {

    func display(_ viewModel: BeersErrorViewModel) {
        cell.message = viewModel.message
    }

    func display(_ viewModel: BeersLoadingViewModel) {
        cell.isLoading = viewModel.isLoading
    }
}
