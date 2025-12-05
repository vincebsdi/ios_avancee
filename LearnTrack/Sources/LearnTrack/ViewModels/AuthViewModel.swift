import Foundation
import Supabase
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let client = SupabaseService.shared.client
    
    init() {
        Task {
            await checkSession()
        }
    }
    
    func checkSession() async {
        do {
            _ = try await client.auth.session
            isAuthenticated = true
        } catch {
            isAuthenticated = false
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        do {
            _ = try await client.auth.signIn(email: email, password: password)
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func signOut() async {
        do {
            try await client.auth.signOut()
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
