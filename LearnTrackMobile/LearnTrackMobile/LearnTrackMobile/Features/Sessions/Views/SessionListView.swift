import SwiftUI

struct SessionListView: View {
    @EnvironmentObject var viewModel: SessionViewModel
    @EnvironmentObject var formateurVM: FormateurViewModel
    @EnvironmentObject var clientVM: ClientViewModel
    @EnvironmentObject var ecoleVM: EcoleViewModel
    
    @State private var searchText = ""
    @State private var showAddSheet = false
    
    var filteredSessions: [SessionModel] {
        if searchText.isEmpty {
            return viewModel.sessions
        } else {
            return viewModel.sessions.filter { $0.titre.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(filteredSessions) { session in
                        NavigationLink(destination: SessionDetailView(session: session)) {
                            SessionRowView(session: session)
                        }
                    }
                }
                .refreshable {
                    await viewModel.fetchSessions()
                }
                .searchable(text: $searchText, prompt: "Rechercher une session")
                .navigationTitle("Sessions")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddSheet = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                if viewModel.isLoading && viewModel.sessions.isEmpty {
                    ProgressView()
                }
            }
            .sheet(isPresented: $showAddSheet) {
                SessionFormView()
                    .environmentObject(viewModel)
                    .environmentObject(formateurVM)
                    .environmentObject(clientVM)
                    .environmentObject(ecoleVM)
            }
        }
        .task {
            if viewModel.sessions.isEmpty {
                await viewModel.fetchSessions()
            }
        }
    }
}

struct SessionRowView: View {
    let session: SessionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(session.titre)
                .font(.headline)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                Text(session.dateDebut)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(session.statut)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor(session.statut).opacity(0.2))
                    .foregroundColor(statusColor(session.statut))
                    .cornerRadius(8)
            }
            
            if let prix = session.prix {
                Text(String(format: "%.2f €", prix))
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
    
    func statusColor(_ status: String) -> Color {
        switch status.lowercased() {
        case "planifiée", "planifiee": return .blue
        case "confirmée", "confirmee": return .green
        case "terminée", "terminee": return .gray
        case "annulée", "annulee": return .red
        default: return .gray
        }
    }
}
