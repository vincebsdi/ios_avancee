//
//  LearnTrackMobileApp.swift
//  LearnTrackMobile
//
//  Created by Utilisateur invité on 04/12/2025.
//

import SwiftUI

@main
struct LearnTrackMobileApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}
