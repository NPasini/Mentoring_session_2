//
//  RemoteIngredients.swift
//  
//
//  Created by Nicolò Pasini on 25/08/22.
//

import Foundation

public struct RemoteIngredients: Decodable {
    public let yeast: String?
    public let hops: [RemoteHop]
    public let malt: [RemoteMalt]
}
