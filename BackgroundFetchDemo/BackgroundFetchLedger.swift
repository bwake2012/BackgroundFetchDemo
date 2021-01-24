//
//  PokemonFetchLedger.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/28/20.
//

import UIKit
import WidgetKit

class BackgroundFetchLedger {

    static var ledgerURL: URL = {

        let documentURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        guard let folderURL = documentURLs.first else {
            preconditionFailure("Document folder in User Domain NOT FOUND!")
        }

        return folderURL.appendingPathComponent("BackgroundTaskLedger").appendingPathExtension("JSON")
    }()

    var entries: [PokemonFetchEntry]

    static var shared = BackgroundFetchLedger()

    private init() {

        let savedJSON = SavedJSON(url: Self.ledgerURL)

        let result: Result<[PokemonFetchEntry], Error> = savedJSON.getObject()
        switch result {
        case .failure(let error):
            self.entries = []
            print("Error reading ledger entries: " + error.localizedDescription)
        case .success(var ledgerEntries):
            if (ledgerEntries.first?.dateTime ?? Date()) < (ledgerEntries.last?.dateTime ?? Date()) {

                ledgerEntries.sort { $0.dateTime > $1.dateTime }
            }
            self.entries = ledgerEntries

            if let latestEntry = ledgerEntries.first {

                if let latestData = try? Data(contentsOf: latestEntry.spriteSavedURL),
                   let latestImage = UIImage(data: latestData) {

                    saveToShared(pokemon: latestEntry, image: latestImage)
                }
            }
        }

    }

    func save() {

        let savedJSON = SavedJSON(url: Self.ledgerURL)

        let result: Result<[PokemonFetchEntry], Error> = savedJSON.saveObject(self.entries)
        switch result {
        case .failure(let error):
            print("Error saving ledger entries: " + error.localizedDescription)
        case .success:
            print("Ledger entries successfully saved!")
        }
    }

    func addEntry(_ entry: PokemonFetchEntry) {

        entries.insert(entry, at: 0)
    }

    func addEntry(isBackground: Bool = false, name: String = "", pokemonID: Int) {

        let newEntry = PokemonFetchEntry(dateTime: Date(), isBackground: isBackground, name: name, pokemonID: pokemonID)
        addEntry(newEntry)
    }
}

extension PokemonFetchEntry {

    static let pokemonSpriteFolderURL: URL = {

        let cacheURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        guard let folderURL = cacheURLs.first?.appendingPathComponent("PokemonSprites") else {
            preconditionFailure("Document folder in User Domain NOT FOUND!")
        }

        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating sprite cache directory: \(error.localizedDescription)")
        }

        return folderURL
    }()

    var spriteSavedURL: URL {

        return Self.pokemonSpriteFolderURL.appendingPathComponent("\(pokemonID)").appendingPathExtension("png")
    }
    var jpgSpriteURL: URL {

        return Self.pokemonSpriteFolderURL.appendingPathComponent("\(pokemonID)").appendingPathExtension("jpg")
    }

    var pokemonImage: UIImage? {

        var data = try? Data(contentsOf: spriteSavedURL)
        if nil == data {
            print("Error retrieving sprite from: \(spriteSavedURL)")
            data = try? Data(contentsOf: jpgSpriteURL)
        }

        if let data = data {
            return UIImage(data: data)
        } else {
            print("Error retrieving sprite from: \(Self.pokemonSpriteFolderURL)")
        }

        return nil
    }
}

extension BackgroundFetchLedger {

    func saveToShared(pokemon: PokemonFetchEntry, image: UIImage) {

        let sharedPokemon = SharedJSON(appGroupIdentifier: CommonConstants.appGroupIdentifier, path: CommonConstants.demoContentPokemonJSON)
        let sharedPNG = SharedPNG(appGroupIdentifier: CommonConstants.appGroupIdentifier, path: CommonConstants.demoContentPokemonImage)

        // only share the image if we saved the pokemon entry successfully
        if case .success(_) = sharedPokemon.saveObject(pokemon) {

            _ = sharedPNG.saveImage(image)
        }

        WidgetCenter.shared.reloadTimelines(ofKind: CommonConstants.simpleDemoWidgetKind)
    }
}
