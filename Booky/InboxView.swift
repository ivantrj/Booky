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
    @State private var isShowingAddBookSheet = false
    @Query(filter: #Predicate<Book> { book in
        book.status == "want to read"
    }) private var books: [Book]
    @State private var bookToEdit: Book?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    List {
                        ForEach(books) { book in
                            BookCellView(book: book)
                                .onTapGesture {
                                    bookToEdit = book
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(action: {
                                        context.delete(book)
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                context.delete(books[index])
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color("BackgroundColor"))
                    .cornerRadius(20)
                    .padding(.top)
                    
                    Spacer()
                    
                    if books.isEmpty {
                        ContentUnavailableView {
                            Label("No books", systemImage: "books.vertical")
                            Text("Start adding books to see your reading list.")
                            Button("Add Book") {
                                isShowingAddBookSheet = true
                            }
                            .buttonStyle(AddBookButtonStyle())
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Books")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingAddBookSheet = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(isPresented: $isShowingAddBookSheet) {
                AddBookSheetView()
            }
            .sheet(item: $bookToEdit) { book in
                UpdateBookSheetView(book: book)
            }
        }
    }
}

struct BookCellView: View {
    let book: Book
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(book.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(book.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color("CellBackgroundColor"))
        .cornerRadius(10)
    }
}

struct AddBookSheetView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var status = Book.wantToRead
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Book Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                Picker("Status", selection: $status) {
                    ForEach(Book.allStatuses, id: \.self) { status in
                        Text(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .navigationTitle("New Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
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

struct UpdateBookSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var book: Book
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Book Name", text: $book.name)
                DatePicker("Date", selection: $book.date, displayedComponents: .date)
                Picker("Status", selection: $book.status) {
                    ForEach(Book.allStatuses, id: \.self) { status in
                        Text(status)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .navigationTitle("Update Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ContentUnavailableView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 16) {
            content
        }
        .padding()
        .background(Color("CellBackgroundColor"))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct AddBookButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.accentColor)
            .cornerRadius(10)
    }
}
