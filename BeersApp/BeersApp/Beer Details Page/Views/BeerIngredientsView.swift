//
//  BeerIngredientsView.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 07/09/22.
//

import SwiftUI

struct BeerIngredientsView: View {

    let hops: [String]
    let yeast: String?
    let malts: [String]

    var body: some View {
        VStack {
            if let yeast = yeast {
                IngredientView(items: [yeast], ingredientName: BeerDetailsPresenter.yeastTitle)
            }

            if hops.count > 0 {
                IngredientView(items: hops, ingredientName: BeerDetailsPresenter.hopsTitle)
            }

            if malts.count > 0 {
                IngredientView(items: malts, ingredientName: BeerDetailsPresenter.maltsTitle)
            }
        }
    }
}

struct BeerIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        BeerIngredientsView(hops: ["Hop 1", "Hop 2", "Hop 3"], yeast: "Yeast", malts: ["Malt 1", "Malt 2"])
    }
}
