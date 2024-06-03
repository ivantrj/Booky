//
//  LibraryView.swift
//  Booky
//
//  Created by Ivan Trajanovski  on 28.05.24.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @State private var status = Book.reading
    @Query private var books: [Book]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Status", selection: $status) {
                    ForEach(Book.libraryStatuses, id: \.self) { status in
                        Text(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 150))
                    ], spacing: 20) {
                        ForEach(filteredBooks, id: \.self.id) { book in
                            BookGridCard(book: book)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Library")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var filteredBooks: [Book] {
            switch status {
            case Book.reading:
                return books.filter { book in
                    book.status == "reading"
                }
            case Book.wantToRead:
                return books.filter { book in
                    book.status == "wantToRead"
                }
            case Book.read:
                return books.filter { book in
                    book.status == "read"
                }
            default:
                return books
            }
        }
}

struct BookGridCard: View {
    var book: Book
    
    var body: some View {
        ZStack {
            Color(.secondarySystemBackground)
                .cornerRadius(10)
                .shadow(radius: 5)
            VStack {
                Image(systemName: "book")
                    .font(.title)
                Text(book.name)
                    .font(.callout)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
            }
            .padding()
        }
    }
}
