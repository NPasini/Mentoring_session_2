//
//  BeersAPIEndToEndTests.swift
//  
//
//  Created by Nicolò Pasini on 25/08/22.
//

import XCTest
import Helpers
import BeerAPI
import BeerDomain
import TestHelpers

class BeersAPIEndToEndTests: XCTestCase {

    func test_endToEndTestServerGETBeersResult_matchesFixedTestAccountData() {
        switch getBeersResult() {
        case let .success(beers)?:
            XCTAssertEqual(beers.count, 2, "Expected 2 beers in the test endpoint")
            XCTAssertEqual(beers[0], expectedBeer(at: 0))
            XCTAssertEqual(beers[1], expectedBeer(at: 1))

        case let .failure(error)?:
            XCTFail("Expected successful beers result, got \(error) instead")

        default:
            XCTFail("Expected successful beers result, got no result instead")
        }
    }

    // MARK: - Helpers

    private func getBeersResult(file: StaticString = #filePath, line: UInt = #line) -> Swift.Result<[Beer], Error>? {
        let client = ephemeralClient()
        let exp = expectation(description: "Wait for load completion")

        var receivedResult: Swift.Result<[Beer], Error>?
        client.get(from: beersTestServerURL) { result in
            receivedResult = result.flatMap { (data, response) in
                do {
                    return .success(try BeersMapper.map(data, from: response))
                } catch {
                    return .failure(error)
                }
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)

        return receivedResult
    }

    private var beersTestServerURL: URL {
        return URL(string: "https://api.punkapi.com/v2/beers?page=1&per_page=2")!
    }

    private func ephemeralClient(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        trackForMemoryLeaks(client, file: file, line: line)
        return client
    }

    private func expectedBeer(at index: Int) -> Beer {
        return Beer(id: index + 1, name: name(at: index), tagline: tagline(at: index), imageUrl: imageUrl(at: index), description: description(at: index), firstBrewedAt: firstBrewedAt(at: index), ingredients: ingredients(at: index), tips: tips(at: index))
    }

    private func name(at index: Int) -> String {
        return [
            "Buzz",
            "Trashy Blonde"
        ][index]
    }

    private func tagline(at index: Int) -> String {
        return [
            "A Real Bitter Experience.",
            "You Know You Shouldn't"
        ][index]
    }

    private func imageUrl(at index: Int) -> URL? {
        let urlString = [
            "https://images.punkapi.com/v2/keg.png",
            "https://images.punkapi.com/v2/2.png"
        ][index]
        return URL(string: urlString)
    }

    private func description(at index: Int) -> String {
        return [
            "A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.",
            "A titillating, neurotic, peroxide punk of a Pale Ale. Combining attitude, style, substance, and a little bit of low self esteem for good measure; what would your mother say? The seductive lure of the sassy passion fruit hop proves too much to resist. All that is even before we get onto the fact that there are no additives, preservatives, pasteurization or strings attached. All wrapped up with the customary BrewDog bite and imaginative twist."
        ][index]
    }

    private func firstBrewedAt(at index: Int) -> Date {
        let dateString = [
            "09/2007",
            "04/2008"
        ][index]
        return Date.firstBrewedDateFromString(dateString)!
    }

    private func ingredients(at index: Int) -> Ingredients {
        return [
            Ingredients(
                hops: [
                    "Fuggles",
                    "First Gold",
                    "Fuggles",
                    "First Gold",
                    "Cascade"
                ],
                malts: [
                    "Maris Otter Extra Pale",
                    "Caramalt",
                    "Munich"
                ],
                yeast: "Wyeast 1056 - American Ale™"
            ),
            Ingredients(
                hops: [
                    "Amarillo",
                    "Simcoe",
                    "Amarillo",
                    "Motueka"
                ],
                malts: [
                    "Maris Otter Extra Pale",
                    "Caramalt",
                    "Munich"
                ],
                yeast: "Wyeast 1056 - American Ale™"
            )
        ][index]
    }

    private func tips(at index: Int) -> String {
        [
            "The earthy and floral aromas from the hops can be overpowering. Drop a little Cascade in at the end of the boil to lift the profile with a bit of citrus.",
            "Be careful not to collect too much wort from the mash. Once the sugars are all washed out there are some very unpleasant grainy tasting compounds that can be extracted into the wort."
        ][index]
    }

}
