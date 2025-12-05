import SwiftUI

struct SessionFormView: View {
    @ObservedObject var viewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var module = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600)
    @State private var modalite: Modalite = .presentiel
    @State private var lieu = ""
    @State private var tarifClient = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations générales")) {
                    TextField("Module", text: $module)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    DatePicker("Début", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("Fin", selection: $endTime, displayedComponents: .hourAndMinute)
                    Picker("Modalité", selection: $modalite) {
                        ForEach(Modalite.allCases, id: \.self) { modalite in
                            Text(modalite.rawValue).tag(modalite)
                        }
                    }
                    if modalite == .presentiel {
                        TextField("Lieu", text: $lieu)
                    }
                }
                
                Section(header: Text("Tarifs")) {
                    TextField("Tarif Client", text: $tarifClient)
                        .keyboardType(.decimalPad)
                }
                
                // TODO: Add pickers for Formateur, Client, Ecole
            }
            .navigationTitle("Nouvelle Session")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer") {
                        let newSession = Session(
                            module: module,
                            date: date,
                            startTime: startTime,
                            endTime: endTime,
                            modalite: modalite,
                            status: .planifiee,
                            lieu: lieu.isEmpty ? nil : lieu,
                            tarifClient: Double(tarifClient)
                        )
                        Task {
                            await viewModel.createSession(newSession)
                            dismiss()
                        }
                    }
                    .disabled(module.isEmpty)
                }
            }
        }
    }
}
