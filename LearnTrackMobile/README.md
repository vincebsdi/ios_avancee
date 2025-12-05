# LearnTrack Mobile - Application iOS

Application iOS de gestion de sessions de formation développée en SwiftUI avec architecture MVVM.

## 🎯 Fonctionnalités

### ✅ Implémentées
- **Authentification** : Login/Register avec persistance de session
- **Sessions** : CRUD complet, liste, détail, formulaire, partage
- **Formateurs** : Liste, fiche détaillée, actions contact, CRUD
- **Clients** : Liste, fiche, actions contact, CRUD
- **Écoles** : Liste, fiche, CRUD
- **Profil** : Déconnexion, préférences

### 🔑 Fonctionnalités clés
- Architecture MVVM
- API REST (`https://www.formateurs-numerique.com/api`)
- Recherche et filtres
- Actions rapides (appel, email)
- Interface intuitive avec SwiftUI
- Support du mode sombre
- Pull-to-refresh

## 📁 Structure du Projet

```
LearnTrackMobile/
├── App/
│   ├── LearnTrackMobileApp.swift    # Point d'entrée
│   └── ContentView.swift             # Vue principale
├── Core/
│   ├── Auth/
│   │   └── Models.swift              # User, AuthResponse
│   └── Network/
│       └── APIService.swift          # Service API REST
├── Features/
│   ├── Auth/
│   │   ├── ViewModels/
│   │   │   └── AuthViewModel.swift
│   │   └── Views/
│   │       ├── LoginView.swift
│   │       └── RegisterView.swift
│   ├── Sessions/
│   │   ├── Models/
│   │   │   └── SessionModel.swift
│   │   ├── ViewModels/
│   │   │   └── SessionViewModel.swift
│   │   └── Views/
│   │       ├── SessionListView.swift
│   │       ├── SessionDetailView.swift
│   │       └── SessionFormView.swift
│   ├── Formateurs/
│   │   ├── Models/
│   │   │   └── FormateurModel.swift
│   │   ├── ViewModels/
│   │   │   └── FormateurViewModel.swift
│   │   └── Views/
│   │       ├── FormateurListView.swift
│   │       ├── FormateurDetailView.swift
│   │       └── FormateurFormView.swift
│   ├── Clients/
│   │   ├── Models/
│   │   │   └── ClientModel.swift
│   │   ├── ViewModels/
│   │   │   └── ClientViewModel.swift
│   │   └── Views/
│   │       ├── ClientListView.swift
│   │       ├── ClientDetailView.swift
│   │       └── ClientFormView.swift
│   └── Ecoles/
│       ├── Models/
│       │   └── EcoleModel.swift
│       ├── ViewModels/
│       │   └── EcoleViewModel.swift
│       └── Views/
│           ├── EcoleListView.swift
│           ├── EcoleDetailView.swift
│           └── EcoleFormView.swift
└── Shared/
    └── Views/
        ├── MainTabView.swift         # Navigation principale
        └── ProfileView.swift         # Profil utilisateur
```

## 🚀 Configuration

### Prérequis
- Xcode 14.0+
- iOS 16.0+
- API REST accessible à `https://www.formateurs-numerique.com/api`

### Installation
1. Ouvrez `LearnTrackMobile.xcodeproj` dans Xcode
2. Compilez le projet (⌘+B)
3. Lancez sur un simulateur ou appareil (⌘+R)

## 🔐 Authentification

L'application utilise l'endpoint `/auth/login` de l'API REST :

```swift
POST /auth/login
Body: {
    "email": "user@example.com",
    "password": "password"
}
```

La session est persistée dans `UserDefaults` pour permettre la reconnexion automatique.

## 📱 Navigation

L'application utilise un `TabView` avec 5 onglets :
1. **Sessions** - Liste et gestion des sessions de formation
2. **Formateurs** - Annuaire des formateurs
3. **Clients** - Liste des clients
4. **Écoles** - Gestion des établissements
5. **Profil** - Paramètres utilisateur

## 🎨 Design

- **Architecture** : MVVM (Model-View-ViewModel)
- **UI Framework** : SwiftUI
- **Style** : Human Interface Guidelines d'Apple
- **Thème** : Support du mode clair et sombre
- **Typographie** : San Francisco (système)

## 🔧 API Endpoints Utilisés

### Authentification
- `POST /auth/login` - Connexion
- `POST /auth/register` - Inscription

### Sessions
- `GET /sessions` - Liste des sessions
- `GET /sessions/{id}` - Détail d'une session
- `POST /sessions` - Créer une session
- `PUT /sessions/{id}` - Modifier une session
- `DELETE /sessions/{id}` - Supprimer une session

### Formateurs
- `GET /formateurs` - Liste des formateurs
- `GET /formateurs/{id}` - Détail d'un formateur
- `GET /formateurs/{id}/sessions` - Sessions d'un formateur
- `POST /formateurs` - Créer un formateur
- `PUT /formateurs/{id}` - Modifier un formateur
- `DELETE /formateurs/{id}` - Supprimer un formateur

### Clients
- `GET /clients` - Liste des clients
- `GET /clients/{id}` - Détail d'un client
- `GET /clients/{id}/sessions` - Sessions d'un client
- `POST /clients` - Créer un client
- `PUT /clients/{id}` - Modifier un client
- `DELETE /clients/{id}` - Supprimer un client

### Écoles
- `GET /ecoles` - Liste des écoles
- `GET /ecoles/{id}` - Détail d'une école
- `GET /ecoles/{id}/sessions` - Sessions d'une école
- `POST /ecoles` - Créer une école
- `PUT /ecoles/{id}` - Modifier une école
- `DELETE /ecoles/{id}` - Supprimer une école

## 📄 Modèles de Données

### Session
```swift
struct SessionModel {
    let id: Int
    let titre: String
    let dateDebut: String        // Format: "YYYY-MM-DD"
    let dateFin: String
    let heureDebut: String?      // Format: "HH:MM:SS"
    let heureFin: String?
    let statut: String           // Planifiée, Confirmée, Terminée, Annulée
    let prix: Double?
    let clientId: Int?
    let ecoleId: Int?
    let formateurId: Int?
    // ...
}
```

### Formateur
```swift
struct FormateurModel {
    let id: Int
    let nom: String
    let prenom: String
    let email: String
    let specialites: [String]?
    let tarifJournalier: Double?
    // ...
}
```

### Client
```swift
struct ClientModel {
    let id: Int
    let nom: String              // Raison sociale
    let ville: String?
    let siret: String?
    let contactNom: String?
    let contactEmail: String?
    // ...
}
```

### École
```swift
struct EcoleModel {
    let id: Int
    let nom: String
    let ville: String?
    let capacite: Int?
    let responsableNom: String?
    // ...
}
```

## 🧪 Tests

- Tests unitaires : `LearnTrackMobileTests/`
- Tests UI : `LearnTrackMobileUITests/`

## 📝 TODO - Améliorations Futures

- [ ] Gestion hors-ligne avec CoreData
- [ ] Notifications push
- [ ] Widget iOS
- [ ] Siri Shortcuts
- [ ] Export PDF des sessions
- [ ] Filtres avancés (par date, formateur, client)
- [ ] Statistiques et dashboard
- [ ] Intégration calendrier
- [ ] Face ID / Touch ID

## 👥 Auteurs

Projet développé dans le cadre de LearnTrack Mobile (Décembre 2025)

## 📄 Licence

Propriétaire - Tous droits réservés
