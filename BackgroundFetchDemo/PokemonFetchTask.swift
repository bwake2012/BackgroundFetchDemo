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

    private var pokemonDownloader: CodableObjectDownloader<Pokemon>? = CodableObjectDownloader<Pokemon>()
    private var pokemonImageDownloader: ImageDownloader? = ImageDownloader()

    var taskID: String { return "net.cockleburr.BackgroundFetchDemo.pokemonFetchTask" }

    private let firstDelayInterval: TimeInterval = 30   // 30 seconds
    private let delayInterval: TimeInterval = 60 * 60   // one hour

    var firstDateTime: Date {

        return Date(timeIntervalSinceNow: firstDelayInterval)
    }

    var nextDateTime: Date {

        return Date(timeIntervalSinceNow: delayInterval)
    }

    private func buildURL(id: Int) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pokeapi.co"
        urlComponents.path = "/api/v2/pokemon/\(id)"
        return urlComponents.url!
    }

    func performTask(isBackground: Bool = false, completion: ((Bool) -> Void)?) {

        let randomPoke = (1...151).randomElement() ?? 1

        pokemonDownloader?.fetchObject(from: buildURL(id: randomPoke)) { result in

            switch result {
            case .failure(let error):
                print("pokemon fetch error: \(error.localizedDescription)")
                completion?(false)
            case .success(let pokemon):

                guard let imageURL = pokemon.sprites.frontDefault else {
                    completion?(false)
                    return
                }

                self.pokemonImageDownloader?.fetchImage(from: imageURL) { result in

                    switch result {
                    case .failure(let error):
                        print("image fetch error: \(error.localizedDescription)")
                        completion?(false)
                    case .success(let image):

                        stashPokemon(isBackground: isBackground, pokemonID: randomPoke, pokemon: pokemon, image: image)

                        NotificationCenter.default.post(
                            name: .newPokemonFetched,
                            object: self,
                            userInfo: ["pokemon": pokemon, "frontDefault": image]
                        )

                        completion?(true)
                    }
                }
            }
        }
    }

    func stashPokemon(isBackground: Bool, pokemonID: Int, pokemon: Pokemon, image: UIImage) {

        let pokemonLedger = BackgroundFetchLedger.shared
        let ledgerEntry =
            BackgroundFetchLedger.PokemonFetchEntry(
                dateTime: Date(),
                isBackground: isBackground,
                name: pokemon.species.name,
                pokemonID: pokemonID
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
    }

    func cancelTask() {

        PokeManager.urlSession.invalidateAndCancel()
    }
}
