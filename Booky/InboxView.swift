//
//  InboxView.swift
//  Booky
//
//  Created by Ivan Trajanovski  on 28.05.24.
//

import SwiftUI
import SwiftData

struct InboxView: View {
    @Environment(\.modelContext) var context
    @State private var isShowingItemSheet = false
    @Query private var books: [Book]
    @State private var bookToEdit: Book?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    BookCell(book: book)
                        .onTapGesture {
                            bookToEdit = book
                        }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        context.delete(books[index])
                    }
                }
            }
            .navigationTitle("Books")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) { AddBookSheet() }
            .sheet(item: $bookToEdit) { book in
                UpdateBookSheet(book: book)
            }
            .toolbar {
                if !books.isEmpty {
                    Button("Add Book", systemImage: "plus") {
                        isShowingItemSheet = true
                    }
                }
            }
            .overlay {
                if books.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No books", systemImage: "books.vertical")
                    }, description: {
                        Text("Start adding books to see your reading list.")
                    }, actions: {
                        Button("Add Book") { isShowingItemSheet = true }
                    })
                    .offset(y: -60)
                }
            }
        }
    }
}

struct BookCell: View {
    let book: Book
    
    var body: some View {
        HStack {
            Text(book.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(book.name)
            Spacer()
            Text(book.status.descr)
        }
    }
}

struct AddBookSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var status: Status = .wantToRead
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Book Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                Picker("Status", selection: $status) {
                    ForEach(Status.allCases, id: \.self) { status in
                        Text(status.descr)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .navigationTitle("New Book")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let book = Book(name: name, date: date, status: status)
                        context.insert(book)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct UpdateBookSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var book: Book
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Book Name", text: $book.name)
                DatePicker("Date", selection: $book.date, displayedComponents: .date)
                Picker("Status", selection: $book.status) {
                    ForEach(Status.allCases, id: \.self) { status in
                        Text(status.descr)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .navigationTitle("New Book")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}