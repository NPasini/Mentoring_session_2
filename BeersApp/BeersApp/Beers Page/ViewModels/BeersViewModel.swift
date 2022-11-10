//
//  BeersViewModel.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 29/08/22.
//

import BeerAPI
import BeerDomain

struct BeersViewModel {
    let beers: Paginated<Beer>
}
