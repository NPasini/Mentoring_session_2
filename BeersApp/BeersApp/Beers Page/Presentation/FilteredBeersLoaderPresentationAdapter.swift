//
//  FilteredBeersLoaderPresentationAdapter.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 05/09/22.
//

import Combine
import BeerAPI
import Foundation

class FilteredBeersLoaderPresentationAdapter: BeersLoaderPresentationAdapter, BeersViewControllerDelegate {

    private var dateFilter: Date?

    init(filteredBeersLoader: @escaping (Date?) -> PaginatedBeersPublisher) {
        dateFilter = nil
        super.init()
        beersLoader = { [weak self] in filteredBeersLoader(self?.dateFilter) }
    }

    func didRequestBeersLoad(brewedAfter date: Date?) {
        dateFilter = date
        didRequestBeersLoad()
    }
}
