//
//  Beers.swift
//  
//
//  Created by Nicolò Pasini on 24/08/22.
//

import Helpers
import Foundation

public enum BeersEndpoint {
    case get(page: Int? = nil, afterDate: Date? = nil)

    public func url(baseURL: URL) -> URL {
        var components = URLComponents()

        switch self {
        case let .get(page, afterDate):
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v2/beers"
            components.queryItems = [
                page.map { URLQueryItem(name: "page", value: "\($0)") },
                afterDate.map { URLQueryItem(name: "brewed_after", value: "\(Date.printFirstBrewedDateSeparatedByDash($0))") },
            ].compactMap { $0 }
        }

        return components.url!
    }
}
