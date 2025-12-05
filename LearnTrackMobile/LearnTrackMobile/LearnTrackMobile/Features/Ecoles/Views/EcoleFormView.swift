import SwiftUI

struct EcoleFormView: View {
    @EnvironmentObject var viewModel: EcoleViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var nom = ""
    @State private var email = ""
    @State private var telephone = ""
    @State private var adresse = ""
    @State private var ville = ""
    @State private var codePostal = ""
    @State private var responsableNom = ""
    @State private var capacite = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("École")) {
                    TextField("Nom", text: $nom)
                    TextField("Capacité", text: $capacite)
                        .keyboardType(.numberPad)
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
                
                Section(header: Text("Responsable")) {
                    TextField("Nom du responsable", text: $responsableNom)
                }
                
                Section(header: Text("Notes")) {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Nouvelle École")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        Task {
                            await saveEcole()
                        }
                    }
                    .disabled(nom.isEmpty)
                }
            }
        }
    }
    
    func saveEcole() async {
        let ecoleCreate = EcoleCreate(
            nom: nom,
            adresse: adresse.isEmpty ? nil : adresse,
            ville: ville.isEmpty ? nil : ville,
            codePostal: codePostal.isEmpty ? nil : codePostal,
            telephone: telephone.isEmpty ? nil : telephone,
            email: email.isEmpty ? nil : email,
            responsableNom: responsableNom.isEmpty ? nil : responsableNom,
            capacite: Int(capacite),
            notes: notes.isEmpty ? nil : notes
        )
        
        let success = await viewModel.createEcole(ecoleCreate)
        if success {
            dismiss()
        }
    }
}
