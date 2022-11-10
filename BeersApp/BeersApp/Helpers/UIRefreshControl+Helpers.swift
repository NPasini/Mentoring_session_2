//
//  UIRefreshControl+Helpers.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 29/08/22.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
