# API Gestion Formations

## URL de base
```
https://www.formateurs-numerique.com/api
```

## Documentation interactive
- **Swagger UI** : https://www.formateurs-numerique.com/docs
- **ReDoc** : https://www.formateurs-numerique.com/redoc

---

## Endpoints disponibles

### Health Check
| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/health` | Vérifier que l'API fonctionne |
| GET | `/health/db` | Vérifier la connexion BDD |

### Authentification
| Méthode | Endpoint | Description |
|---------|----------|-------------|
| POST | `/auth/login` | Connexion (email + password) |
| POST | `/auth/register` | Inscription |

### Users
| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/users` | Liste des utilisateurs |
| GET | `/users/{id}` | Détail d'un utilisateur |
| POST | `/users` | Créer un utilisateur |
| PUT | `/users/{id}` | Modifier un utilisateur |
| DELETE | `/users/{id}` | Supprimer un utilisateur |

### Clients
| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/clients` | Liste des clients |
| GET | `/clients/{id}` | Détail d'un client |
| POST | `/clients` | Créer un client |
| PUT | `/clients/{id}` | Modifier un client |
| DELETE | `/clients/{id}` | Supprimer un client |
| GET | `/clients/{id}/sessions` | Sessions d'un client |

### Ecoles
| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/ecoles` | Liste des écoles |
| GET | `/ecoles/{id}` | Détail d'une école |
| POST | `/ecoles` | Créer une école |
| PUT | `/ecoles/{id}` | Modifier une école |
| DELETE | `/ecoles/{id}` | Supprimer une école |
| GET | `/ecoles/{id}/sessions` | Sessions d'une école |

### Formateurs
| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/formateurs` | Liste des formateurs |
| GET | `/formateurs/{id}` | Détail d'un formateur |
| POST | `/formateurs` | Créer un formateur |
| PUT | `/formateurs/{id}` | Modifier un formateur |
| DELETE | `/formateurs/{id}` | Supprimer un formateur |
| GET | `/formateurs/{id}/sessions` | Sessions d'un formateur |

### Sessions
| Méthode | Endpoint | Description |
|---------|----------|-------------|
| GET | `/sessions` | Liste des sessions |
| GET | `/sessions/{id}` | Détail d'une session |
| POST | `/sessions` | Créer une session |
| PUT | `/sessions/{id}` | Modifier une session |
| DELETE | `/sessions/{id}` | Supprimer une session |

---

## Exemples Swift (iOS)

### Configuration de base

```swift
import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "https://www.formateurs-numerique.com/api"

    private init() {}
}
```

### LOGIN - Connexion

```swift
func login(email: String, password: String) async throws -> User? {
    let response = try await APIService.shared.login(email: email, password: password)
    if response.success {
        return response.user
    }
    return nil
}

// Utilisation
let user = try await login(email: "test@example.com", password: "monmotdepasse")
print("Connecté: \(user?.prenom ?? "") \(user?.nom ?? "")")
```

### REGISTER - Inscription

```swift
func register(email: String, password: String, nom: String, prenom: String) async throws -> User? {
    let response = try await APIService.shared.register(
        email: email,
        password: password,
        nom: nom,
        prenom: prenom
    )
    if response.success {
        return response.user
    }
    return nil
}
```

### GET - Récupérer la liste des clients

```swift
func getClients() async throws -> [Client] {
    guard let url = URL(string: "\(baseURL)/clients") else {
        throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode([Client].self, from: data)
}

// Modèle
struct Client: Codable, Identifiable {
    let id: Int
    let nom: String
    let email: String?
    let telephone: String?
    let ville: String?
    let actif: Bool
}
```

### GET - Récupérer un client par ID

```swift
func getClient(id: Int) async throws -> Client {
    guard let url = URL(string: "\(baseURL)/clients/\(id)") else {
        throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(Client.self, from: data)
}
```

### POST - Créer un client

```swift
func createClient(nom: String, email: String?, ville: String?) async throws -> Client {
    guard let url = URL(string: "\(baseURL)/clients") else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body: [String: Any?] = [
        "nom": nom,
        "email": email,
        "ville": ville
    ]

    request.httpBody = try JSONSerialization.data(withJSONObject: body.compactMapValues { $0 })

    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(Client.self, from: data)
}
```

### PUT - Modifier un client

```swift
func updateClient(id: Int, nom: String?, email: String?) async throws -> Client {
    guard let url = URL(string: "\(baseURL)/clients/\(id)") else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    var body: [String: Any] = [:]
    if let nom = nom { body["nom"] = nom }
    if let email = email { body["email"] = email }

    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(Client.self, from: data)
}
```

### DELETE - Supprimer un client

```swift
func deleteClient(id: Int) async throws {
    guard let url = URL(string: "\(baseURL)/clients/\(id)") else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"

    let (_, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 204 else {
        throw URLError(.badServerResponse)
    }
}
```

---

## Modèles de données complets

### Client
```swift
struct Client: Codable, Identifiable {
    let id: Int
    let nom: String
    let email: String?
    let telephone: String?
    let adresse: String?
    let ville: String?
    let codePostal: String?
    let siret: String?
    let contactNom: String?
    let contactEmail: String?
    let contactTelephone: String?
    let notes: String?
    let actif: Bool

    enum CodingKeys: String, CodingKey {
        case id, nom, email, telephone, adresse, ville, siret, notes, actif
        case codePostal = "code_postal"
        case contactNom = "contact_nom"
        case contactEmail = "contact_email"
        case contactTelephone = "contact_telephone"
    }
}
```

### Ecole
```swift
struct Ecole: Codable, Identifiable {
    let id: Int
    let nom: String
    let adresse: String?
    let ville: String?
    let codePostal: String?
    let telephone: String?
    let email: String?
    let responsableNom: String?
    let capacite: Int?
    let notes: String?
    let actif: Bool

    enum CodingKeys: String, CodingKey {
        case id, nom, adresse, ville, telephone, email, capacite, notes, actif
        case codePostal = "code_postal"
        case responsableNom = "responsable_nom"
    }
}
```

### Formateur
```swift
struct Formateur: Codable, Identifiable {
    let id: Int
    let nom: String
    let prenom: String
    let email: String
    let telephone: String?
    let specialites: [String]?
    let tarifJournalier: Double?
    let adresse: String?
    let ville: String?
    let codePostal: String?
    let notes: String?
    let actif: Bool

    enum CodingKeys: String, CodingKey {
        case id, nom, prenom, email, telephone, specialites, adresse, ville, notes, actif
        case tarifJournalier = "tarif_journalier"
        case codePostal = "code_postal"
    }
}
```

### Session
```swift
struct Session: Codable, Identifiable {
    let id: Int
    let titre: String
    let description: String?
    let dateDebut: String  // Format: "YYYY-MM-DD"
    let dateFin: String
    let heureDebut: String?  // Format: "HH:MM:SS"
    let heureFin: String?
    let clientId: Int?
    let ecoleId: Int?
    let formateurId: Int?
    let nbParticipants: Int?
    let statut: String
    let prix: Double?
    let notes: String?

    enum CodingKeys: String, CodingKey {
        case id, titre, description, statut, prix, notes
        case dateDebut = "date_debut"
        case dateFin = "date_fin"
        case heureDebut = "heure_debut"
        case heureFin = "heure_fin"
        case clientId = "client_id"
        case ecoleId = "ecole_id"
        case formateurId = "formateur_id"
        case nbParticipants = "nb_participants"
    }
}
```

---

## Exemples avec curl (Terminal)

```bash
# Tester l'API
curl https://www.formateurs-numerique.com/api/health

# LOGIN - Connexion
curl -X POST https://www.formateurs-numerique.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "monmotdepasse"}'

# REGISTER - Inscription
curl -X POST https://www.formateurs-numerique.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email": "nouveau@example.com", "password": "motdepasse", "nom": "Dupont", "prenom": "Jean"}'

# Liste des clients
curl https://www.formateurs-numerique.com/api/clients

# Détail d'un client
curl https://www.formateurs-numerique.com/api/clients/1

# Créer un client
curl -X POST https://www.formateurs-numerique.com/api/clients \
  -H "Content-Type: application/json" \
  -d '{"nom": "Mon Client", "ville": "Paris"}'

# Modifier un client
curl -X PUT https://www.formateurs-numerique.com/api/clients/1 \
  -H "Content-Type: application/json" \
  -d '{"nom": "Nouveau Nom"}'

# Supprimer un client
curl -X DELETE https://www.formateurs-numerique.com/api/clients/1
```

---

## Codes de réponse HTTP

| Code | Signification |
|------|---------------|
| 200 | Succès (GET, PUT) |
| 201 | Créé avec succès (POST) |
| 204 | Supprimé avec succès (DELETE) |
| 400 | Requête invalide |
| 404 | Ressource non trouvée |
| 500 | Erreur serveur |
