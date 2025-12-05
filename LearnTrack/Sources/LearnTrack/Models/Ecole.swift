import Foundation

struct Ecole: Identifiable, Codable {
    var id: UUID?
    var nom: String
    var ville: String
    var adresse: String?
    var contactNom: String?
    var contactEmail: String?
    var contactTel: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case nom
        case ville
        case adresse
        case contactNom = "contact_nom"
        case contactEmail = "contact_email"
        case contactTel = "contact_tel"
    }
}
