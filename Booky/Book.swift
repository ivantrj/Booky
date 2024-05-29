//
//  Book.swift
//  Booky
//
//  Created by Ivan Trajanovski  on 29.05.24.
//

import Foundation
import SwiftData

@Model
class Book {
    var name: String
    var date: Date
    
    init(name: String, date: Date) {
        self.name = name
        self.date = date
    }
}
