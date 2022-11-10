//
//  BeersUIIntegrationTests.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 25/08/22.
//

import XCTest
import BeerDomain
@testable import BeersApp

class BeersUIIntegrationTests: XCTestCase {

    func test_feedView_hasTitle() {
        let (sut, _) = makeSUT()

        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.title, BeersPresenter.title)
    }

    func test_loadBeersActions_requestBeersFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadBeersCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadBeersCallCount, 1, "Expected a loading request once view is loaded")

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadBeersCallCount, 1, "Expected no request until previous completes")

        loader.completeBeersLoading()
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadBeersCallCount, 2, "Expected another loading request once user initiates a reload")

        loader.completeBeersLoading(at: 1)
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadBeersCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }

    func test_loadingBeersIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")

        loader.completeBeersLoading()
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes successfully")

        sut.simulateUserInitiatedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user pulls to refresh")

        loader.completeBeersLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading completes with error")
    }

    func test_loadBeersCompletion_rendersSuccessfullyLoadedFeed() {
        let (sut, loader) = makeSUT()
        let beer0 = makeBeer(id: 0, name: "Beer 0", tagline: "Tagline 0")
        let beer1 = makeBeer(id: 1, name: "Beer 1", tagline: "Tagline 1")
        let beer2 = makeBeer(id: 2, name: "Beer 2", tagline: "Tagline 2")

        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])

        loader.completeBeersLoading(with: [beer0], at: 0)
        assertThat(sut, isRendering: [beer0])

        sut.simulateUserInitiatedReload()
        loader.completeBeersLoading(with: [beer0, beer1], at: 1)
        assertThat(sut, isRendering: [beer0, beer1])

        sut.simulateLoadMoreBeersAction()
        loader.completeLoadMore(with: [beer0, beer1, beer2], at: 0)
        assertThat(sut, isRendering: [beer0, beer1, beer2])

        sut.simulateUserInitiatedReload()
        loader.completeBeersLoading(with: [beer0, beer1], at: 2)
        assertThat(sut, isRendering: [beer0, beer1])
    }

    func test_loadBeersCompletion_rendersSuccessfullyLoadedEmptyBeersAfterNonEmptyBeers() {
        let beer0 = makeBeer(id: 0, name: "Beer 0", tagline: "Tagline 0")
        let beer1 = makeBeer(id: 1, name: "Beer 1", tagline: "Tagline 1")
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeBeersLoading(with: [beer0], at: 0)
        assertThat(sut, isRendering: [beer0])

        sut.simulateLoadMoreBeersAction()
        loader.completeLoadMore(with: [beer0, beer1], at: 0)
        assertThat(sut, isRendering: [beer0, beer1])

        sut.simulateUserInitiatedReload()
        loader.completeBeersLoading(with: [], at: 1)
        assertThat(sut, isRendering: [])
    }

    func test_loadBeersCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let (sut, loader) = makeSUT()
        let beer0 = makeBeer(id: 0, name: "Beer 0", tagline: "Tagline 0")

        sut.loadViewIfNeeded()
        loader.completeBeersLoading(with: [beer0], at: 0)
        assertThat(sut, isRendering: [beer0])

        sut.simulateUserInitiatedReload()
        loader.completeBeersLoadingWithError(at: 1)
        assertThat(sut, isRendering: [beer0])

        sut.simulateLoadMoreBeersAction()
        loader.completeLoadMoreWithError(at: 0)
        assertThat(sut, isRendering: [beer0])
    }

    func test_loadBeersCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeBeersLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_loadBeersCompletion_rendersErrorMessageOnErrorUntilNextReload() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.errorMessage, nil)

        loader.completeBeersLoadingWithError(at: 0)
        XCTAssertEqual(sut.errorMessage, BeersPresenter.loadError)

        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.errorMessage, nil)
    }

    func test_beerView_loadsImageURLWhenVisible() {
        let beer0 = makeBeer(id: 0, name: "Beer 0", tagline: "Tagline 0", imageUrl: URL(string: "https://images.punkapi.com/v2/1.png")!)
        let beer1 = makeBeer(id: 1, name: "Beer 1", tagline: "Tagline 1", imageUrl: URL(string: "https://images.punkapi.com/v2/2.png")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeBeersLoading(with: [beer0, beer1])

        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")

        sut.simulateBeerImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [beer0.imageUrl], "Expected first image URL request once first view becomes visible")

        sut.simulateBeerImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [beer0.imageUrl, beer1.imageUrl], "Expected second image URL request once second view also becomes visible")
    }

    func test_beerView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let beer0 = makeBeer(id: 0, name: "Beer 0", tagline: "Tagline 0", imageUrl: URL(string: "https://images.punkapi.com/v2/1.png")!)
        let beer1 = makeBeer(id: 1, name: "Beer 1", tagline: "Tagline 1", imageUrl: URL(string: "https://images.punkapi.com/v2/2.png")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeBeersLoading(with: [beer0, beer1])
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible")

        sut.simulateBeerImageViewNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [beer0.imageUrl], "Expected one cancelled image URL request once first beer is not visible anymore")

        sut.simulateBeerImageViewNotVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [beer0.imageUrl, beer1.imageUrl], "Expected two cancelled image URL requests once second beer is also not visible anymore")
    }

    func test_beerView_rendersImageLoadedFromURL() {
        let beer0 = makeBeer(id: 0, name: "Beer 0", tagline: "Tagline 0", imageUrl: URL(string: "https://images.punkapi.com/v2/1.png")!)
        let beer1 = makeBeer(id: 1, name: "Beer 1", tagline: "Tagline 1", imageUrl: URL(string: "https://images.punkapi.com/v2/2.png")!)
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        loader.completeBeersLoading(with: [beer0, beer1])

        let view0 = sut.simulateBeerImageViewVisible(at: 0)
        let view1 = sut.simulateBeerImageViewVisible(at: 1)
        XCTAssertEqual(view0?.renderedImage, .none, "Expected no image for first view while loading first image")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image for second view while loading second image")

        let imageData0 = UIImage.make(withColor: .red).pngData()!
        loader.completeImageLoading(with: imageData0, at: 0)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected image for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.renderedImage, .none, "Expected no image state change for second view once first image loading completes successfully")

        let imageData1 = UIImage.make(withColor: .blue).pngData()!
        loader.completeImageLoading(with: imageData1, at: 1)
        XCTAssertEqual(view0?.renderedImage, imageData0, "Expected no image state change for first view once second image loading completes successfully")
        XCTAssertEqual(view1?.renderedImage, imageData1, "Expected image for second view once second image loading completes successfully")
    }

    func test_beerView_doesNotRenderLoadedImageWhenNotVisibleAnymore() {
        let beer0 = makeBeer(id: 0, name: "Beer 0", tagline: "Tagline 0", imageUrl: URL(string: "https://images.punkapi.com/v2/1.png")!)
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeBeersLoading(with: [beer0])

        let view = sut.simulateBeerImageViewNotVisible(at: 0)
        loader.completeImageLoading(with: Data())

        XCTAssertNil(view?.renderedImage, "Expected no rendered image when an image load finishes after the view is not visible anymore")
    }

    func test_loadImageDataCompletion_dispatchesFromBackgroundToMainThread() {
        let beer0 = makeBeer(id: 0, name: "Beer 0", tagline: "Tagline 0", imageUrl: URL(string: "https://images.punkapi.com/v2/1.png")!)
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeBeersLoading(with: [beer0])
        _ = sut.simulateBeerImageViewVisible(at: 0)

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeImageLoading(with: Data(), at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Load More Tests

    func test_loadMoreActions_requestMoreFromLoader() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeBeersLoading()

        XCTAssertEqual(loader.loadMoreCallCount, 0, "Expected no requests before until load more action")

        sut.simulateLoadMoreBeersAction()
        XCTAssertEqual(loader.loadMoreCallCount, 1, "Expected load more request")

        sut.simulateLoadMoreBeersAction()
        XCTAssertEqual(loader.loadMoreCallCount, 1, "Expected no request while loading more")

        loader.completeLoadMore(lastPage: false, at: 0)
        sut.simulateLoadMoreBeersAction()
        XCTAssertEqual(loader.loadMoreCallCount, 2, "Expected request after load more completed with more pages")

        loader.completeLoadMoreWithError(at: 1)
        sut.simulateLoadMoreBeersAction()
        XCTAssertEqual(loader.loadMoreCallCount, 3, "Expected request after load more failure")

        loader.completeLoadMore(lastPage: true, at: 2)
        sut.simulateLoadMoreBeersAction()
        XCTAssertEqual(loader.loadMoreCallCount, 3, "Expected no request after loading all pages")
    }

    func test_loadingMoreIndicator_isVisibleWhileLoadingMore() {
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertFalse(sut.isShowingLoadMoreBeersIndicator, "Expected no loading indicator once view is loaded")

        loader.completeBeersLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadMoreBeersIndicator, "Expected no loading indicator once loading completes successfully")

        sut.simulateLoadMoreBeersAction()
        XCTAssertTrue(sut.isShowingLoadMoreBeersIndicator, "Expected loading indicator on load more action")

        loader.completeLoadMore(at: 0)
        XCTAssertFalse(sut.isShowingLoadMoreBeersIndicator, "Expected no loading indicator once user initiated loading completes successfully")

        sut.simulateLoadMoreBeersAction()
        XCTAssertTrue(sut.isShowingLoadMoreBeersIndicator, "Expected loading indicator on second load more action")

        loader.completeLoadMoreWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadMoreBeersIndicator, "Expected no loading indicator once user initiated loading completes with error")
    }

    func test_loadMoreCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeBeersLoading(at: 0)
        sut.simulateLoadMoreBeersAction()

        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeLoadMore()
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }

    func test_loadMoreCompletion_rendersErrorMessageOnError() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeBeersLoading()

        sut.simulateLoadMoreBeersAction()
        XCTAssertEqual(sut.loadMoreBeersErrorMessage, nil)

        loader.completeLoadMoreWithError()
        XCTAssertEqual(sut.loadMoreBeersErrorMessage, BeersPresenter.loadError)

        sut.simulateLoadMoreBeersAction()
        XCTAssertEqual(sut.loadMoreBeersErrorMessage, nil)
    }

    func test_tapOnLoadMoreErrorView_loadsMore() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        loader.completeBeersLoading()

        sut.simulateLoadMoreBeersAction()
        XCTAssertEqual(loader.loadMoreCallCount, 1)

        loader.completeLoadMoreWithError()
        sut.simulateTapOnLoadMoreBeersError()
        XCTAssertEqual(loader.loadMoreCallCount, 2)
    }

    // MARK: - Filters

    func test_filterBeersByDate_rendersFilteredBeers() {
        let filterDate = Date().adding(days: 3)
        let beer0 = makeBeer(id: 0, name: "Beer 0", tagline: "Tagline 0", imageUrl: nil, firstBrewedAt: filterDate.adding(days: -1))
        let beer1 = makeBeer(id: 1, name: "Beer 1", tagline: "Tagline 1", firstBrewedAt: filterDate.adding(days: 3))
        let beer2 = makeBeer(id: 1, name: "Beer 2", tagline: "Tagline 1", firstBrewedAt: filterDate.adding(years: -2))
        let (sut, loader) = makeSUT()

        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadBeersCallCount, 1, "Expected load beers request")
        loader.completeBeersLoading(with: [beer0, beer1, beer2], at: 0)

        sut.didSelectFirstBrewingDate(filterDate)
        XCTAssertEqual(loader.loadBeersCallCount, 2, "Expected load beers woth date filter request")
        XCTAssertEqual(loader.dateFiltersApplied, [filterDate], "Expected date filter applied to be \(filterDate), got \(loader.dateFiltersApplied) instead")
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once date filter is applied")

        loader.completeBeersLoading(with: [beer0, beer2], at: 1)
        assertThat(sut, isRendering: [beer0, beer2])
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once filtered beers are displayed")
    }

    // MARK: - Beer Selection

    func test_beerSelection_notifiesHandler() {
        let beer0 = makeBeer(id: 0, name: "Beer 0", tagline: "Tagline 0")
        let beer1 = makeBeer(id: 1, name: "Beer 1", tagline: "Tagline 1")
        var selectedBeers = [Beer]()
        let (sut, loader) = makeSUT(selection: { selectedBeers.append($0) })

        sut.loadViewIfNeeded()
        loader.completeBeersLoading(with: [beer0, beer1], at: 0)

        sut.simulateTapOnBeer(at: 0)
        XCTAssertEqual(selectedBeers, [beer0])

        sut.simulateTapOnBeer(at: 1)
        XCTAssertEqual(selectedBeers, [beer0, beer1])
    }

    // MARK: - Helpers

    private func makeSUT(selection: @escaping (Beer) -> Void = { _ in },
                         file: StaticString = #filePath,
                         line: UInt = #line
    ) -> (sut: BeersViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = BeersUIComposer.beersComposedWith(beersLoader: loader.loadPublisher, beerImageLoader: loader.loadImageDataPublisher, selection: selection)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(sut)
        return (sut, loader)
    }
}
