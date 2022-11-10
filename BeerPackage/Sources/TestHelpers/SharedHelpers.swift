//
//  SharedHelpers.swift
//  
//
//  Created by Nicolò Pasini on 25/08/22.
//

import Foundation

public func anyNSError() -> NSError {
    NSError(domain: "test", code: 0)
}

public func anyURL() -> URL {
    URL(string: "https://a-given-url.com")!
}

public func anyData() -> Data {
    Data("any".utf8)
}
