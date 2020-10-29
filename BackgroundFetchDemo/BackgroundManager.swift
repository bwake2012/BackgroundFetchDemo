//
//  BackgroundManager.swift
//  TodayWidgetDemo3
//
//  Created by Bob Wakefield on 10/27/20.
//

import Foundation
import BackgroundTasks

protocol BackgroundManagerTaskProtocol {

    // Must be a string registered in info.plist
    // under "Permitted background task scheduler identifiers"
    var taskID: String { get }

    // Date of earliest next execution
    var nextDateTime: Date { get }

    // Function to perform the task
    func performTask(completion: ((Bool) -> Void)?)
}

class BackgroundManager {

    let task: BackgroundManagerTaskProtocol

    init(_ task: BackgroundManagerTaskProtocol) {

        self.task = task
    }

    func applicationDidFinishLaunching() {

        registerBackgroundFetch()
    }

    func sceneDidEnterBackground() {

        scheduleBackgroundFetch(on: self.task.nextDateTime)
    }

    func sceneWillEnterForeground() {

        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
}

// retister background fetch
extension BackgroundManager {

    fileprivate func registerBackgroundFetch() {

        // MARK: Registering Launch Handlers for Tasks
        let success =
            BGTaskScheduler.shared.register(forTaskWithIdentifier: self.task.taskID, using: nil) { task in
                // Downcast the parameter to an app refresh task as this identifier is used for a refresh request.
                self.performBackgroundFetch(bgTask: task)
            }

        let message = "Registered background fetch task " + (success ? "successfully" : "unsuccessfully")

        guard success else { preconditionFailure(message) }

        print(message)
    }
}

// schedule background fetch
extension BackgroundManager {

    fileprivate func scheduleBackgroundFetch(on date: Date) {

        let taskDate = max(date, Date(timeIntervalSinceNow: 15.0 * 60.0)) // Fetch no earlier than 15 minutes from now

        let request = BGAppRefreshTaskRequest(identifier: self.task.taskID)
        request.earliestBeginDate = taskDate

        do {
            try BGTaskScheduler.shared.submit(request)
            print("Successfully scheduled background fetch on \(taskDate).")

        } catch {

            print("Could not schedule background fetch: \(error)")
        }
    }
}

// do the background fetch
extension BackgroundManager {

    func performBackgroundFetch(bgTask: BGTask?) {

        bgTask?.expirationHandler = {
            print("Background task expired: \(self.task.taskID)")
            bgTask?.setTaskCompleted(success: false)
        }

        self.task.performTask { success in

            guard let bgTask = bgTask else { return }

            bgTask.setTaskCompleted(success: true)

            self.scheduleBackgroundFetch(on: self.task.nextDateTime)
        }
    }
}
