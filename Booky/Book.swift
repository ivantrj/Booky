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
    var status: Status
    
    init(name: String, date: Date, status: Status = .wantToRead) {
        self.name = name
        self.date = date
        self.status = status
    }
}

enum Status: Int, Codable, Identifiable, CaseIterable {
    case wantToRead, inProgress, completed
    var id: Self {
        self
    }
    var descr: String {
        switch self {
        case .wantToRead:
            "Want to Read"
        case .inProgress:
            "Reading"
        case .completed:
            "Completed"
        }
    }
}
