//
//  BeerDetailsView.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 07/09/22.
//

import SwiftUI
import BeerDomain

struct BeerDetailsView: View {

    let viewModel: BeerDetailsViewModel

    private let imageWidth: CGFloat = 50
    private let imageHeight: CGFloat = 180
    private let placeholderImageWidth: CGFloat = 90

    private var imagePlaceHolder: some View {
        Image("bottle_placeholder")
            .resizable()
            .frame(width: placeholderImageWidth, height: imageHeight)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 25) {
                BeerHeaderView(beerName: viewModel.name, beerTagline: viewModel.tagline)

                if let imageUrl = viewModel.imageUrl {
                    loadImage(withURL: imageUrl)
                } else {
                    imagePlaceHolder
                }

                Text(viewModel.description)
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(customBlue)
                    .multilineTextAlignment(.center)

                BeerIngredientsView(hops: viewModel.hops.sorted(), yeast: viewModel.yeast, malts: viewModel.malts.sorted())

                Text(viewModel.tips)
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(customBlue)
                    .multilineTextAlignment(.center)
                Spacer()
            }.padding([.leading, .trailing], 15)
        }
    }

    private func loadImage(withURL url: URL) -> some View {
        AsyncImage(url: url) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: imageWidth, height: imageHeight)
    }
}

struct BeerDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let beer = Beer(id: 1, name: "Trashy Blonde", tagline: "You Know You Shouldn't.", imageUrl: nil, description: "A titillating, neurotic, peroxide punk of a Pale Ale. Combining attitude, style, substance, and a little bit of low self esteem for good measure; what would your mother say? The seductive lure of the sassy passion fruit hop proves too much to resist. All that is even before we get onto the fact that there are no additives, preservatives, pasteurization or strings attached. All wrapped up with the customary BrewDog bite and imaginative twist.", firstBrewedAt: Date(), ingredients: Ingredients(hops: ["First Hop", "Second Hop"], malts: [], yeast: "Wyeast 1056 - American Ale™"), tips: "The earthy and floral aromas from the hops can be overpowering. Drop a little Cascade in at the end of the boil to lift the profile with a bit of citrus.")
        let viewModel = BeerDetailsViewModel(beer: beer)
        BeerDetailsView(viewModel: viewModel)
    }
}
