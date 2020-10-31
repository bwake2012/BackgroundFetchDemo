//
//  PokemonFetchTask.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/29/20.
//

import Foundation

extension Notification.Name {
    static let newPokemonFetched = Notification.Name("com.andyibanez.newPokemonFetched")
}

struct PokemonFetchTask: BackgroundManagerTaskProtocol {

    var taskID: String { return "net.cockleburr.BackgroundFetchDemo.pokemonFetch" }

    private let firstDelayInterval: TimeInterval = 30   // 30 seconds
    private let delayInterval: TimeInterval = 60 * 60   // one hour

    var firstDateTime: Date {

        return Date(timeIntervalSinceNow: firstDelayInterval)
    }

    var nextDateTime: Date {

        return Date(timeIntervalSinceNow: delayInterval)
    }

    func performTask(completion: ((Bool) -> Void)?) {

        let randomPoke = (1...151).randomElement() ?? 1
        PokeManager.pokemon(id: randomPoke) { (pokemon) in

            guard let frontDefault = pokemon.sprites.frontDefault else {
                print("Missing pokemon \(pokemon.species.name) front default image URL.")
                completion?(false)
                return
            }

            PokeManager.downloadImage(url: frontDefault) { image in

                var taskLedger = BackgroundTaskLedger()
                taskLedger.addEntry(message: pokemon.species.name)
                taskLedger.save()

                NotificationCenter.default.post(
                        name: .newPokemonFetched,
                        object: self,
                        userInfo: ["pokemon": pokemon, "frontDefault": image]
                    )

                completion?(true)
            }

        }
    }

    func cancelTask() {

        PokeManager.urlSession.invalidateAndCancel()
    }
}
