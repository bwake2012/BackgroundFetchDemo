//
//  CommonConstants.swift
//  TodayWidgetDemo
//
//  Created by Bob Wakefield on 1/10/20.
//  Copyright © 2020 Cockleburr Software. All rights reserved.
//

import Foundation

struct CommonConstants {

    static let widgetBundleIdentifier = "net.cockleburr.BackgroundFetchDemo.TodayWidgetDemoWidget"
    static let appGroupIdentifier     = "group.net.cockleburr.BackgroundFetchDemo"
    static let todayWidgetDemoURL     = "todayWidgetDemo://home"

    static let demoContentFile       = "demoContentFile.txt"
    static let demoContentObjectFile = "demoContentObjectFile.archive"
    static let demoContentJSONFile   = "demoContentJFile.json"
    static let demoContentPNGFile    = "demoContentPNGFile.png"

    static let demoContentPokemonJSON  = "demoContentPokemon.json"
    static let demoContentPokemonImage = "demoContentPokemon.png"

    static let simpleDemoWidgetKind = "BackgroundFetchDemoTodayWidget"

    static func sharedURL(appGroupIdentifier: String = Self.appGroupIdentifier, path: String, fileExt: String? = nil) -> URL {
        
        guard var contentURL: URL = FileManager.default.containerURL(
                    forSecurityApplicationGroupIdentifier: appGroupIdentifier
        ) else {
            preconditionFailure("Unable to obtain URL for app group: \(appGroupIdentifier)")
        }

        contentURL = contentURL.appendingPathComponent(path)

        if let fileExt = fileExt {

            contentURL = contentURL.appendingPathExtension(fileExt)
        }

        return contentURL
    }

    static func documentURL(path: String, fileExt: String? = nil) -> URL {

        let documentURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        guard var folderURL = documentURLs.first else {
            preconditionFailure("Document folder in User Domain NOT FOUND!")
        }

        folderURL = folderURL.appendingPathComponent(path)

        if let fileExt = fileExt {

            folderURL = folderURL.appendingPathExtension(fileExt)
        }

        return folderURL
    }
}
