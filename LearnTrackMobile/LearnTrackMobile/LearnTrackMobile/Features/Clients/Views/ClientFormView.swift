import SwiftUI

struct ClientFormView: View {
    @EnvironmentObject var viewModel: ClientViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nom = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var adresse = ""
    @State private var ville = ""
    @State private var codePostal = ""
    @State private var siret = ""
    @State private var contactNom = ""
    @State private var contactEmail = ""
    @State private var contactTelephone = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Entreprise")) {
                    TextField("Raison sociale", text: $nom)
                    TextField("SIRET", text: $siret)
                }
                
                Section(header: Text("Contact")) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    TextField("Téléphone", text: $telephone)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Adresse")) {
                    TextField("Adresse", text: $adresse)
                    TextField("Code postal", text: $codePostal)
                        .keyboardType(.numberPad)
                    TextField("Ville", text: $ville)
                }
                
                Section(header: Text("Contact principal")) {
                    TextField("Nom du contact", text: $contactNom)
                    TextField("Email du contact", text: $contactEmail)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    TextField("Téléphone du contact", text: $contactTelephone)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Nouveau Client")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        Task {
                            await saveClient()
                        }
                    }
                    .disabled(nom.isEmpty)
                }
            }
        }
    }
    
    func saveClient() async {
        let clientCreate = ClientCreate(
            nom: nom,
            email: email.isEmpty ? nil : email,
            telephone: telephone.isEmpty ? nil : telephone,
            adresse: adresse.isEmpty ? nil : adresse,
            ville: ville.isEmpty ? nil : ville,
            codePostal: codePostal.isEmpty ? nil : codePostal,
            siret: siret.isEmpty ? nil : siret,
            contactNom: contactNom.isEmpty ? nil : contactNom,
            contactEmail: contactEmail.isEmpty ? nil : contactEmail,
            contactTelephone: contactTelephone.isEmpty ? nil : contactTelephone,
            notes: notes.isEmpty ? nil : notes
        )
        
        let success = await viewModel.createClient(clientCreate)
        if success {
            dismiss()
        }
    }
}
