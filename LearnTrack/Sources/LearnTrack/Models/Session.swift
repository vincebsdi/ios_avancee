import Foundation

enum Modalite: String, Codable, CaseIterable {
    case presentiel = "Présentiel"
    case distanciel = "Distanciel"
}

enum SessionStatus: String, Codable {
    case planifiee = "Planifiée"
    case confirmee = "Confirmée"
    case terminee = "Terminée"
    case annulee = "Annulée"
}

struct Session: Identifiable, Codable {
    var id: UUID?
    var module: String
    var date: Date
    var startTime: Date
    var endTime: Date
    var modalite: Modalite
    var status: SessionStatus
    var lieu: String?
    
    // Relations (IDs)
    var formateurId: UUID?
    var clientId: UUID?
    var ecoleId: UUID?
    
    // Tarifs
    var tarifClient: Double?
    var tarifSousTraitant: Double?
    var frais: Double?
    
    // Computed properties for display could be added in extensions
    
    enum CodingKeys: String, CodingKey {
        case id
        case module
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case modalite
        case status
        case lieu
        case formateurId = "formateur_id"
        case clientId = "client_id"
        case ecoleId = "ecole_id"
        case tarifClient = "tarif_client"
        case tarifSousTraitant = "tarif_sous_traitant"
        case frais
    }
}
