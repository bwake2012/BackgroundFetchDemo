//
//  BackgroundTaskLedger.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/28/20.
//

import Foundation

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
    }

    var entries: [LedgerEntry]

    init(ledgerURL: URL) {

        let savedJSON = SavedJSON(url: ledgerURL)

        let result: Result<[LedgerEntry], Error> = savedJSON.getObject()
        switch result {
        case .failure(let error):
            self.entries = []
            print("Error reading ledger entries: " + error.localizedDescription)
        case .success(let ledgerEntries):
            self.entries = ledgerEntries
        }
    }

    func save(ledgerURL: URL) {

        let savedJSON = SavedJSON(url: ledgerURL)

        let result: Result<[LedgerEntry], Error> = savedJSON.saveObject(self.entries)
        switch result {
        case .failure(let error):
            print("Error saving ledger entries: " + error.localizedDescription)
        case .success:
            print("Ledger entries successfully saved!")
        }
    }

    mutating func addEntry() {

        entries.append(LedgerEntry(dateTime: Date()))
    }
}
