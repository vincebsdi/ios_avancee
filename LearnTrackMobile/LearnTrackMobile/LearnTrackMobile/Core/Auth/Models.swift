import Foundation

// MARK: - Auth Models

struct AuthResponse: Codable {
    let success: Bool
    let message: String
    let user: User?
}

struct User: Codable, Identifiable {
    let id: Int
    let email: String
    let nom: String
    let prenom: String
    let role: String
    let actif: Bool
    
    var fullName: String {
        "\(prenom) \(nom)"
    }
}
