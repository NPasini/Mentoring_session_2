//
//  BeersViewController.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 31/08/22.
//

import UIKit
import BeerDomain

protocol BeersViewControllerDelegate {
    func didRequestBeersLoad(brewedAfter date: Date?)
}

class BeersViewController: UIViewController {

    @IBOutlet private(set) var errorView: ErrorView!
    @IBOutlet private(set) var containerView: UIView!
    @IBOutlet private(set) var filterView: DateFilterView!

    var delegate: BeersViewControllerDelegate?

    lazy var listViewController: BeersListViewController = {
        let viewController = BeersListViewController.make()
        viewController.onRefresh = { [weak self] in
            self?.delegate?.didRequestBeersLoad(brewedAfter: self?.dateFilter)
        }
        return viewController
    }()

    private var dateFilter: Date? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        filterView.delegate = self
        add(childViewController: listViewController)
    }

    func display(_ sections: [CellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }
        listViewController.display(snapshot)
    }

    private func add(childViewController viewController: UIViewController) {
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(viewController.view)

        NSLayoutConstraint.activate([
            viewController.view.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            viewController.view.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15)
        ])

        viewController.didMove(toParent: self)
    }

    private func getFirstBrewingDate(fromBeers beers: [Beer]) -> Date {
        beers.compactMap { $0.firstBrewedAt }.min() ?? Date.distantPast
    }
}

extension BeersViewController: FilterDelegate {

    func didSelectFirstBrewingDate(_ date: Date) {
        dateFilter = date
        delegate?.didRequestBeersLoad(brewedAfter: date)
    }
}

extension BeersViewController: BeersLoadingView, BeersErrorView {

    func display(_ viewModel: BeersLoadingViewModel) {
        listViewController.display(viewModel)
    }

    func display(_ viewModel: BeersErrorViewModel) {
        errorView.message = viewModel.message
    }
}

private extension BeersListViewController {

    static func make() -> BeersListViewController {
        let storyboard = UIStoryboard(name: "Beers", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: "\(BeersListViewController.self)") as! BeersListViewController
    }
}
