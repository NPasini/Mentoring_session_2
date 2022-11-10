//
//  UITableView+Header.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 28/08/22.
//

import UIKit

extension UITableView {

    func sizeTableHeaderToFit() {
        guard let header = tableHeaderView else { return }

        let size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        let needsFrameUpdate = header.frame.height != size.height
        if needsFrameUpdate {
            header.frame.size.height = size.height
            tableHeaderView = header
        }
    }
}
