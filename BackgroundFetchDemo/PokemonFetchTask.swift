//
//  PokemonFetchTask.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/29/20.
//

import Foundation

extension Notification.Name {
    static let newPokemonFetched = Notification.Name("net.cockleburr.BackgroundFetchDemo.randomPokemonFetched")
}

struct PokemonFetchTask: BackgroundManagerTaskProtocol {

    var taskID: String { return "net.cockleburr.BackgroundFetchDemo.pokemonFetchTask" }

    private let firstDelayInterval: TimeInterval = 30   // 30 seconds
    private let delayInterval: TimeInterval = 60 * 60   // one hour

    var firstDateTime: Date {

        return Date(timeIntervalSinceNow: firstDelayInterval)
    }

    var nextDateTime: Date {

        return Date(timeIntervalSinceNow: delayInterval)
    }

    func performTask(isBackground: Bool = false, completion: ((Bool) -> Void)?) {

        let randomPoke = (1...151).randomElement() ?? 1
        PokeManager.pokemon(id: randomPoke) { (pokemon) in

            guard let frontDefault = pokemon.sprites.frontDefault else {
                print("Missing pokemon \(pokemon.species.name) front default image URL.")
                completion?(false)
                return
            }

            PokeManager.downloadImage(url: frontDefault) { image in

                let pokemonLedger = BackgroundFetchLedger.shared
                let ledgerEntry =
                    BackgroundFetchLedger.PokemonFetchEntry(
                            dateTime: Date(),
                            isBackground: isBackground,
                            name: pokemon.species.name,
                            pokemonID: randomPoke
                        )
                pokemonLedger.addEntry(ledgerEntry)
                pokemonLedger.save()

                let spriteURL = ledgerEntry.spriteURL
                let imageData = image.jpegData(compressionQuality: 1.0)

                do {
                    try imageData?.write(to: spriteURL)
                } catch {
                    print("Error \(error.localizedDescription) saving sprite image to cache: \(spriteURL.path)")
                }

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
