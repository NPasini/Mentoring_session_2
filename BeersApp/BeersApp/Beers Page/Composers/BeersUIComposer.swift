//
//  BeersUIComposer.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 28/08/22.
//

import UIKit
import Combine
import BeerDomain

enum BeersUIComposer {

    static func beersComposedWith(
        beersLoader: @escaping (Date?) -> PaginatedBeersPublisher,
        beerImageLoader: @escaping (URL) -> BeerImageDataPublisher,
        selection: @escaping (Beer) -> Void
    ) -> BeersViewController {
        let presentationAdapter = FilteredBeersLoaderPresentationAdapter(filteredBeersLoader: beersLoader)

        let beersViewController = makeWith(
            title: BeersPresenter.title,
            delegate: presentationAdapter
        )

        presentationAdapter.presenter = BeersPresenter(
            beersView: BeersViewAdapter(
                controller: beersViewController,
                beerImageLoader: beerImageLoader,
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(beersViewController),
            errorView: WeakRefVirtualProxy(beersViewController)
        )

        return beersViewController
    }

    private static func makeWith(title: String, delegate: BeersViewControllerDelegate) -> BeersViewController {
        let storyboard = UIStoryboard(name: "Beers", bundle: .main)
        let beersController = storyboard.instantiateInitialViewController() as! BeersViewController
        beersController.title = title
        beersController.delegate = delegate
        return beersController
    }
}
