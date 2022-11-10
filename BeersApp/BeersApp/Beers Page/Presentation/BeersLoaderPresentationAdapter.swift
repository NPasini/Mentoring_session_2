//
//  BeersLoaderPresentationAdapter.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 29/08/22.
//

import Combine
import BeerAPI
import Foundation

class BeersLoaderPresentationAdapter {

    private var isLoading = false
    private var cancellable: Cancellable?

    var presenter: BeersPresenter?
    var beersLoader: (() -> PaginatedBeersPublisher)?

    init(beersLoader: @escaping () -> PaginatedBeersPublisher) {
        self.beersLoader = beersLoader
    }

    init() {}

    func didRequestBeersLoad() {
        guard !isLoading else { return }

        presenter?.didStartLoadingBeers()
        isLoading = true

        cancellable = beersLoader?()
            .dispatchOnMainQueue()
            .handleEvents(receiveCancel: { [weak self] in
                self?.isLoading = false
            })
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break

                    case let .failure(error):
                        self?.presenter?.didFinishLoadingBeers(with: error)
                    }

                    self?.isLoading = false
                }, receiveValue: { [weak self] beers in
                    self?.presenter?.didFinishLoadingBeers(with: beers)
                })
    }
}
