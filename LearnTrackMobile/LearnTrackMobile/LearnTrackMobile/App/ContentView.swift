//
//  ContentView.swift
//  LearnTrackMobile
//
//  Created by Utilisateur invité on 04/12/2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                LoginView()
            }
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
