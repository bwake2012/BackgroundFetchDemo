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

    // Date of earliest first execution
    var firstDateTime: Date { get }

    // Date of earliest next execution
    var nextDateTime: Date { get }

    // Function to perform the task
    func performTask(completion: ((Bool) -> Void)?)

    func cancelTask()
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

        scheduleBackgroundFetch(on: self.task.firstDateTime)
    }

    func sceneWillEnterForeground() {

//        BGTaskScheduler.shared.cancelAllTaskRequests()
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

    static let dateFormatter: DateFormatter = {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        return dateFormatter
    }()

    fileprivate func scheduleBackgroundFetch(on date: Date) {

        let taskDate = max(date, Date(timeIntervalSinceNow: 5.0 * 60.0)) // Fetch no earlier than 5 minutes from now

        let request = BGAppRefreshTaskRequest(identifier: self.task.taskID)
        request.earliestBeginDate = taskDate

        do {
            try BGTaskScheduler.shared.submit(request)
            print("Successfully scheduled background fetch for \(Self.dateFormatter.string(from: taskDate)).")

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

            self.task.cancelTask()

            bgTask?.setTaskCompleted(success: false)
        }

        print("Performing Background Task: \(self.task.taskID) at \(Self.dateFormatter.string(from: Date()))")
        self.task.performTask { success in

            guard let bgTask = bgTask else { return }

            bgTask.setTaskCompleted(success: success)

            self.scheduleBackgroundFetch(on: self.task.nextDateTime)
        }
    }
}
