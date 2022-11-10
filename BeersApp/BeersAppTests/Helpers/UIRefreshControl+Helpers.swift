//
//  UIRefreshControl+Helpers.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 26/08/22.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
