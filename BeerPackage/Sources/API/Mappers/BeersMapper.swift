//
//  BeersMapper.swift
//  
//
//  Created by Nicolò Pasini on 25/08/22.
//

import Helpers
import Foundation
import BeerDomain

public enum BeersMapper {

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Beer] {
        guard response.isOK else {
            throw APIError.responseCode
        }

        guard let beers = try? JSONDecoder().decode([RemoteBeer].self, from: data) else {
            throw APIError.invalidData
        }

        return beers.toModels()
    }
}

private extension Array where Element == RemoteBeer {

    func toModels() -> [Beer] {
        map { remoteBeer in
            let firstBrewedDate = Date.firstBrewedDateFromString(remoteBeer.first_brewed)

            let hopsNames = remoteBeer.ingredients.hops.map { $0.name }
            let maltsNames = remoteBeer.ingredients.malt.map { $0.name }

            return Beer(id: remoteBeer.id, name: remoteBeer.name, tagline: remoteBeer.tagline, imageUrl: URL(string: remoteBeer.image_url ?? ""), description: remoteBeer.description, firstBrewedAt: firstBrewedDate, ingredients: Ingredients(hops: hopsNames, malts: maltsNames, yeast: remoteBeer.ingredients.yeast), tips: remoteBeer.brewers_tips)
        }
    }
}
