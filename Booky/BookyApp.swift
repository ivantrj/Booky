//
//  BookyApp.swift
//  Booky
//
//  Created by Ivan Trajanovski  on 28.05.24.
//

import SwiftUI
import SwiftData
import RevenueCat
import RevenueCatUI

@main
struct BookyApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Book.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//                .presentPaywallIfNeeded(requiredEntitlementIdentifier: "premium")
        }
        .modelContainer(modelContainer)
    }
}
