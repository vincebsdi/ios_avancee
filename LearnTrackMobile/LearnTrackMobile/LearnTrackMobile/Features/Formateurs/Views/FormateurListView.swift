import SwiftUI

struct FormateurListView: View {
    @EnvironmentObject var viewModel: FormateurViewModel
    @State private var searchText = ""
    @State private var showAddSheet = false
    
    var filteredFormateurs: [FormateurModel] {
        if searchText.isEmpty {
            return viewModel.formateurs
        } else {
            return viewModel.formateurs.filter {
                $0.fullName.localizedCaseInsensitiveContains(searchText) ||
                ($0.specialites?.contains(where: { $0.localizedCaseInsensitiveContains(searchText) }) ?? false)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(filteredFormateurs) { formateur in
                        NavigationLink(destination: FormateurDetailView(formateur: formateur)) {
                            FormateurRowView(formateur: formateur)
                        }
                    }
                }
                .refreshable {
                    await viewModel.fetchFormateurs()
                }
                .searchable(text: $searchText, prompt: "Rechercher un formateur")
                .navigationTitle("Formateurs")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddSheet = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                if viewModel.isLoading && viewModel.formateurs.isEmpty {
                    ProgressView()
                }
            }
            .sheet(isPresented: $showAddSheet) {
                FormateurFormView()
                    .environmentObject(viewModel)
            }
        }
        .task {
            if viewModel.formateurs.isEmpty {
                await viewModel.fetchFormateurs()
            }
        }
    }
}

struct FormateurRowView: View {
    let formateur: FormateurModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar with initials
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(formateur.initials)
                        .font(.headline)
                        .foregroundColor(.blue)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(formateur.fullName)
                    .font(.headline)
                
                if let specialites = formateur.specialites, !specialites.isEmpty {
                    Text(specialites.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                if let tarif = formateur.tarifJournalier {
                    Text(String(format: "%.2f €/jour", tarif))
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            // Status indicator
            if formateur.actif {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
            }
        }
        .padding(.vertical, 4)
    }
}
