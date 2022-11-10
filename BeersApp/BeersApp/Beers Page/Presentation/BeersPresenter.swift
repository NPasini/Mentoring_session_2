//
//  BeersPresenter.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 29/08/22.
//

import BeerAPI
import Foundation
import BeerDomain

protocol BeersView {
    func display(_ viewModel: BeersViewModel)
}

protocol BeersLoadingView {
    func display(_ viewModel: BeersLoadingViewModel)
}

protocol BeersErrorView {
    func display(_ viewModel: BeersErrorViewModel)
}

struct BeersPresenter {

    static let done: String = "Done"
    static let title: String = "Beers"
    static let loadError: String = "Error while loading beers"

    private let beersView: BeersView
    private let errorView: BeersErrorView
    private let loadingView: BeersLoadingView

    init(beersView: BeersView, loadingView: BeersLoadingView, errorView: BeersErrorView) {
        self.beersView = beersView
        self.errorView = errorView
        self.loadingView = loadingView
    }

    func didStartLoadingBeers() {
        errorView.display(.noError)
        loadingView.display(BeersLoadingViewModel(isLoading: true))
    }

    func didFinishLoadingBeers(with beers: Paginated<Beer>) {
        beersView.display(BeersViewModel(beers: beers))
        loadingView.display(BeersLoadingViewModel(isLoading: false))
    }

    func didFinishLoadingBeers(with error: Error) {
        errorView.display(.error(message: BeersPresenter.loadError))
        loadingView.display(BeersLoadingViewModel(isLoading: false))
    }
}
