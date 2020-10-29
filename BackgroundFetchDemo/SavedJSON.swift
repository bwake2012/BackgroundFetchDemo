//
//  SharedJSON.swift
//  TodayWidgetDemo
//
//  Created by Robert Wakefield on 1/13/20.
//  Copyright © 2020 State Farm. All rights reserved.
//

import UIKit

class SavedJSON {

    fileprivate let savedData: SavedData

    required init(url: URL) {

        self.savedData = SavedData(url)
    }

    func saveObject<T>(_ object: T) -> Result<T, Error> where T : Encodable {

        let archiver = JSONEncoder()

        do {

            let data = try archiver.encode(object)

            let result = savedData.writeData(data)
            switch result {
            case .failure(let error):
                return .failure(error)
            default:
                return .success(object)
            }
        }
        catch {
            return .failure(error)
        }
    }

    func getObject<T>() -> Result<T, Error> where T : Decodable {

        let result = savedData.readData()

        switch result {

        case .failure(let error):
            return .failure(error)

        case .success(let data):
            do {

                let unarchiver = JSONDecoder()

                let object = try unarchiver.decode(T.self, from: data)

                return .success(object)

            } catch {

                print("error is: \(error.localizedDescription)")
                return .failure(error)
            }
        }
    }

    func metadata() -> Result<[FileAttributeKey: Any], Error> {

        return savedData.metadata()
    }

    func remove() -> Error? {

        return savedData.remove()
    }

}
