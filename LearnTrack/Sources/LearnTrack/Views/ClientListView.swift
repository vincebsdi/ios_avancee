import SwiftUI

struct ClientListView: View {
    @StateObject private var viewModel = ClientViewModel()
    @State private var searchText = ""
    
    var filteredClients: [Client] {
        if searchText.isEmpty {
            return viewModel.clients
        } else {
            return viewModel.clients.filter { $0.raisonSociale.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredClients) { client in
                NavigationLink(destination: Text(client.raisonSociale)) { // Placeholder detail
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 40, height: 40)
                            .overlay(Text(String(client.raisonSociale.prefix(2))))
                        
                        VStack(alignment: .leading) {
                            Text(client.raisonSociale)
                                .font(.headline)
                            Text(client.ville)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Clients")
        }
        .task {
            await viewModel.fetchClients()
        }
    }
}
