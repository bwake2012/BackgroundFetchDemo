//
//  BackgroundFetchTableviewCell.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/30/20.
//

import UIKit

class BackgroundFetchTableviewCell: UITableViewCell {

    static var dateFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter
    }()

    typealias LedgerEntry = PokemonFetchEntry

    @IBOutlet var pokemonImage: UIImageView?
    @IBOutlet var pokemonSpeciesName: UILabel?
    @IBOutlet var pokemonFetchDate: UILabel?
    @IBOutlet var backgroundStatus: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        if let pokemonImage = pokemonImage {

            pokemonImage.layer.cornerRadius = (pokemonImage.bounds.height / 2)
            pokemonImage.layer.masksToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {

        pokemonImage?.image = nil
        pokemonSpeciesName?.text = nil
        pokemonFetchDate?.text = nil
        backgroundStatus?.text = nil
    }

    func configure(with ledgerEntry: LedgerEntry?) {
        
        guard let entry = ledgerEntry else {

            return
        }

        pokemonSpeciesName?.text = entry.name
        pokemonFetchDate?.text = Self.dateFormatter.string(from: entry.dateTime)
        backgroundStatus?.text = entry.isBackground ? "Background" : "Manual"

        pokemonImage?.image = entry.pokemonImage
    }
}
