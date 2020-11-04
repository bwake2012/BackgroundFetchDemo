//
//  NSObject+className.swift
//  BackgroundFetchDemo
//
//  Created by Bob Wakefield on 11/4/20.
//

import Foundation

/// Return the name of the class in a string

extension NSObject {

    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}
