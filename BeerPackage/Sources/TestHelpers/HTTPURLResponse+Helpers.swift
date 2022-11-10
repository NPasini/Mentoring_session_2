//
//  HTTPURLResponse+Helpers.swift
//  
//
//  Created by Nicolò Pasini on 25/08/22.
//

import Foundation

public extension HTTPURLResponse {

    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
