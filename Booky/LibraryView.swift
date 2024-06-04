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
    @State var book: Book
    @State private var isShowingDetails = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(15)
                .shadow(radius: 5)
            
            VStack(spacing: 8) {
                if let imageUrl = book.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(10)
                        } else {
                            ProgressView()
                                .frame(height: 150)
                        }
                    }
                } else {
                    Image(systemName: "book.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .foregroundColor(.white)
                }
                
                Text(book.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if let author = book.author {
                    Text("by \(author)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
        .onTapGesture {
            isShowingDetails = true
        }
        .sheet(isPresented: $isShowingDetails) {
            BookDetailsView(book: book)
        }
    }
}

struct BookDetailsView: View {
    @State var book: Book
    @State private var rating: Int = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        book.rating = Double(rating)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                if let imageUrl = book.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .cornerRadius(15)
                        } else if phase.error != nil {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .foregroundColor(.red)
                        } else {
                            ProgressView()
                                .frame(height: 300)
                        }
                    }
                } else {
                    Image(systemName: "book.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .foregroundColor(.purple)
                }
                
                Text(book.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
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
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(10)
                    }
                } else {
                    Text("Link: N/A")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(10)
                }
                
                RatingView(rating: $rating)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Notes")
                        .font(.headline)
                    TextEditor(text: Binding(
                        get: { book.notes ?? "" },
                        set: { book.notes = $0 }
                    ))
                    .frame(height: 150)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
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
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
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
        .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(20)
        .padding()
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
