//
//  WeakRefVirtualProxy.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 29/08/22.
//

import Foundation

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: BeersLoadingView where T: BeersLoadingView {
    func display(_ viewModel: BeersLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: BeersErrorView where T: BeersErrorView {
    func display(_ viewModel: BeersErrorViewModel) {
        object?.display(viewModel)
    }
}
