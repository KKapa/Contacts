//
//  Array+Extensions.swift
//  AppContacts
//
//  Created by Dzmitry Paplauski on 1.05.22.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        if indices.contains(index) {
            return self[index]
        }
        return nil
    }
}
