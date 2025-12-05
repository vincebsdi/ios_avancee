import SwiftUI

struct FormateurDetailView: View {
    let formateur: FormateurModel
    @EnvironmentObject var viewModel: FormateurViewModel
    @State private var sessions: [SessionModel] = []
    @State private var isLoadingSessions = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with avatar
                VStack(spacing: 15) {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(formateur.initials)
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                        )
                    
                    Text(formateur.fullName)
                        .font(.title2)
                        .bold()
                    
                    if let specialites = formateur.specialites, !specialites.isEmpty {
                        Text(specialites.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                Divider()
                
                // Quick actions
                HStack(spacing: 20) {
                    if let telephone = formateur.telephone {
                        Button(action: { callPhone(telephone) }) {
                            VStack {
                                Image(systemName: "phone.fill")
                                    .font(.title2)
                                Text("Appeler")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(10)
                        }
                    }
                    
                    Button(action: { sendEmail(formateur.email) }) {
                        VStack {
                            Image(systemName: "envelope.fill")
                                .font(.title2)
                            Text("Email")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Contact info
                VStack(alignment: .leading, spacing: 15) {
                    Text("Coordonnées")
                        .font(.headline)
                    
                    InfoRow(icon: "envelope", title: "Email", value: formateur.email)
                    
                    if let telephone = formateur.telephone {
                        InfoRow(icon: "phone", title: "Téléphone", value: telephone)
                    }
                    
                    if let adresse = formateur.adresse {
                        InfoRow(icon: "mappin", title: "Adresse", value: adresse)
                    }
                    
                    if let ville = formateur.ville {
                        InfoRow(icon: "location", title: "Ville", value: ville)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                
                // Professional info
                if formateur.tarifJournalier != nil || formateur.notes != nil {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Informations professionnelles")
                            .font(.headline)
                        
                        if let tarif = formateur.tarifJournalier {
                            InfoRow(icon: "eurosign.circle", title: "Tarif journalier", value: String(format: "%.2f €", tarif))
                        }
                        
                        if let notes = formateur.notes {
                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Image(systemName: "note.text")
                                        .foregroundColor(.gray)
                                    Text("Notes")
                                        .foregroundColor(.gray)
                                }
                                Text(notes)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                }
                
                // Sessions history
                VStack(alignment: .leading, spacing: 10) {
                    Text("Historique des sessions")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    if isLoadingSessions {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else if sessions.isEmpty {
                        Text("Aucune session")
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    } else {
                        ForEach(sessions) { session in
                            VStack(alignment: .leading, spacing: 5) {
                                Text(session.titre)
                                    .font(.subheadline)
                                    .bold()
                                Text(session.dateDebut)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadSessions()
        }
    }
    
    func loadSessions() async {
        isLoadingSessions = true
        sessions = await viewModel.getFormateurSessions(formateurId: formateur.id)
        isLoadingSessions = false
    }
    
    func callPhone(_ phone: String) {
        if let url = URL(string: "tel://\(phone.replacingOccurrences(of: " ", with: ""))") {
            UIApplication.shared.open(url)
        }
    }
    
    func sendEmail(_ email: String) {
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.subheadline)
            }
        }
    }
}
