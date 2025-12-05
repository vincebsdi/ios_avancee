import SwiftUI

struct ClientListView: View {
    @EnvironmentObject var viewModel: ClientViewModel
    @State private var searchText = ""
    @State private var showAddSheet = false
    
    var filteredClients: [ClientModel] {
        if searchText.isEmpty {
            return viewModel.clients
        } else {
            return viewModel.clients.filter {
                $0.nom.localizedCaseInsensitiveContains(searchText) ||
                ($0.ville?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(filteredClients) { client in
                        NavigationLink(destination: ClientDetailView(client: client)) {
                            ClientRowView(client: client)
                        }
                    }
                }
                .refreshable {
                    await viewModel.fetchClients()
                }
                .searchable(text: $searchText, prompt: "Rechercher un client")
                .navigationTitle("Clients")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddSheet = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                if viewModel.isLoading && viewModel.clients.isEmpty {
                    ProgressView()
                }
            }
            .sheet(isPresented: $showAddSheet) {
                ClientFormView()
                    .environmentObject(viewModel)
            }
        }
        .task {
            if viewModel.clients.isEmpty {
                await viewModel.fetchClients()
            }
        }
    }
}

struct ClientRowView: View {
    let client: ClientModel
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.green.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(client.initials)
                        .font(.headline)
                        .foregroundColor(.green)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(client.nom)
                    .font(.headline)
                
                if let ville = client.ville {
                    Text(ville)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if client.actif {
                Circle()
                    .fill(Color.green)
                    .frame(width: 10, height: 10)
            }
        }
        .padding(.vertical, 4)
    }
}
