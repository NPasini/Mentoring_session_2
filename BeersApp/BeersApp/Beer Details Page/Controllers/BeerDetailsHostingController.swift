//
//  BeerDetailsHostingController.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 07/09/22.
//

import SwiftUI
import BeerDomain

class BeerDetailsHostingController: UIHostingController<BeerDetailsView> {

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(title: String, beer: Beer) {
        let viewModel = BeerDetailsViewModel(beer: beer)
        let productView = BeerDetailsView(viewModel: viewModel)
        super.init(rootView: productView)
        self.title = title
    }
}
