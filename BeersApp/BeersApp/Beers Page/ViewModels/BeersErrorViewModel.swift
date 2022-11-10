//
//  BeersErrorViewModel.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 29/08/22.
//

import Foundation

struct BeersErrorViewModel {

    let message: String?

    static var noError: BeersErrorViewModel {
        return BeersErrorViewModel(message: nil)
    }

    static func error(message: String) -> BeersErrorViewModel {
        return BeersErrorViewModel(message: message)
    }
}
