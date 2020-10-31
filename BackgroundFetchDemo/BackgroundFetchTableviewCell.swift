//
//  BackgroundFetchTableviewCell.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/30/20.
//

import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}

extension UITableViewCell {

    static func dequeueReusableCell(from tableView: UITableView, for indexPath: IndexPath) -> Self {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.className, for: indexPath) as? Self else {
            preconditionFailure("Unable to dequeue cell of type \(className) from tableView.")
        }

        return cell
    }
}

class BackgroundFetchTableviewCell: UITableViewCell {

    @IBOutlet var pokemonImage: UIImageView?
    @IBOutlet var pokemonSpeciesName: UILabel?
    @IBOutlet var pokemonFetchDate: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
