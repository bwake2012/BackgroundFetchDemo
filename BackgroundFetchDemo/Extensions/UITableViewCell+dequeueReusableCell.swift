//
//  UITableViewCell+dequeueReusableCell.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 11/4/20.
//

import UIKit

extension UITableViewCell {

    static func dequeueReusableCell(from tableView: UITableView, for indexPath: IndexPath) -> Self {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.className, for: indexPath) as? Self else {
            preconditionFailure("Unable to dequeue cell of type \(className) from tableView.")
        }

        return cell
    }
}
