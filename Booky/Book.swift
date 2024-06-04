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
    var author: String?
    var imageUrl: String?
    var link: String?
    var rating: Double?
    var notes: String?
    var favoriteQuotes: String?
    
    static let wantToRead = "want to read"
    static let reading = "reading"
    static let read = "read"
    
    static let allStatuses = ["want to read", "reading", "read"]
    static let libraryStatuses = ["reading", "read"]
    
    init(name: String, date: Date, status: String, author: String? = nil, imageUrl: String? = nil, link: String? = nil, rating: Double? = nil, notes: String? = nil, favoriteQuotes: String? = nil) {
        self.name = name
        self.date = date
        self.status = status
        self.author = author
        self.imageUrl = imageUrl
        self.link = link
        self.rating = rating
        self.notes = notes
        self.favoriteQuotes = favoriteQuotes
    }
}
