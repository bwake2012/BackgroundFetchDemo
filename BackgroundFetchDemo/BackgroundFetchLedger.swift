//
//  PokemonFetchLedger.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/28/20.
//

import UIKit

class BackgroundFetchLedger {

    static var ledgerURL: URL = {

        let documentURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        guard let folderURL = documentURLs.first else {
            preconditionFailure("Document folder in User Domain NOT FOUND!")
        }

        return folderURL.appendingPathComponent("BackgroundTaskLedger").appendingPathExtension("JSON")
    }()


    struct PokemonFetchEntry: Codable {

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

        let dateTime: Date
        let isBackground: Bool
        let name: String
        let pokemonID: Int

        var spriteURL: URL {

            return Self.pokemonSpriteFolderURL.appendingPathComponent("\(pokemonID)").appendingPathExtension("jpg")
        }
    }

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

        addEntry(PokemonFetchEntry(dateTime: Date(), isBackground: isBackground, name: name, pokemonID: pokemonID))
    }
}
