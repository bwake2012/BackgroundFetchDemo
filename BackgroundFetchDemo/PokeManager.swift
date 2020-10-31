//
//  PokeManager.swift
//  AndyIbanezBackgroundTasks
//
//  Created by Bob Wakefield on 10/29/20.
//

import UIKit

class PokeManager {

    static let urlSession = URLSession(configuration: .default)

    static func pokemon(id: Int, completionHandler: @escaping (_ pokemon: Pokemon) -> Void) {

        let pokeURL = buildPokemonURL(id: id)
        let task = urlSession.dataTask(with: pokeURL) { (data, _, _) in
            let pokemon = try! JSONDecoder().decode(Pokemon.self, from: data!)
            DispatchQueue.main.async {
                completionHandler(pokemon)
            }
        }

        task.resume()
    }

    static func downloadImage(url: URL, completionHandler: @escaping (_ image: UIImage) -> Void) {

        let task = urlSession.dataTask(with: url) { data, _, _ in

            let image = UIImage(data: data!)!
            DispatchQueue.main.async {
                completionHandler(image)
            }
        }

        task.resume()
    }

    private static func buildPokemonURL(id: Int) -> URL {

        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pokeapi.co"
        urlComponents.path = "/api/v2/pokemon/\(id)"
        return urlComponents.url!
    }
}
