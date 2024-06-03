//
//  LibraryView.swift
//  Booky
//
//  Created by Ivan Trajanovski  on 28.05.24.
//

import SwiftUI
import SwiftData

struct LibraryView: View {
    @State private var status: Status = .inProgress
    @State private var statuses: [Status] = [.inProgress, .completed]
    @Query private var books: [Book]
    @Query(filter: #Predicate<Book> { book in
        book.status.descr == "Reading"
    }) var readingBooks: [Book]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Status", selection: $status) {
                    ForEach(statuses, id: \.self) { status in
                        Text(status.descr)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 150))
                    ], spacing: 20) {
                        ForEach(readingBooks, id: \.self.id) { book in
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
