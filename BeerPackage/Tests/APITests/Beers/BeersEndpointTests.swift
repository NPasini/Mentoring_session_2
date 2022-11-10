import XCTest
import BeerAPI

final class BeersEndpointTests: XCTestCase {

    func test_beers_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = BeersEndpoint.get().url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v2/beers", "path")
        XCTAssertTrue(received.query!.isEmpty)
    }

    func test_beers_endpointURLNextPage() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = BeersEndpoint.get(page: 2).url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v2/beers", "path")
        XCTAssertEqual(received.query, "page=2", "query")
    }

    func test_beers_endpointURLBrewedAfterDate() {
        let date = Date()
        let baseURL = URL(string: "http://base-url.com")!

        let received = BeersEndpoint.get(page: 2, afterDate: date).url(baseURL: baseURL)

        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v2/beers", "path")
        XCTAssertEqual(received.query?.contains("page=2"), true, "Page query parameter")
        XCTAssertEqual(received.query?.contains("brewed_after=\(Date.printFirstBrewedDateSeparatedByDash(date))"), true, "Date filter query parameter")
    }
}
