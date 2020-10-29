//
//  TaskLedgerTask.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/29/20.
//

import Foundation

struct TaskLedgerTask: BackgroundManagerTaskProtocol {

    private var ledgerURL: URL { return BackgroundTaskLedger.ledgerURL }

    private let delayInterval: TimeInterval = 15 * 60

    // MARK:
    var taskID: String { return "net.cockleburr.BackgroundFetchDemo.backgroundFetch" }

    var nextDateTime: Date {

        return Date(timeIntervalSinceNow: delayInterval)
    }

    func performTask(completion: ((Bool) -> Void)?) {

        var ledger = BackgroundTaskLedger(ledgerURL: ledgerURL)
        ledger.addEntry()
        ledger.save(ledgerURL: ledgerURL)

        completion?(true)
    }



}
