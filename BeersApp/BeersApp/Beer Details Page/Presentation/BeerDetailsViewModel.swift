//
//  BeerDetailsViewModel.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 07/09/22.
//

import Foundation
import BeerDomain

struct BeerDetailsViewModel {

    let name: String
    let tips: String
    let yeast: String?
    let imageUrl: URL?
    let tagline: String
    let hops: Set<String>
    let malts: Set<String>
    let description: String

    init(beer: Beer) {
        name = beer.name
        tips = beer.tips
        tagline = beer.tagline
        imageUrl = beer.imageUrl
        yeast = beer.ingredients.yeast
        description = beer.description
        hops = Set(beer.ingredients.hops)
        malts = Set(beer.ingredients.malts)
    }
}
