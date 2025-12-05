import SwiftUI

struct FormateurListView: View {
    @StateObject private var viewModel = FormateurViewModel()
    @State private var searchText = ""
    @State private var filter: FormateurType? = nil // nil = Tous
    
    var filteredFormateurs: [Formateur] {
        var result = viewModel.formateurs
        if let filter = filter {
            result = result.filter { $0.type == filter }
        }
        if !searchText.isEmpty {
            result = result.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        }
        return result
    }
    
    var body: some View {
        NavigationView {
            List(filteredFormateurs) { formateur in
                NavigationLink(destination: Text(formateur.fullName)) { // Placeholder detail
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(Text(String(formateur.prenom.prefix(1) + formateur.nom.prefix(1))))
                        
                        VStack(alignment: .leading) {
                            Text(formateur.fullName)
                                .font(.headline)
                            Text(formateur.specialite)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text(formateur.type.rawValue)
                            .font(.caption)
                            .padding(4)
                            .background(formateur.type == .interne ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Type", selection: $filter) {
                        Text("Tous").tag(Optional<FormateurType>.none)
                        Text("Internes").tag(Optional<FormateurType>.some(.interne))
                        Text("Externes").tag(Optional<FormateurType>.some(.externe))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 250)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Formateurs")
        }
        .task {
            await viewModel.fetchFormateurs()
        }
    }
}
