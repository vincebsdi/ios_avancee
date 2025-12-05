import Foundation

enum FormateurType: String, Codable {
    case interne = "Interne"
    case externe = "Externe"
}

struct Formateur: Identifiable, Codable {
    var id: UUID?
    var nom: String
    var prenom: String
    var specialite: String
    var type: FormateurType
    var email: String
    var telephone: String?
    var adresse: String?
    
    // Infos pro
    var tauxHoraire: Double?
    var nda: String?
    var siret: String?
    var societe: String? // Si externe
    
    var fullName: String {
        return "\(prenom) \(nom)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case nom
        case prenom
        case specialite
        case type
        case email
        case telephone
        case adresse
        case tauxHoraire = "taux_horaire"
        case nda
        case siret
        case societe
    }
}
