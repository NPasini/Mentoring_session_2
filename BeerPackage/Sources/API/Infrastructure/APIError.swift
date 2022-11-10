//
//  APIError.swift
//  
//
//  Created by Nicolò Pasini on 25/08/22.
//

import Foundation

public enum APIError: Error {
    case invalidData
    case connectivity
    case responseCode
}
