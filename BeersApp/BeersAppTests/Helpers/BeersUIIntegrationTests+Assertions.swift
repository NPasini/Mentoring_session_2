//
//  BeersUIIntegrationTests+Assertions.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 26/08/22.
//

import XCTest
import BeerDomain
@testable import BeersApp

extension BeersUIIntegrationTests {

    func assertThat(_ sut: BeersViewController, isRendering beers: [Beer], file: StaticString = #filePath, line: UInt = #line) {
        guard sut.numberOfRenderedBeerViews == beers.count else {
            return XCTFail("Expected \(beers.count) images, got \(sut.numberOfRenderedBeerViews) instead.", file: file, line: line)
        }

        beers.enumerated().forEach { index, beer in
            assertThat(sut, hasViewConfiguredFor: beer, at: index, file: file, line: line)
        }
    }

    func assertThat(_ sut: BeersViewController, hasViewConfiguredFor beer: Beer, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.beerView(at: index)

        guard let cell = view as? BeerCell else {
            return XCTFail("Expected \(BeerCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        XCTAssertEqual(cell.beerNameText, beer.name, "Expected beer name text to be \(beer.name) for beer view at index (\(index))", file: file, line: line)

        XCTAssertEqual(cell.taglineText, beer.tagline, "Expected tagline text to be \(beer.tagline) for beer view at index (\(index)", file: file, line: line)
    }
}
