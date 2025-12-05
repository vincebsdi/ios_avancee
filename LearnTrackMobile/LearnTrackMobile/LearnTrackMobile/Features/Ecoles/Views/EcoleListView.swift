import SwiftUI

struct EcoleListView: View {
    @EnvironmentObject var viewModel: EcoleViewModel
    @State private var searchText = ""
    @State private var showAddSheet = false
    
    var filteredEcoles: [EcoleModel] {
        if searchText.isEmpty {
            return viewModel.ecoles
        } else {
            return viewModel.ecoles.filter {
                $0.nom.localizedCaseInsensitiveContains(searchText) ||
                ($0.ville?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(filteredEcoles) { ecole in
                        NavigationLink(destination: EcoleDetailView(ecole: ecole)) {
                            EcoleRowView(ecole: ecole)
                        }
                    }
                }
                .refreshable {
                    await viewModel.fetchEcoles()
                }
                .searchable(text: $searchText, prompt: "Rechercher une école")
                .navigationTitle("Écoles")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddSheet = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                if viewModel.isLoading && viewModel.ecoles.isEmpty {
                    ProgressView()
                }
            }
            .sheet(isPresented: $showAddSheet) {
                EcoleFormView()
                    .environmentObject(viewModel)
            }
        }
        .task {
            if viewModel.ecoles.isEmpty {
                await viewModel.fetchEcoles()
            }
        }
    }
}

struct EcoleRowView: View {
    let ecole: EcoleModel
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.purple.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(ecole.initials)
                        .font(.headline)
                        .foregroundColor(.purple)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ecole.nom)
                    .font(.headline)
                
                if let ville = ecole.ville {
                    Text(ville)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let capacite = ecole.capacite {
                    Text("\(capacite) places")
                        .font(.caption)
                        .foregroundColor(.purple)
                }
            }
            
            Spacer()
            
            if ecole.actif {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
            }
        }
        .padding(.vertical, 4)
    }
}
