//
//  RemoteBeer.swift
//  
//
//  Created by Nicolò Pasini on 25/08/22.
//

import Foundation

struct RemoteBeer: Decodable {
    let id: Int
    let name: String
    let tagline: String
    let image_url: String?
    let description: String
    let first_brewed: String
    let brewers_tips: String
    let ingredients: RemoteIngredients
}
