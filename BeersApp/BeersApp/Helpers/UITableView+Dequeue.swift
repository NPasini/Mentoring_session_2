//
//  UITableView+Dequeue.swift
//  BeersApp
//
//  Created by Nicolò Pasini on 26/08/22.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
