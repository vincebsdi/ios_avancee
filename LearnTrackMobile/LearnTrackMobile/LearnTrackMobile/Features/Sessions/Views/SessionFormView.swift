import SwiftUI

struct SessionFormView: View {
    @EnvironmentObject var viewModel: SessionViewModel
    @EnvironmentObject var formateurVM: FormateurViewModel
    @EnvironmentObject var clientVM: ClientViewModel
    @EnvironmentObject var ecoleVM: EcoleViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var titre = ""
    @State private var description = ""
    @State private var dateDebut = Date()
    @State private var dateFin = Date().addingTimeInterval(86400) // +1 day
    @State private var heureDebut = Date()
    @State private var heureFin = Date().addingTimeInterval(3600) // +1 hour
    @State private var selectedFormateurId: Int?
    @State private var selectedClientId: Int?
    @State private var selectedEcoleId: Int?
    @State private var nbParticipants = ""
    @State private var prix = ""
    @State private var notes = ""
    @State private var statut = "Planifiée"
    
    let statuts = ["Planifiée", "Confirmée", "Terminée", "Annulée"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations générales")) {
                    TextField("Titre", text: $titre)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section(header: Text("Dates et horaires")) {
                    DatePicker("Date début", selection: $dateDebut, displayedComponents: .date)
                    DatePicker("Date fin", selection: $dateFin, displayedComponents: .date)
                    DatePicker("Heure début", selection: $heureDebut, displayedComponents: .hourAndMinute)
                    DatePicker("Heure fin", selection: $heureFin, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Statut")) {
                    Picker("Statut", selection: $statut) {
                        ForEach(statuts, id: \.self) { statut in
                            Text(statut).tag(statut)
                        }
                    }
                }
                
                Section(header: Text("Intervenants")) {
                    Picker("Formateur", selection: $selectedFormateurId) {
                        Text("Aucun").tag(Optional<Int>.none)
                        ForEach(formateurVM.formateurs) { formateur in
                            Text(formateur.fullName).tag(Optional(formateur.id))
                        }
                    }
                    
                    Picker("Client", selection: $selectedClientId) {
                        Text("Aucun").tag(Optional<Int>.none)
                        ForEach(clientVM.clients) { client in
                            Text(client.nom).tag(Optional(client.id))
                        }
                    }
                    
                    Picker("École", selection: $selectedEcoleId) {
                        Text("Aucune").tag(Optional<Int>.none)
                        ForEach(ecoleVM.ecoles) { ecole in
                            Text(ecole.nom).tag(Optional(ecole.id))
                        }
                    }
                }
                
                Section(header: Text("Détails")) {
                    TextField("Nombre de participants", text: $nbParticipants)
                        .keyboardType(.numberPad)
                    TextField("Prix", text: $prix)
                        .keyboardType(.decimalPad)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Nouvelle Session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        Task {
                            await saveSession()
                        }
                    }
                    .disabled(titre.isEmpty)
                }
            }
        }
        .task {
            if formateurVM.formateurs.isEmpty {
                await formateurVM.fetchFormateurs()
            }
            if clientVM.clients.isEmpty {
                await clientVM.fetchClients()
            }
            if ecoleVM.ecoles.isEmpty {
                await ecoleVM.fetchEcoles()
            }
        }
    }
    
    func saveSession() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        let sessionCreate = SessionCreate(
            titre: titre,
            description: description.isEmpty ? nil : description,
            dateDebut: dateFormatter.string(from: dateDebut),
            dateFin: dateFormatter.string(from: dateFin),
            heureDebut: timeFormatter.string(from: heureDebut),
            heureFin: timeFormatter.string(from: heureFin),
            clientId: selectedClientId,
            ecoleId: selectedEcoleId,
            formateurId: selectedFormateurId,
            nbParticipants: Int(nbParticipants),
            statut: statut,
            prix: Double(prix),
            notes: notes.isEmpty ? nil : notes
        )
        
        let success = await viewModel.createSession(sessionCreate)
        if success {
            dismiss()
        }
    }
}
