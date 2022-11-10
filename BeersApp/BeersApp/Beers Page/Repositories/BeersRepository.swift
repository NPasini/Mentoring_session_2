//
//  BeersRepository.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 29/08/22.
//

import Combine
import BeerAPI
import BeerDomain
import Foundation

struct BeersRepository {

    private let baseURL: URL
    private let httpClient: HTTPClient
    private let scheduler: AnyDispatchQueueScheduler

    init(httpClient: HTTPClient, baseURL: URL, scheduler: AnyDispatchQueueScheduler) {
        self.baseURL = baseURL
        self.scheduler = scheduler
        self.httpClient = httpClient
    }

    func makePaginatedRemoteBeersLoader(brewedAfter: Date?) -> PaginatedBeersPublisher {
        makeRemoteBeersLoader(brewedAfter: brewedAfter)
            .map { beers in
                makeFirstPage(brewedAfter: brewedAfter, items: beers)
            }
            .eraseToAnyPublisher()
    }

    func makeRemoteImageLoader(url: URL) -> BeerImageDataPublisher {
        httpClient
            .getPublisher(url: url)
            .tryMap(BeerImageDataMapper.map)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }

    // MARK: - Private Methods

    private func makeRemoteBeersLoader(brewedAfter: Date?, page: Int = 1) -> BeersPublisher {
        let url = BeersEndpoint.get(page: page, afterDate: brewedAfter).url(baseURL: baseURL)

        return httpClient
            .getPublisher(url: url)
            .tryMap(BeersMapper.map)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }

    private func makeFirstPage(brewedAfter: Date?, items: [Beer]) -> Paginated<Beer> {
        makePage(brewedAfter: brewedAfter, items: items, last: items.last, page: 1)
    }

    private func makePage(brewedAfter: Date?, items: [Beer], last: Beer?, page: Int) -> Paginated<Beer> {
        Paginated(items: items, loadMorePublisher: last.map { last in
            { makeRemoteLoadMoreLoader(brewedAfter: brewedAfter, loadedBeers: items, page: page + 1) }
        })
    }

    private func makeRemoteLoadMoreLoader(brewedAfter: Date?, loadedBeers: [Beer], page: Int) -> AnyPublisher<Paginated<Beer>, Error> {
        makeRemoteBeersLoader(brewedAfter: brewedAfter, page: page)
            .map { newBeers in
                (brewedAfter, loadedBeers + newBeers, newBeers.last, page)
            }
            .map(makePage)
            .eraseToAnyPublisher()
    }
}
