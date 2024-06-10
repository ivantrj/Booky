//
//  LibraryView.swift
//  Booky
//
//  Created by Ivan Trajanovski  on 28.05.24.
//

import SwiftUI
import SwiftData
import RevenueCatUI

struct LibraryView: View {
    @State private var status = Book.reading
    @Query private var books: [Book]
    @State private var isShowingSettings = false
    @State private var isShowingPremium = false

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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isShowingPremium = true
                    }) {
                        Image(systemName: "gift.fill")
                            .foregroundColor(.accentColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $isShowingPremium) {
                PaywallView()
            }
        }
    }

    private var filteredBooks: [Book] {
        switch status {
        case Book.reading:
            return books.filter { $0.status == "reading" }
        case Book.wantToRead:
            return books.filter { $0.status == "want to read" }
        case Book.read:
            return books.filter { $0.status == "read" }
        default:
            return books
        }
    }
}

struct BookGridCard: View {
    @State var book: Book
    @State private var isShowingDetails = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("CardBackgroundColor"))
                .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
            
            VStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("ImageBackgroundColor"))
                        .frame(height: 180)
                    
                    if let imageUrl = book.imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: 140, maxHeight: 180)
                                    .cornerRadius(12)
                            } else if phase.error != nil {
                                Image(systemName: "book.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 100, maxHeight: 140)
                                    .foregroundColor(.secondary)
                            } else {
                                ProgressView()
                                    .frame(maxWidth: 100, maxHeight: 140)
                            }
                        }
                    } else {
                        Image(systemName: "book.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 100, maxHeight: 140)
                            .foregroundColor(.secondary)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    
                    if let author = book.author {
                        Text("by \(author)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .onTapGesture {
            isShowingDetails = true
        }
        .sheet(isPresented: $isShowingDetails) {
            BookDetailsView(book: book)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 3)
        )
    }
}

struct BookDetailsView: View {
//    @Environment(\.managedObjectContext) private var viewContext
    @State var book: Book
    @State private var rating: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ZStack(alignment: .topTrailing) {
                    if let imageUrl = book.imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                                    .clipped()
                            } else if phase.error != nil {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                                    .foregroundColor(.red)
                            } else {
                                ProgressView()
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                            }
                        }
                    } else {
                        Image(systemName: "book.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
//                        viewContext.delete(book)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    .padding(.top, 16)
                    .padding(.trailing, 16)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(book.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    if let author = book.author {
                        Text("by \(author)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Author: N/A")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let link = book.link, let url = URL(string: link) {
                        Link(destination: url) {
                            Text("Learn more")
                                .font(.headline)
                                .foregroundColor(.accentColor)
                        }
                    } else {
                        Text("Link: N/A")
                            .font(.headline)
                            .foregroundColor(.accentColor)
                    }
                    
                    RatingView(rating: $rating)
                        .onChange(of: rating) { newValue in
                            book.rating = Double(newValue)
                        }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.headline)
                    TextEditor(text: Binding(
                        get: { book.notes ?? "" },
                        set: { book.notes = $0 }
                    ))
                    .frame(height: 150)
                    .background(Color("CellBackgroundColor"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .overlay(
                        VStack {
                            if book.notes?.isEmpty ?? true {
                                Text("Write your notes here...")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                            }
                            Spacer()
                        }
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Favorite Quotes")
                        .font(.headline)
                    TextEditor(text: Binding(
                        get: { book.favoriteQuotes ?? "" },
                        set: { book.favoriteQuotes = $0 }
                    ))
                    .frame(height: 150)
                    .background(Color("CellBackgroundColor"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .overlay(
                        VStack {
                            if book.favoriteQuotes?.isEmpty ?? true {
                                Text("Write your favorite quotes here...")
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                            }
                            Spacer()
                        }
                    )
                }
            }
            .padding()
        }
        .background(Color("BackgroundColor").ignoresSafeArea())
    }
}

struct RatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1..<6) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .foregroundColor(star <= rating ? .yellow : .gray)
                    .onTapGesture {
                        rating = star
                    }
            }
        }
        .font(.title)
    }
}
