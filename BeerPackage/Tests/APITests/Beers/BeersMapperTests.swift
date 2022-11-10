//
//  BeersMapperTests.swift
//  
//
//  Created by Nicolò Pasini on 25/08/22.
//

import XCTest
import BeerAPI
import BeerDomain
import TestHelpers

class BeersMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        let json = makeBeersJson([])

        try samples.forEach { code in
            let response = HTTPURLResponse(statusCode: code)
            XCTAssertThrowsError(
                try BeersMapper.map(json, from: response)
            )
        }
    }

    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)

        let response = HTTPURLResponse(statusCode: 200)
        XCTAssertThrowsError(
            try BeersMapper.map(invalidJSON, from: response)
        )
    }

    func test_map_throwsInvalidDataErrorOn200HTTPResponseWithPartiallyValidJSONItems() {
        let validBeer = makeBeer(id: 1, name: "beer", tagline: "tagline", imageUrl: nil, description: "any", ingredients: Ingredients(hops: [], malts: [], yeast: "any"), tips: "any").json
        let invalidBeer = ["invalid": "item"]
        let json = makeBeersJson([validBeer, invalidBeer])

        let response = HTTPURLResponse(statusCode: 200)
        XCTAssertThrowsError(
            try BeersMapper.map(json, from: response)
        )
    }

    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeBeersJson([])
        let response = HTTPURLResponse(statusCode: 200)

        let result = try BeersMapper.map(emptyListJSON, from: response)

        XCTAssertEqual(result, [])
    }

    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let beer1 = makeBeer(id: 1, name: "beer", tagline: "tagline", imageUrl: anyURL(), description: "any", ingredients: Ingredients(hops: [], malts: [], yeast: "any"), tips: "tips")
        let beer2 = makeBeer(id: 2, name: "another beer", tagline: "another tagline", imageUrl: nil, description: "other", ingredients: Ingredients(hops: ["hop"], malts: ["malt"], yeast: "other"), tips: "other tips")

        let json = makeBeersJson([beer1.json, beer2.json])
        let response = HTTPURLResponse(statusCode: 200)

        let result = try BeersMapper.map(json, from: response)

        XCTAssertEqual(result, [beer1.model, beer2.model])
    }

    // MARK: - Helpers

    private func makeBeer(id: Int, name: String, tagline: String, imageUrl: URL?, description: String, firstBrewedAt: Date = Date(), ingredients: Ingredients, tips: String) -> (model: Beer, json: [String: Any]) {

        let brewedDate = Date.prettyPrintFirstBrewedDate(firstBrewedAt)

        let model = Beer(id: id, name: name, tagline: tagline, imageUrl: imageUrl, description: description, firstBrewedAt: brewedDate.dateFormat, ingredients: ingredients, tips: tips)

        let hops = ingredients.hops.map { ["name": $0] }
        let malts = ingredients.malts.map { ["name": $0] }

        let ingredientsJson = [
            "malt": malts,
            "hops": hops,
            "yeast": ingredients.yeast as Any
        ].compactMapValues { $0 }

        let json = [
            "id": id,
            "name": name,
            "tagline": tagline,
            "first_brewed": brewedDate.stringFormat,
            "description": description,
            "image_url": imageUrl?.absoluteString as Any,
            "ingredients": ingredientsJson,
            "brewers_tips": tips
        ].compactMapValues { $0 }

        return (model, json)
    }

    private func makeBeersJson(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
}
