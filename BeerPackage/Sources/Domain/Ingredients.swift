//
//  Ingredients.swift
//  
//
//  Created by Nicolò Pasini on 24/08/22.
//

import Foundation

public struct Ingredients: Hashable {
    
    public let yeast: String?
    public let hops: [String]
    public let malts: [String]

    public init(hops: [String], malts: [String], yeast: String?) {
        self.hops = hops
        self.malts = malts
        self.yeast = yeast
    }
}
