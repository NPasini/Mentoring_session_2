//
//  BeerCellController.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 26/08/22.
//

import UIKit
import Combine
import BeerDomain

final class BeerCellController: NSObject {

    private let model: Beer
    private var cell: BeerCell?
    private let selection: (Beer) -> Void
    private var cancellable: Cancellable?
    private let imageLoader: (URL) -> BeerImageDataPublisher

    init(model: Beer, imageLoader: @escaping (URL) -> BeerImageDataPublisher, selection: @escaping (Beer) -> Void) {
        self.model = model
        self.selection = selection
        self.imageLoader = imageLoader
    }
}

extension BeerCellController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.beerImageView.image = nil
        cell?.nameLabel.text = model.name
        cell?.taglineLabel.text = model.tagline
        loadImage()
        return cell!
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelLoad()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selection(model)
    }

    private func loadImage() {
        if let url = model.imageUrl, let cell = self.cell {
            cancellable = imageLoader(url)
                .dispatchOnMainQueue()
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished: break

                        case .failure: break
                        }

                    }, receiveValue: { data in
                        cell.beerImageView.image = UIImage(data: data)
                    })
        } else {
            cell?.beerImageView.image = UIImage(named: "bottle_placeholder")
        }
    }

    private func cancelLoad() {
        cancellable = nil
        releaseCellForReuse()
    }

    private func releaseCellForReuse() {
        cell = nil
    }
}
