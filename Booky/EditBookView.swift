////
////  EditBookView.swift
////  Booky
////
////  Created by Ivan Trajanovski  on 28.05.24.
////
//
//import SwiftUI
//
//struct EditBookView: View {
//    @Binding var book: Book?
//    @State private var name = ""
//    @State private var author = ""
//    @State private var notes = ""
//    @State private var status = BookStatus.wantToRead
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .leading) {
//                TextField("Book Name", text: $name)
//                    .padding()
//                TextField("Author", text: $author)
//                    .padding()
//                TextField("Notes", text: $notes)
//                    .padding()
//                Picker("Status", selection: $status) {
//                    ForEach(BookStatus.allCases, id: \.self) { status in
//                        Text(status.rawValue)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
//                Spacer()
//                Button("Save") {
//                    saveBook()
//                    presentationMode.wrappedValue.dismiss()
//                }
//                .padding()
//            }
//            .navigationBarTitle("Edit Book")
//            .onAppear {
//                loadBookData()
//            }
//            .padding()
//        }
//    }
//
//    private func loadBookData() {
//        if let book = book {
//            name = book.name ?? ""
//            author = book.author ?? ""
//            notes = book.notes ?? ""
//            status = BookStatus(rawValue: String(book.status)) ?? .wantToRead
//        }
//    }
//
//    private func saveBook() {
//        if var book = book {
//            book.name = name
//            book.author = author
//            book.notes = notes
//            book.status = Int16(status.hashValue)
//
//            CoreDataManager.shared.saveContext()
//        }
//    }
//}
