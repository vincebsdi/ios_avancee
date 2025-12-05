import SwiftUI

struct SessionListView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var searchText = ""
    @State private var selectedMonthFilter = 1 // 0: Prev, 1: Curr, 2: Next
    @State private var showAddSheet = false
    
    var filteredSessions: [Session] {
        // Implement filtering logic here based on searchText and selectedMonthFilter
        // For now just return all
        if searchText.isEmpty {
            return viewModel.sessions
        } else {
            return viewModel.sessions.filter { $0.module.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(filteredSessions) { session in
                        NavigationLink(destination: SessionDetailView(session: session)) {
                            SessionCardView(session: session)
                        }
                    }
                }
                .refreshable {
                    await viewModel.fetchSessions()
                }
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker("Mois", selection: $selectedMonthFilter) {
                            Text("Précédent").tag(0)
                            Text("Actuel").tag(1)
                            Text("Prochain").tag(2)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 200)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddSheet = true }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .navigationTitle("Sessions")
            }
            .sheet(isPresented: $showAddSheet) {
                SessionFormView(viewModel: viewModel)
            }
        }
        .task {
            await viewModel.fetchSessions()
        }
    }
}

struct SessionCardView: View {
    let session: Session
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(session.module)
                .font(.headline)
            HStack {
                Image(systemName: "calendar")
                Text(session.date.formatted(date: .abbreviated, time: .omitted))
                Spacer()
                Text(session.modalite.rawValue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
