//
//  BeerCell+TestHelpers.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 26/08/22.
//

import Foundation
@testable import BeersApp

extension BeerCell {
    var beerNameText: String? { nameLabel.text }
    var taglineText: String? { taglineLabel.text }
    var renderedImage: Data? { beerImageView.image?.pngData() }
}
