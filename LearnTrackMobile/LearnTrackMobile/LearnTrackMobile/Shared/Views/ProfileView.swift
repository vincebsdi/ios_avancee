import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            List {
                // User info
                Section {
                    HStack(spacing: 15) {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            )
                        
                        if let user = authViewModel.currentUser {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(user.role.capitalized)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Preferences
                Section(header: Text("Préférences")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Mode Sombre", systemImage: "moon.fill")
                    }
                    
                    NavigationLink {
                        Text("Notifications")
                            .navigationTitle("Notifications")
                    } label: {
                        Label("Notifications", systemImage: "bell.fill")
                    }
                }
                
                // About
                Section(header: Text("À propos")) {
                    HStack {
                        Label("Version", systemImage: "info.circle")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link(destination: URL(string: "https://www.formateurs-numerique.com")!) {
                        Label("Site web", systemImage: "globe")
                    }
                }
                
                // Logout
                Section {
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        HStack {
                            Spacer()
                            Label("Se déconnecter", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Profil")
        }
    }
}
