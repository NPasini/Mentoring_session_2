//
//  BeerImageDataMapper.swift
//  
//
//  Created by Nicolò Pasini on 28/08/22.
//

import Foundation

public final class BeerImageDataMapper {

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw APIError.invalidData
        }

        return data
    }
}
