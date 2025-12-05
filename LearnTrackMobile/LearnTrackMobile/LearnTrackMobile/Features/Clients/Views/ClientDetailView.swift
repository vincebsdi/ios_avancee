import SwiftUI

struct ClientDetailView: View {
    let client: ClientModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(spacing: 15) {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(client.initials)
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        )
                    
                    Text(client.nom)
                        .font(.title2)
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                Divider()
                
                // Quick actions
                HStack(spacing: 20) {
                    if let telephone = client.telephone {
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
                    
                    if let email = client.email {
                        Button(action: { sendEmail(email) }) {
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
                }
                .padding(.horizontal)
                
                Divider()
                
                // Contact info
                VStack(alignment: .leading, spacing: 15) {
                    Text("Coordonnées")
                        .font(.headline)
                    
                    if let email = client.email {
                        InfoRow(icon: "envelope", title: "Email", value: email)
                    }
                    
                    if let telephone = client.telephone {
                        InfoRow(icon: "phone", title: "Téléphone", value: telephone)
                    }
                    
                    if let adresse = client.adresse {
                        InfoRow(icon: "mappin", title: "Adresse", value: adresse)
                    }
                    
                    if let ville = client.ville {
                        InfoRow(icon: "location", title: "Ville", value: ville)
                    }
                }
                .padding(.horizontal)
                
                if client.siret != nil || client.contactNom != nil {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Informations complémentaires")
                            .font(.headline)
                        
                        if let siret = client.siret {
                            InfoRow(icon: "building.2", title: "SIRET", value: siret)
                        }
                        
                        if let contactNom = client.contactNom {
                            InfoRow(icon: "person", title: "Contact", value: contactNom)
                        }
                        
                        if let contactEmail = client.contactEmail {
                            InfoRow(icon: "envelope", title: "Email contact", value: contactEmail)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
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
