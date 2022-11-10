//
//  SceneDelegate.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 25/08/22.
//

import UIKit
import Combine
import BeerAPI
import BeerDomain

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(label: "com.beersapp.infra.queue", qos: .userInitiated, attributes: .concurrent).eraseToAnyScheduler()

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()

    convenience init(httpClient: HTTPClient, scheduler: AnyDispatchQueueScheduler) {
        self.init()
        self.scheduler = scheduler
        self.httpClient = httpClient
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = UINavigationController(rootViewController: makeBeersPage())
        window?.makeKeyAndVisible()
    }

    private func makeBeersPage() -> BeersViewController {
        let baseURL = URL(string: "https://api.punkapi.com")!
        let beersRepository = BeersRepository(httpClient: httpClient, baseURL: baseURL, scheduler: scheduler)
        return BeersUIComposer.beersComposedWith(beersLoader: beersRepository.makePaginatedRemoteBeersLoader, beerImageLoader: beersRepository.makeRemoteImageLoader, selection: showBeerDetails)
    }

    private func showBeerDetails(for beer: Beer) {
        let beersController = BeerDetailsHostingController(title: BeerDetailsPresenter.title, beer: beer)
        (window?.rootViewController as? UINavigationController)?.pushViewController(beersController, animated: true)
    }
}
