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
    var status: String
    
    static let wantToRead = "want to read"
    static let reading = "reading"
    static let read = "read"
    
    static let allStatuses = ["want to read", "reading", "read"]
    static let libraryStatuses = ["reading", "read"]
    
    init(name: String, date: Date, status: String) {
        self.name = name
        self.date = date
        self.status = status
    }
}
