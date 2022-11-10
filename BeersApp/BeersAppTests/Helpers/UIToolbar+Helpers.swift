//
//  UIToolbar+Helpers.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 06/09/22.
//

import UIKit

extension UIToolbar {

    func executeActionForButton(withTitle title: String) {
        items?.filter { $0.title == title }.forEach({ item in
            (item.target as? NSObject)?.perform(item.action)
        })
    }
}
