//
//  TaskLedgerTask.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/29/20.
//

import Foundation

struct TaskLedgerTask: BackgroundManagerTaskProtocol {

    private let firstDelayInterval: TimeInterval = 5 * 60
    private let delayInterval: TimeInterval = 5 * 60

    // MARK:
    var taskID: String { return "net.cockleburr.BackgroundFetchDemo.backgroundFetch" }

    var firstDateTime: Date {

        return Date(timeIntervalSinceNow: firstDelayInterval)
    }

    var nextDateTime: Date {

        return Date(timeIntervalSinceNow: delayInterval)
    }

    func performTask(completion: ((Bool) -> Void)?) {

        var ledger = BackgroundTaskLedger()
        ledger.addEntry()
        ledger.save()

        completion?(true)
    }

    func cancelTask() {}
}
