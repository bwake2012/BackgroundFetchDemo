//
//  UIImage+transparent.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 11/6/20.
//

import UIKit

extension UIImage {

    func transparent(samplePoint: CGPoint) -> UIImage {

//        let color =

        let image = self

        var colorMasking: [CGFloat] = []

        guard
            let cgImage = image.cgImage, let pixelColors = cgImage.colors(at: [samplePoint])
        else {
            return image
        }

        for color in pixelColors {

            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {

                colorMasking.append(contentsOf: [red, green, blue, alpha])
                colorMasking.append(contentsOf: [red, green, blue, alpha])
            }
        }

        guard
            let maskedCGImage = cgImage.copy(maskingColorComponents: colorMasking)
        else {
            return image
        }

        return UIImage(cgImage: maskedCGImage)
    }
}
