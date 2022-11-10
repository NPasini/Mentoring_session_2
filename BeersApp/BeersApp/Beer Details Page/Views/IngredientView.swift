//
//  IngredientView.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 07/09/22.
//

import SwiftUI

struct IngredientView: View {

    let items: [String]
    let ingredientName: String

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text(ingredientName + ":")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(customGray)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    ForEach(items, id: \.self) {
                        Text($0)
                            .font(.body)
                            .padding(5)
                            .foregroundColor(customGray)
                            .background(customLightOrange)
                            .clipShape(Capsule())
                    }
                }
            }
            Spacer()
        }
    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientView(items: ["First item", "Second item", "Third item", "Fourth item"], ingredientName: "Hops")
    }
}
