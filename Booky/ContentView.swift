//
//  ContentView.swift
//  Booky
//
//  Created by Ivan Trajanovski  on 28.05.24.
//

import SwiftUI

struct ContentView: View {
    @State private var isShowingAddBookSheet = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                InboxView()
                    .tabItem {
                        Image(systemName: "tray.full")
                        Text("Inbox")
                    }
                
                LibraryView()
                    .tabItem {
                        Image(systemName: "book")
                        Text("Library")
                    }
            }
            Button {
                isShowingAddBookSheet = true
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .tint(Color.white)
                    .frame(width: 30, height: 30)
            }
            .frame(width: 60, height: 60)
            .background(Color.blue)
            .clipShape(Circle())
        }
        .sheet(isPresented: $isShowingAddBookSheet) {
            AddBookSheetView()
        }
    }
}
