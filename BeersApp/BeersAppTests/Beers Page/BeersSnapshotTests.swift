//
//  BeersSnapshotTests.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 29/08/22.
//

import UIKit
import XCTest
import Combine
import BeerDomain
@testable import BeersApp

class BeersSnapshotTests: XCTestCase  {

    func test_beersPageWithContent() {
        let sut = makeSUT()

        sut.display(beersPageWithContent())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "BEERS_WITH_CONTENT")
    }

    func test_beersPageWithLoadError() {
        let sut = makeSUT()

        sut.display(beersPageWithLoadError())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "BEERS_WITH_LOAD_ERROR")

        sut.display(beersPageWithContent())
        sut.display(beersPageWithLoadError())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "BEERS_WITH_CONTENT_AND_LOAD_ERROR")
    }

    func test_beersWithLoadMoreIndicator() {
        let sut = makeSUT()

        sut.display(beersWithLoadMoreIndicator())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "BEERS_WITH_LOAD_MORE_INDICATOR")
    }

    func test_beersWithLoadMoreError() {
        let sut = makeSUT()

        sut.display(beersWithLoadMoreError())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "BEERS_WITH_LOAD_MORE_ERROR")
    }

    func test_beersWithDateFilter() {
        let sut = makeSUT()
        let dateFilter = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2020, month: 3).date!

        sut.display(beersPageWithContent())
        sut.setDateFilter(dateFilter)

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "BEERS_WITH_DATE_FILTER")
    }

    // MARK: - Helpers

    private func makeSUT() -> BeersViewController {
        let bundle = Bundle(for: BeersViewController.self)
        let storyboard = UIStoryboard(name: "Beers", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! BeersViewController
        controller.loadViewIfNeeded()
        controller.listViewController.tableView.showsVerticalScrollIndicator = false
        controller.listViewController.tableView.showsHorizontalScrollIndicator = false
        return controller
    }

    private func beersPageWithContent() -> [CellController] {
        let date = DateComponents(calendar: Calendar(identifier: .gregorian), year: 2022, month: 9, day: 5).date!
        return [
            makeBeer(id: 0, name: "Beer 0", tagline: "Tagline 0", firstBrewedAt: date.adding(days: -3)),
            makeBeer(id: 1, name: "Beer 1", tagline: "Tagline 1", firstBrewedAt: date.adding(years: -1))
        ].map {
            let view = BeerCellController(model: $0, imageLoader: { url in
                PassthroughSubject<Data, Error>().eraseToAnyPublisher()
            }, selection: { _ in })
            return CellController(id: $0, view)
        }
    }

    private func beersPageWithLoadError() -> BeersErrorViewModel {
        BeersErrorViewModel.error(message: BeersPresenter.loadError)
    }

    private func beersWithLoadMoreIndicator() -> [CellController] {
        let loadMore = LoadMoreCellController(callback: {})
        loadMore.display(BeersLoadingViewModel(isLoading: true))
        return beersWith(loadMore: loadMore)
    }

    private func beersWithLoadMoreError() -> [CellController] {
        let loadMore = LoadMoreCellController(callback: {})
        loadMore.display(BeersErrorViewModel(message: "This is a multiline\nerror message"))
        return beersWith(loadMore: loadMore)
    }

    private func beersWith(loadMore: LoadMoreCellController) -> [CellController] {
        let beerCellController = beersPageWithContent().last!

        return [
            beerCellController,
            CellController(id: UUID(), loadMore)
        ]
    }
}
