//
//  BeerHeaderView.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 07/09/22.
//

import SwiftUI

struct BeerHeaderView: View {

    let beerName: String
    let beerTagline: String

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(beerName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(customOrange)
                .multilineTextAlignment(.center)
            Text(beerTagline)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(customBlue)
                .multilineTextAlignment(.center)
        }
    }
}

struct BeerHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        BeerHeaderView(beerName: "Trashy Blonde", beerTagline: "You Know You Shouldn't.")
    }
}
