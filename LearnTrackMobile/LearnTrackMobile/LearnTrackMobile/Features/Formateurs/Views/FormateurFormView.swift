import SwiftUI

struct FormateurFormView: View {
    @EnvironmentObject var viewModel: FormateurViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nom = ""
    @State private var prenom = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var adresse = ""
    @State private var ville = ""
    @State private var codePostal = ""
    @State private var specialitesText = ""
    @State private var tarifJournalier = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Identité")) {
                    TextField("Prénom", text: $prenom)
                    TextField("Nom", text: $nom)
                }
                
                Section(header: Text("Contact")) {
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                    TextField("Téléphone", text: $telephone)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Adresse")) {
                    TextField("Adresse", text: $adresse)
                    TextField("Code postal", text: $codePostal)
                        .keyboardType(.numberPad)
                    TextField("Ville", text: $ville)
                }
                
                Section(header: Text("Informations professionnelles")) {
                    TextField("Spécialités (séparées par des virgules)", text: $specialitesText)
                    TextField("Tarif journalier", text: $tarifJournalier)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Nouveau Formateur")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        Task {
                            await saveFormateur()
                        }
                    }
                    .disabled(nom.isEmpty || prenom.isEmpty || email.isEmpty)
                }
            }
        }
    }
    
    func saveFormateur() async {
        let specialites = specialitesText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        let formateurCreate = FormateurCreate(
            nom: nom,
            prenom: prenom,
            email: email,
            telephone: telephone.isEmpty ? nil : telephone,
            specialites: specialites.isEmpty ? nil : specialites,
            tarifJournalier: Double(tarifJournalier),
            adresse: adresse.isEmpty ? nil : adresse,
            ville: ville.isEmpty ? nil : ville,
            codePostal: codePostal.isEmpty ? nil : codePostal,
            notes: notes.isEmpty ? nil : notes
        )
        
        let success = await viewModel.createFormateur(formateurCreate)
        if success {
            dismiss()
        }
    }
}
