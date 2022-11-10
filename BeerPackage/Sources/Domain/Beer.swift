//
//  Beer.swift
//  
//
//  Created by Nicolò Pasini on 24/08/22.
//

import Foundation

public struct Beer: Hashable {
    
    public let id: Int
    public let name: String
    public let tips: String
    public let imageUrl: URL?
    public let tagline: String
    public let description: String
    public let firstBrewedAt: Date?
    public let ingredients: Ingredients

    public init(id: Int, name: String, tagline: String, imageUrl: URL?, description: String, firstBrewedAt: Date?, ingredients: Ingredients, tips: String) {
        self.id = id
        self.name = name
        self.tips = tips
        self.tagline = tagline
        self.imageUrl = imageUrl
        self.description = description
        self.ingredients = ingredients
        self.firstBrewedAt = firstBrewedAt
    }
}
