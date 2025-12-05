import SwiftUI

struct SessionDetailView: View {
    let session: Session
    @EnvironmentObject var viewModel: SessionViewModel // Assuming we pass it or use environment
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading) {
                    Text(session.module)
                        .font(.title)
                        .bold()
                    HStack {
                        Text(session.modalite.rawValue)
                            .padding(6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(5)
                        Text(session.status.rawValue)
                            .padding(6)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }
                }
                
                Divider()
                
                // Date & Time
                HStack {
                    Image(systemName: "calendar")
                        .font(.title2)
                    VStack(alignment: .leading) {
                        Text(session.date.formatted(date: .long, time: .omitted))
                        Text("\(session.startTime.formatted(date: .omitted, time: .shortened)) - \(session.endTime.formatted(date: .omitted, time: .shortened))")
                            .foregroundColor(.secondary)
                    }
                }
                
                // Location
                if let lieu = session.lieu {
                    HStack {
                        Image(systemName: "map")
                            .font(.title2)
                        Text(lieu)
                    }
                }
                
                Divider()
                
                // Intervenants (Placeholder)
                Text("Intervenants")
                    .font(.headline)
                // TODO: Fetch and display Formateur, Client names using IDs
                
                Divider()
                
                // Tarifs
                Text("Tarifs")
                    .font(.headline)
                if let tarif = session.tarifClient {
                    HStack {
                        Text("Client")
                        Spacer()
                        Text(String(format: "%.2f €", tarif))
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Menu {
                Button("Modifier", action: {})
                Button("Partager", action: {})
                Button("Supprimer", role: .destructive, action: {})
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
    }
}
