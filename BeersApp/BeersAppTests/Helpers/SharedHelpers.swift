//
//  SharedHelpers.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 26/08/22.
//

import Foundation
import BeerDomain

func anyNSError() -> NSError {
    NSError(domain: "test", code: 0)
}

func anyURL() -> URL {
    URL(string: "https://a-given-url.com")!
}

func anyData() -> Data {
    Data("any".utf8)
}

func makeBeer(id: Int, name: String, tagline: String, imageUrl: URL? = nil, firstBrewedAt: Date = Date(), tips: String = "") -> Beer {
    Beer(id: id, name: name, tagline: tagline, imageUrl: imageUrl, description: "", firstBrewedAt: firstBrewedAt, ingredients: Ingredients(hops: [], malts: [], yeast: nil), tips: tips)
}
