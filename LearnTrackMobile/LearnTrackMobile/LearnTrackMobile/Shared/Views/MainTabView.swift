import SwiftUI

struct MainTabView: View {
    @StateObject private var sessionVM = SessionViewModel()
    @StateObject private var formateurVM = FormateurViewModel()
    @StateObject private var clientVM = ClientViewModel()
    @StateObject private var ecoleVM = EcoleViewModel()
    
    var body: some View {
        TabView {
            SessionListView()
                .environmentObject(sessionVM)
                .environmentObject(formateurVM)
                .environmentObject(clientVM)
                .environmentObject(ecoleVM)
                .tabItem {
                    Label("Sessions", systemImage: "calendar")
                }
            
            FormateurListView()
                .environmentObject(formateurVM)
                .tabItem {
                    Label("Formateurs", systemImage: "person.2")
                }
            
            ClientListView()
                .environmentObject(clientVM)
                .tabItem {
                    Label("Clients", systemImage: "building.2")
                }
            
            EcoleListView()
                .environmentObject(ecoleVM)
                .tabItem {
                    Label("Écoles", systemImage: "graduationcap")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person.circle")
                }
        }
    }
}
