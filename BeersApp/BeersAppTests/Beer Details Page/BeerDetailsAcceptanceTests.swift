//
//  BeerDetailsAcceptanceTests.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 07/09/22.
//

import XCTest
@testable import BeersApp

class BeerDetailsAcceptanceTests: XCTestCase, AcceptanceTests {

    func test_onBeerSelection_displaysBeerDetails() {
        let beerDetails = showDetailsForFirstBeer()

        XCTAssertEqual(beerDetails.title, BeerDetailsPresenter.title)
    }

    // MARK: - Helpers

    private func showDetailsForFirstBeer() -> BeerDetailsHostingController {
        let beers = launch(httpClient: .online(response))
        beers.loadViewIfNeeded()

        beers.simulateTapOnBeer(at: 1)
        RunLoop.current.run(until: Date())

        let nav = beers.navigationController
        return nav?.topViewController as! BeerDetailsHostingController
    }
}
