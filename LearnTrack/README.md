# LearnTrack Mobile

Application iOS pour la gestion de sessions de formation, développée en SwiftUI avec Supabase.

## Configuration

1.  Ouvrez `Sources/LearnTrack/Services/SupabaseService.swift`.
2.  Remplacez `your-project-ref` et `your-anon-key` par vos identifiants Supabase.

## Structure du Projet

-   **Models**: Définitions des données (Session, Formateur, Client, Ecole).
-   **ViewModels**: Logique métier et communication avec Supabase.
-   **Views**: Interface utilisateur SwiftUI.
-   **Services**: Gestion du client Supabase.

## Fonctionnalités Implémentées

-   Authentification (Email/Mot de passe).
-   Gestion des Sessions (Liste, Détail, Création).
-   Gestion des Formateurs (Liste, Filtrage).
-   Gestion des Clients (Liste, Recherche).
-   Profil Utilisateur (Déconnexion, Mode Sombre).

## Prérequis

-   Xcode 14.0+
-   iOS 16.0+
-   Compte Supabase configuré avec les tables requises (`sessions`, `formateurs`, `clients`, `ecoles`).
