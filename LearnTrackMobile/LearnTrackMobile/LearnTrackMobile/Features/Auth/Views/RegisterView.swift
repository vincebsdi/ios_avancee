import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var nom = ""
    @State private var prenom = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations personnelles")) {
                    TextField("Prénom", text: $prenom)
                    TextField("Nom", text: $nom)
                }
                
                Section(header: Text("Compte")) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    SecureField("Mot de passe", text: $password)
                    SecureField("Confirmer mot de passe", text: $confirmPassword)
                }
                
                if let errorMessage = authViewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
                
                Section {
                    Button(action: {
                        Task {
                            await authViewModel.register(email: email, password: password, nom: nom, prenom: prenom)
                            if authViewModel.isAuthenticated {
                                dismiss()
                            }
                        }
                    }) {
                        if authViewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("S'inscrire")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(!isFormValid || authViewModel.isLoading)
                }
            }
            .navigationTitle("Inscription")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && !nom.isEmpty && !prenom.isEmpty && password == confirmPassword
    }
}
