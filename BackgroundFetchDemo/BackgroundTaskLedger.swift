//
//  BackgroundTaskLedger.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/28/20.
//

import UIKit

struct BackgroundTaskLedger {

    static var ledgerURL: URL = {

        let documentURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        guard let folderURL = documentURLs.first else {
            preconditionFailure("Document folder in User Domain NOT FOUND!")
        }

        return folderURL.appendingPathComponent("BackgroundTaskLedger").appendingPathExtension("JSON")
    }()


    struct LedgerEntry: Codable {

        let dateTime: Date
        let message: String
    }

    var entries: [LedgerEntry]

    init() {

        let savedJSON = SavedJSON(url: Self.ledgerURL)

        let result: Result<[LedgerEntry], Error> = savedJSON.getObject()
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

        let result: Result<[LedgerEntry], Error> = savedJSON.saveObject(self.entries)
        switch result {
        case .failure(let error):
            print("Error saving ledger entries: " + error.localizedDescription)
        case .success:
            print("Ledger entries successfully saved!")
        }
    }

    mutating func addEntry(message: String = "") {

        entries.insert(LedgerEntry(dateTime: Date(), message: message), at: 0)
    }
}
