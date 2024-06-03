//
//  SettingsView.swift
//  Booky
//
//  Created by Ivan Trajanovski  on 28.05.24.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingAboutAuthor = false
    
    var body: some View {
        NavigationView {
            Form {
//                Section(header: Text("Goals")) {
//                    NavigationLink("Reading Goals", destination: ReadingGoalsView())
//                }
                
                Section(header: Text("About")) {
                    Button("About the Author") {
                        showingAboutAuthor.toggle()
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingAboutAuthor) {
                AboutAuthorView()
            }
        }
    }
}

#Preview {
    SettingsView()
}


