//
//  SportingGoodStoreApp.swift
//  SportingGoodStore
//
//  Created by Nicola Kaleta on 07/02/2024.
//

import SwiftUI
import TipKit

@main
struct SportingGoodStoreApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        try? Tips.configure()
    }
}
