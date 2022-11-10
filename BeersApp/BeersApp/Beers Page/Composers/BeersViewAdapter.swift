//
//  BeersViewAdapter.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 29/08/22.
//

import Foundation
import BeerDomain

class BeersViewAdapter: BeersView {

    private let selection: (Beer) -> Void
    private let currentBeers: [Beer: CellController]
    private weak var controller: BeersViewController?
    private let beerImageLoader: (URL) -> BeerImageDataPublisher

    init(currentBeers: [Beer: CellController] = [:], controller: BeersViewController, beerImageLoader: @escaping (URL) -> BeerImageDataPublisher, selection: @escaping (Beer) -> Void) {
        self.selection = selection
        self.controller = controller
        self.currentBeers = currentBeers
        self.beerImageLoader = beerImageLoader
    }

    func display(_ viewModel: BeersViewModel) {
        guard let controller = controller else { return }

        var currentBeers = self.currentBeers
        let beersSection: [CellController] = viewModel.beers.items.map {
            if let controller = currentBeers[$0] {
                return controller
            }

            let view = BeerCellController(model: $0, imageLoader: beerImageLoader, selection: selection)
            let controller = CellController(id: $0, view)
            currentBeers[$0] = controller

            return controller
        }

        guard let loadMorePublisher = viewModel.beers.loadMorePublisher else {
            controller.display(beersSection)
            return
        }

        let loadMoreAdapter = BeersLoaderPresentationAdapter(beersLoader: loadMorePublisher)
        let loadMore = LoadMoreCellController(callback: loadMoreAdapter.didRequestBeersLoad)

        loadMoreAdapter.presenter = BeersPresenter(
            beersView: BeersViewAdapter(
                currentBeers: currentBeers,
                controller: controller,
                beerImageLoader: beerImageLoader,
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(loadMore),
            errorView: WeakRefVirtualProxy(loadMore)
        )

        let loadMoreSection = [CellController(id: UUID(), loadMore)]

        controller.display(beersSection, loadMoreSection)
    }
}
