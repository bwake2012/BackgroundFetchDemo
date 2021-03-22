//
//  SharedPNG.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 1/19/20.
//  Copyright © 2020 Cockleburr Software. All rights reserved.
//

import Foundation
import UIKit

enum PNGError: Error {

    case noPNGDataInImage
    case noImageInPNGData

    var localizedDescription: String {
        switch self {
        case .noPNGDataInImage:
            return "Unable to extract PNG data from UIImage"
        case .noImageInPNGData:
            return "Unable to create UIImage from data"
        }
    }
}

class SavedPNG {

    fileprivate let savedData: SavedData

    required init(url: URL) {

        self.savedData = SavedData(url)
    }

    func saveImage(_ image: UIImage) -> Result<UIImage, Error> {

        guard let data = image.pngData() else {

            return .failure(PNGError.noPNGDataInImage)
        }

        let result = savedData.writeData(data)
        switch result {
        case .failure(let error):
            return .failure(error)
        default:
            return .success(image)
         }
    }

    func getImage() -> Result<UIImage, Error> {

        let result = savedData.readData()

        switch result {

        case .failure(let error):
            return .failure(error)

        case .success(let data):
            guard let image = UIImage(data: data) else { return .failure(PNGError.noImageInPNGData)}

            return .success(image)
        }
    }

    func metadata() -> Result<[FileAttributeKey: Any], Error> {

        return savedData.metadata()
    }

    func remove() -> Error? {

        return savedData.remove()
    }
}
