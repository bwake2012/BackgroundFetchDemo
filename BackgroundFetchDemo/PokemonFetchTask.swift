//
//  PokemonFetchTask.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 10/29/20.
//

import UIKit

extension Notification.Name {
    static let newPokemonFetched = Notification.Name("net.cockleburr.BackgroundFetchDemo.randomPokemonFetched")
}

struct PokemonFetchTask: BackgroundManagerTaskProtocol {

    var taskID: String { return "net.cockleburr.BackgroundFetchDemo.pokemonFetchTask" }

    private let firstDelaySeconds = 30   // 30 seconds
    private let delayIntervalHours = 1   // one hour

    var firstDateTime: Date {

        return Calendar.current.date(byAdding: .second, value: firstDelaySeconds, to: Date())!
    }

    var nextDateTime: Date {

        return Calendar.current.date(byAdding: .hour, value: delayIntervalHours, to: Date())!
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

                let maskedImage = image.transparent(samplePoint: CGPoint(x: 1, y: 1))

                let pokemonLedger = BackgroundFetchLedger.shared
                let ledgerEntry =
                    PokemonFetchEntry(
                            dateTime: Date(),
                            isBackground: isBackground,
                            name: pokemon.species.name.capitalized,
                            pokemonID: randomPoke
                        )
                pokemonLedger.addEntry(ledgerEntry)
                pokemonLedger.save()

                let spriteURL = ledgerEntry.spriteURL
                let imageData = maskedImage.pngData()

                do {
                    try imageData?.write(to: spriteURL)
                } catch {
                    print("Error \(error.localizedDescription) saving sprite image to cache: \(spriteURL.path)")
                }

                pokemonLedger.saveShared(pokemon: ledgerEntry, image: maskedImage)

                NotificationCenter.default.post(
                        name: .newPokemonFetched,
                        object: self,
                        userInfo: ["pokemon": pokemon, "frontDefault": maskedImage]
                    )

                completion?(true)
            }

        }
    }

    func cancelTask() {

        PokeManager.urlSession.invalidateAndCancel()
    }
}
