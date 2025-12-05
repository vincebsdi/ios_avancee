import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = APIService.shared
    
    init() {
        // Check if user is stored in UserDefaults
        checkStoredUser()
    }
    
    private func checkStoredUser() {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
            self.isAuthenticated = true
        }
    }
    
    private func storeUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }
    
    private func clearStoredUser() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
    
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await apiService.login(email: email, password: password)
            if response.success, let user = response.user {
                self.currentUser = user
                self.isAuthenticated = true
                storeUser(user)
            } else {
                self.errorMessage = response.message
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func register(email: String, password: String, nom: String, prenom: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await apiService.register(email: email, password: password, nom: nom, prenom: prenom)
            if response.success, let user = response.user {
                self.currentUser = user
                self.isAuthenticated = true
                storeUser(user)
            } else {
                self.errorMessage = response.message
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
        clearStoredUser()
    }
}
