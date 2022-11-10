//
//  HTTPURLResponse+StatusCode.swift
//  
//
//  Created by Nicolò Pasini on 25/08/22.
//

import Foundation

extension HTTPURLResponse {

    private static var OK_200: Int { return 200 }

    public var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
