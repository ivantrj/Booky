//
//  ContentView.swift
//  Booky
//
//  Created by Ivan Trajanovski  on 28.05.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
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

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
       
    }
}
