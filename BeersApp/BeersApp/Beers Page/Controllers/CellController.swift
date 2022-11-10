//
//  CellController.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 30/08/22.
//

import UIKit

struct CellController {

    let id: AnyHashable
    let delegate: UITableViewDelegate?
    let dataSource: UITableViewDataSource

    init(id: AnyHashable, _ dataSource: UITableViewDataSource) {
        self.id = id
        self.dataSource = dataSource
        self.delegate = dataSource as? UITableViewDelegate
    }
}

extension CellController: Equatable {
    static func == (lhs: CellController, rhs: CellController) -> Bool {
        lhs.id == rhs.id
    }
}

extension CellController: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
