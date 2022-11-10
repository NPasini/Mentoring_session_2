//
//  LoaderSpy.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 28/08/22.
//

import Combine
import BeerAPI
import BeerDomain
import Foundation
@testable import BeersApp

class LoaderSpy {

    // MARK: - Beers Loader

    typealias BeerPublisher = AnyPublisher<[Beer], Error>
    typealias PaginatedBeersPublisher = AnyPublisher<Paginated<Beer>, Error>
    typealias PaginatedBeerSubject = PassthroughSubject<Paginated<Beer>, Error>

    private(set) var dateFiltersApplied = [Date]()
    private var beersRequests = [PaginatedBeerSubject]()

    var loadBeersCallCount: Int {
        beersRequests.count
    }

    func loadPublisher(date: Date? = nil) -> PaginatedBeersPublisher {
        if let appliedDate = date {
            dateFiltersApplied.append(appliedDate)
        }
        
        let publisher = PaginatedBeerSubject()
        beersRequests.append(publisher)
        return publisher.eraseToAnyPublisher()
    }

    func completeBeersLoading(with beers: [Beer] = [], at index: Int = 0) {
        beersRequests[index].send(Paginated(items: beers, loadMorePublisher: { [weak self] in
            self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
        }))
        beersRequests[index].send(completion: .finished)
    }

    func completeBeersLoadingWithError(at index: Int = 0) {
        beersRequests[index].send(completion: .failure(anyNSError()))
    }

    // MARK: - FeedImageDataLoader

    private var imageRequests = [(url: URL, publisher: PassthroughSubject<Data, Error>)]()

    private(set) var cancelledImageURLs = [URL]()

    var loadedImageURLs: [URL] {
        imageRequests.map { $0.url }
    }

    func loadImageDataPublisher(from url: URL) -> AnyPublisher<Data, Error> {
        let publisher = PassthroughSubject<Data, Error>()
        imageRequests.append((url, publisher))
        return publisher.handleEvents(receiveCancel: { [weak self] in
            self?.cancelledImageURLs.append(url)
        }).eraseToAnyPublisher()
    }

    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].publisher.send(imageData)
        imageRequests[index].publisher.send(completion: .finished)
    }

    // MARK: - Load More

    private var loadMoreRequests = [PassthroughSubject<Paginated<Beer>, Error>]()

    var loadMoreCallCount: Int {
        return loadMoreRequests.count
    }

    func loadMorePublisher() -> PaginatedBeersPublisher {
        let publisher = PassthroughSubject<Paginated<Beer>, Error>()
        loadMoreRequests.append(publisher)
        return publisher.eraseToAnyPublisher()
    }

    func completeLoadMore(with beers: [Beer] = [], lastPage: Bool = false, at index: Int = 0) {
        loadMoreRequests[index].send(
            Paginated(
                items: beers,
                loadMorePublisher: lastPage ? nil : { [weak self] in
                    self?.loadMorePublisher() ?? Empty().eraseToAnyPublisher()
                }
            )
        )
    }

    func completeLoadMoreWithError(at index: Int = 0) {
        loadMoreRequests[index].send(completion: .failure(anyNSError()))
    }
}
