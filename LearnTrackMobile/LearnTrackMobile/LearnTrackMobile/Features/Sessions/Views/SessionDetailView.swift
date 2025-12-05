import SwiftUI

struct SessionDetailView: View {
    let session: SessionModel
    @EnvironmentObject var viewModel: SessionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showEditSheet = false
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 10) {
                    Text(session.titre)
                        .font(.title)
                        .bold()
                    
                    HStack {
                        Text(session.statut)
                            .padding(6)
                            .background(statusColor(session.statut).opacity(0.2))
                            .foregroundColor(statusColor(session.statut))
                            .cornerRadius(5)
                    }
                }
                
                Divider()
                
                // Dates
                VStack(alignment: .leading, spacing: 8) {
                    Label("Dates", systemImage: "calendar")
                        .font(.headline)
                    Text("Du \(session.dateDebut) au \(session.dateFin)")
                        .font(.subheadline)
                    
                    if let heureDebut = session.heureDebut, let heureFin = session.heureFin {
                        Text("De \(heureDebut) à \(heureFin)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                // Description
                if let description = session.description {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Description", systemImage: "text.alignleft")
                            .font(.headline)
                        Text(description)
                            .font(.subheadline)
                    }
                    Divider()
                }
                
                // Prix
                if let prix = session.prix {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Prix", systemImage: "eurosign.circle")
                            .font(.headline)
                        Text(String(format: "%.2f €", prix))
                            .font(.title3)
                            .foregroundColor(.green)
                    }
                    Divider()
                }
                
                // Participants
                if let nbParticipants = session.nbParticipants {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Participants", systemImage: "person.3")
                            .font(.headline)
                        Text("\(nbParticipants) participant(s)")
                            .font(.subheadline)
                    }
                    Divider()
                }
                
                // Notes
                if let notes = session.notes {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Notes", systemImage: "note.text")
                            .font(.headline)
                        Text(notes)
                            .font(.subheadline)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Menu {
                Button {
                    showEditSheet = true
                } label: {
                    Label("Modifier", systemImage: "pencil")
                }
                
                Button {
                    shareSession()
                } label: {
                    Label("Partager", systemImage: "square.and.arrow.up")
                }
                
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("Supprimer", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
        .alert("Supprimer la session", isPresented: $showDeleteAlert) {
            Button("Annuler", role: .cancel) { }
            Button("Supprimer", role: .destructive) {
                Task {
                    let success = await viewModel.deleteSession(id: session.id)
                    if success {
                        dismiss()
                    }
                }
            }
        } message: {
            Text("Êtes-vous sûr de vouloir supprimer cette session ?")
        }
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
    
    func shareSession() {
        let text = """
        Session: \(session.titre)
        Date: \(session.dateDebut) - \(session.dateFin)
        Statut: \(session.statut)
        """
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
