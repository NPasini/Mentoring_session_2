//
//  XCTest+AcceptanceTests.swift
//  BeersAppTests
//
//  Created by Nicolò Pasini on 07/09/22.
//

import XCTest
@testable import BeersApp

protocol AcceptanceTests: XCTestCase {}

extension AcceptanceTests {

    func launch(httpClient: HTTPClientStub = .offline) -> BeersViewController {
        let sut = SceneDelegate(httpClient: httpClient, scheduler: .immediateOnMainQueue)
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sut.configureWindow()

        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! BeersViewController
    }

    func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }

    func makeImageData0() -> Data { UIImage.make(withColor: .red).pngData()! }
    func makeImageData1() -> Data { UIImage.make(withColor: .green).pngData()! }
    func makeImageData2() -> Data { UIImage.make(withColor: .blue).pngData()! }

    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "/v2/1.png": return makeImageData0()
        case "/v2/2.png": return makeImageData1()
        case "/v2/3.png": return makeImageData2()

        case "/v2/beers" where url.query?.contains("page=1") == true && url.query?.contains("brewed_after") == false:
            return makeFirstBeersPageData()

        case "/v2/beers" where url.query?.contains("page=2") == true && url.query?.contains("brewed_after") == false:
            return makeSecondBeersPageData()

        case "/v2/beers" where url.query?.contains("page=3") == true && url.query?.contains("brewed_after") == false:
            return makeLastEmptyBeersPageData()

        default:
            return Data()
        }
    }

    private func makeFirstBeersPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            ["id": 1, "name": "Buzz", "tagline": "A Real Bitter Experience.", "first_brewed": "09/2007", "description": "A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once.", "image_url": "https://images.punkapi.com/v2/1.png", "ingredients": ["malt": [], "hops": [], "yeast": "Wyeast 1056 - American Ale™"], "brewers_tips": "The earthy and floral aromas from the hops can be overpowering. Drop a little Cascade in at the end of the boil to lift the profile with a bit of citrus."],
            ["id": 2, "name": "Trashy Blonde", "tagline": "You Know You Shouldn't", "first_brewed": "04/2008", "description": "A titillating, neurotic, peroxide punk of a Pale Ale. Combining attitude, style, substance, and a little bit of low self esteem for good measure; what would your mother say? The seductive lure of the sassy passion fruit hop proves too much to resist. All that is even before we get onto the fact that there are no additives, preservatives, pasteurization or strings attached. All wrapped up with the customary BrewDog bite and imaginative twist.", "image_url": "https://images.punkapi.com/v2/2.png", "ingredients": ["malt": [], "hops": [], "yeast": "Wyeast 1056 - American Ale™"], "brewers_tips": "Be careful not to collect too much wort from the mash. Once the sugars are all washed out there are some very unpleasant grainy tasting compounds that can be extracted into the wort."]
        ])
    }

    private func makeSecondBeersPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [
            ["id": 3, "name": "Berliner Weisse With Yuzu - B-Sides", "tagline": "Japanese Citrus Berliner Weisse.", "first_brewed": "11/2015", "description": "Japanese citrus fruit intensifies the sour nature of this German classic.", "image_url": "https://images.punkapi.com/v2/3.png", "ingredients": ["malt": [], "hops": [], "yeast": "Wyeast 1056 - American Ale™"], "brewers_tips": "Clean everything twice. All you want is the clean sourness of lactobacillus."]
        ])
    }

    private func makeLastEmptyBeersPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: [])
    }
}
