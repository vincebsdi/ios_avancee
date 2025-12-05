import Foundation

// MARK: - API Service

class APIService {
    static let shared = APIService()
    private let baseURL = "https://www.formateurs-numerique.com/api"

    private init() {}

    // MARK: - Generic Request

    private func request<T: Decodable>(_ endpoint: String, method: String = "GET", body: [String: Any]? = nil) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200, 201:
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        case 204:
            throw APIError.noContent
        case 400:
            throw APIError.badRequest
        case 404:
            throw APIError.notFound
        default:
            throw APIError.serverError(httpResponse.statusCode)
        }
    }

    private func requestNoContent(_ endpoint: String, method: String, body: [String: Any]? = nil) async throws {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 204 else {
            throw APIError.serverError(httpResponse.statusCode)
        }
    }

    // MARK: - Auth

    func login(email: String, password: String) async throws -> AuthResponse {
        let body: [String: Any] = ["email": email, "password": password]
        return try await request("/auth/login", method: "POST", body: body)
    }

    func register(email: String, password: String, nom: String, prenom: String) async throws -> AuthResponse {
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "nom": nom,
            "prenom": prenom
        ]
        return try await request("/auth/register", method: "POST", body: body)
    }

    // MARK: - Sessions

    func getSessions() async throws -> [SessionModel] {
        try await request("/sessions")
    }

    func getSession(id: Int) async throws -> SessionModel {
        try await request("/sessions/\(id)")
    }

    func createSession(_ session: SessionCreate) async throws -> SessionModel {
        let body = session.toDictionary()
        return try await request("/sessions", method: "POST", body: body)
    }

    func updateSession(id: Int, _ session: SessionUpdate) async throws -> SessionModel {
        let body = session.toDictionary()
        return try await request("/sessions/\(id)", method: "PUT", body: body)
    }

    func deleteSession(id: Int) async throws {
        try await requestNoContent("/sessions/\(id)", method: "DELETE")
    }

    // MARK: - Formateurs

    func getFormateurs() async throws -> [FormateurModel] {
        try await request("/formateurs")
    }

    func getFormateur(id: Int) async throws -> FormateurModel {
        try await request("/formateurs/\(id)")
    }

    func createFormateur(_ formateur: FormateurCreate) async throws -> FormateurModel {
        let body = formateur.toDictionary()
        return try await request("/formateurs", method: "POST", body: body)
    }

    func updateFormateur(id: Int, _ formateur: FormateurUpdate) async throws -> FormateurModel {
        let body = formateur.toDictionary()
        return try await request("/formateurs/\(id)", method: "PUT", body: body)
    }

    func deleteFormateur(id: Int) async throws {
        try await requestNoContent("/formateurs/\(id)", method: "DELETE")
    }

    func getFormateurSessions(formateurId: Int) async throws -> [SessionModel] {
        try await request("/formateurs/\(formateurId)/sessions")
    }

    // MARK: - Clients

    func getClients() async throws -> [ClientModel] {
        try await request("/clients")
    }

    func getClient(id: Int) async throws -> ClientModel {
        try await request("/clients/\(id)")
    }

    func createClient(_ client: ClientCreate) async throws -> ClientModel {
        let body = client.toDictionary()
        return try await request("/clients", method: "POST", body: body)
    }

    func updateClient(id: Int, _ client: ClientUpdate) async throws -> ClientModel {
        let body = client.toDictionary()
        return try await request("/clients/\(id)", method: "PUT", body: body)
    }

    func deleteClient(id: Int) async throws {
        try await requestNoContent("/clients/\(id)", method: "DELETE")
    }

    func getClientSessions(clientId: Int) async throws -> [SessionModel] {
        try await request("/clients/\(clientId)/sessions")
    }

    // MARK: - Ecoles

    func getEcoles() async throws -> [EcoleModel] {
        try await request("/ecoles")
    }

    func getEcole(id: Int) async throws -> EcoleModel {
        try await request("/ecoles/\(id)")
    }

    func createEcole(_ ecole: EcoleCreate) async throws -> EcoleModel {
        let body = ecole.toDictionary()
        return try await request("/ecoles", method: "POST", body: body)
    }

    func updateEcole(id: Int, _ ecole: EcoleUpdate) async throws -> EcoleModel {
        let body = ecole.toDictionary()
        return try await request("/ecoles/\(id)", method: "PUT", body: body)
    }

    func deleteEcole(id: Int) async throws {
        try await requestNoContent("/ecoles/\(id)", method: "DELETE")
    }

    func getEcoleSessions(ecoleId: Int) async throws -> [SessionModel] {
        try await request("/ecoles/\(ecoleId)/sessions")
    }
}

// MARK: - Errors

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noContent
    case badRequest
    case notFound
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL invalide"
        case .invalidResponse:
            return "Réponse invalide du serveur"
        case .noContent:
            return "Aucun contenu"
        case .badRequest:
            return "Requête invalide"
        case .notFound:
            return "Ressource non trouvée"
        case .serverError(let code):
            return "Erreur serveur (\(code))"
        }
    }
}
