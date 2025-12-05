import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Compte")) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            Text("Utilisateur") // Placeholder
                                .font(.headline)
                            Text("user@example.com") // Placeholder
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Préférences")) {
                    Toggle("Mode Sombre", isOn: $isDarkMode)
                }
                
                Section {
                    Button(action: {
                        Task {
                            await authViewModel.signOut()
                        }
                    }) {
                        Text("Se déconnecter")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profil")
        }
    }
}
