import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            SessionListView()
                .tabItem {
                    Label("Sessions", systemImage: "calendar")
                }
            
            FormateurListView()
                .tabItem {
                    Label("Formateurs", systemImage: "person.2")
                }
            
            ClientListView()
                .tabItem {
                    Label("Clients", systemImage: "building.2")
                }
            
            // Placeholder for Ecoles
            Text("Ecoles")
                .tabItem {
                    Label("Ecoles", systemImage: "graduationcap")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.circle")
                }
        }
    }
}
