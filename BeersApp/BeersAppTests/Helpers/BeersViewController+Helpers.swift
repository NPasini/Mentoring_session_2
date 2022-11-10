//
//  BeersViewController+Helpers.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 26/08/22.
//

import UIKit
@testable import BeersApp

extension BeersViewController {

    private var beersSection: Int { 0 }
    private var beersLoadMoreSection: Int { 1 }

    var isShowingLoadingIndicator: Bool {
        listViewController.refreshControl?.isRefreshing == true
    }

    var numberOfRenderedBeerViews: Int {
        numberOfRows(in: beersSection)
    }

    var errorMessage: String? {
        errorView?.message
    }

    var isShowingLoadMoreBeersIndicator: Bool {
        loadMoreBeersCell()?.isLoading == true
    }

    var loadMoreBeersErrorMessage: String? {
        loadMoreBeersCell()?.message
    }

    var canLoadMoreBeers: Bool {
        loadMoreBeersCell() != nil
    }

    private var tableView: UITableView {
        listViewController.tableView
    }

    func simulateUserInitiatedReload() {
        listViewController.refreshControl?.simulatePullToRefresh()
    }

    func simulateLoadMoreBeersAction() {
        guard let view = loadMoreBeersCell() else { return }

        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: beersLoadMoreSection)
        delegate?.tableView?(tableView, willDisplay: view, forRowAt: index)
    }

    func beerView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: beersSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    func simulateTapOnLoadMoreBeersError() {
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: beersLoadMoreSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }

    func simulateTapOnBeer(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: beersSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }

    private func loadMoreBeersCell() -> LoadMoreCell? {
        cell(row: 0, section: beersLoadMoreSection) as? LoadMoreCell
    }

    func cell(row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }

    @discardableResult
    func simulateBeerImageViewVisible(at index: Int) -> BeerCell? {
        beerView(at: index) as? BeerCell
    }

    @discardableResult
    func simulateBeerImageViewNotVisible(at row: Int) -> BeerCell? {
        let view = simulateBeerImageViewVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: beersSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)

        return view
    }

    func renderedBeersImageData(at index: Int) -> Data? {
        simulateBeerImageViewVisible(at: index)?.renderedImage
    }

    func setDateFilter(_ date: Date) {
        filterView.datePicker.date = date
        (filterView.dateTextField.inputAccessoryView as? UIToolbar)?.executeActionForButton(withTitle: BeersPresenter.done)
    }
}
