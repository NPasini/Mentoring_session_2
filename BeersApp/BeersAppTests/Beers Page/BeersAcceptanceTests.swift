//
//  BeersAcceptanceTests.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 06/09/22.
//

import XCTest
@testable import BeersApp

class BeersAcceptanceTests: XCTestCase, AcceptanceTests {

    func test_onLaunch_displaysRemoteBeersWhenCustomerHasConnectivity() {
        let beers = launch(httpClient: .online(response))
        beers.loadViewIfNeeded()

        XCTAssertEqual(beers.numberOfRenderedBeerViews, 2)
        XCTAssertEqual(beers.renderedBeersImageData(at: 0), makeImageData0())
        XCTAssertEqual(beers.renderedBeersImageData(at: 1), makeImageData1())
        XCTAssertTrue(beers.canLoadMoreBeers)

        beers.simulateLoadMoreBeersAction()

        XCTAssertEqual(beers.numberOfRenderedBeerViews, 3)
        XCTAssertEqual(beers.renderedBeersImageData(at: 0), makeImageData0())
        XCTAssertEqual(beers.renderedBeersImageData(at: 1), makeImageData1())
        XCTAssertEqual(beers.renderedBeersImageData(at: 2), makeImageData2())
        XCTAssertTrue(beers.canLoadMoreBeers)

        beers.simulateLoadMoreBeersAction()

        XCTAssertEqual(beers.numberOfRenderedBeerViews, 3)
        XCTAssertEqual(beers.renderedBeersImageData(at: 0), makeImageData0())
        XCTAssertEqual(beers.renderedBeersImageData(at: 1), makeImageData1())
        XCTAssertEqual(beers.renderedBeersImageData(at: 2), makeImageData2())
        XCTAssertFalse(beers.canLoadMoreBeers)
    }

    func test_onLaunch_displaysEmptyBeersWhenCustomerHasNoConnectivity() {
        let beers = launch(httpClient: .offline)
        beers.loadViewIfNeeded()

        XCTAssertEqual(beers.numberOfRenderedBeerViews, 0)
    }
}
