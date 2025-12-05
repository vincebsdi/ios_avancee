import Foundation

struct Client: Identifiable, Codable {
    var id: UUID?
    var raisonSociale: String
    var ville: String
    var adresse: String?
    var contactNom: String?
    var contactEmail: String?
    var contactTel: String?
    var siret: String?
    var tva: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case raisonSociale = "raison_sociale"
        case ville
        case adresse
        case contactNom = "contact_nom"
        case contactEmail = "contact_email"
        case contactTel = "contact_tel"
        case siret
        case tva
    }
}
